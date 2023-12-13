/* Copyright 2023 The StableHLO Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#ifndef STABLEHLO_EXPERIMENTAL_DIALECT_STABLEHLO_OPS_H
#define STABLEHLO_EXPERIMENTAL_DIALECT_STABLEHLO_OPS_H

// This file supports XLA-specific experiments with the StableHLO opset.
// These experiments are not yet ready to be upstreamed to openxla/stablehlo
// and are incubating towards the respective StableHLO RFCs.
//
// Custom calls (which are the implementation vehicle of these experiments)
// don't have compatibility guarantees within the StableHLO process, but
// the StableHLO team at Google provides out-of-band guarantees for these
// custom calls, with the same compatibility window as StableHLO upstream.

#include "mlir/IR/Operation.h"
#include "mlir/IR/Region.h"
#include "mlir/IR/Value.h"
#include "mlir/IR/ValueRange.h"
#include "mlir/Support/LogicalResult.h"
#include "stablehlo/dialect/StablehloOps.h"
#include "stablehlo/experimental/dialect/Base.h"

namespace mlir {
namespace stablehlo {
namespace experimental {

// The DynamicReduceWindowOp experiment provides a dynamic version of
// ReduceWindowOp. Once the dynamism RFC is figured out, we expect to have an
// upstream representation for this notion.
//
// Within this experiment, DynamicReduceWindowOp is represented via the
// `stablehlo.custom_call @stablehlo.dynamic_reduce_window` custom call.
// This custom call has the following operands which represent a dynamic version
// of operands and attributes of ReduceWindowOp:
//   * [0:N]   => inputs
//   * [N:2*N] => init_values
//   * [-5]    => window_dimensions
//   * [-4]    => window_strides
//   * [-3]    => base_dilations
//   * [-2]    => window_dilations
//   * [-1]    => padding
// Additionally, to represent the body of DynamicReduceWindowOp, the custom call
// has a satellite function attached to the custom call via called_computations.
//
// Semantics of DynamicReduceWindowOp are inherited from semantics of
// https://github.com/openxla/stablehlo/blob/main/docs/spec.md#reduce_window
// with the following exceptions:
//   1) All tensor constants, i.e. window_dimensions, window_strides,
//      base_dilations, window_dilations and padding, become tensors of
//      integer type.
//   2) As a result, some of the constraints can no longer be validated
//      statically. However, this operation still expects these constraints
//      to hold dynamically, and if they don't hold, the behavior is undefined.
class DynamicReduceWindowOpAdaptor {
 public:
  DynamicReduceWindowOpAdaptor(CustomCallOp op) : op_(op) {}
  operator Operation*() { return op_; }
  Operation* operator->() { return op_; }

  // Same accessors as for stablehlo::ReduceWindowOp, except that all the
  // std::optional<DenseIntElementsAttr> attributes have turned into values.
  // These accessors assume that the operation is well-formed (i.e. that it
  // can pass verification).
  ValueRange getInputs();
  ValueRange getInitValues();
  TypedValue<ShapedType> getWindowDimensions();
  TypedValue<ShapedType> getWindowStrides();
  TypedValue<ShapedType> getBaseDilations();
  TypedValue<ShapedType> getWindowDilations();
  TypedValue<ShapedType> getPadding();
  Region& getBody();
  ValueRange getResults();

  // Verifies the constraints documented above.
  // Emits errors if errors are detected.
  LogicalResult verify();

 private:
  CustomCallOp op_;
};

// Wraps a custom call in a DynamicReduceWindowOpAdaptor.
// Fails if the call_target_name of the custom call doesn't match
// "stablehlo.dynamic_reduce_window".
std::optional<DynamicReduceWindowOpAdaptor> getDynamicReduceWindowOp(
    CustomCallOp op);

// The DynamicRngBitGeneratorOp experiment provides a dynamic version of
// RngBitGeneratorOp. Once the dynamism RFC is figured out, we expect to have an
// upstream representation for this notion.
//
// Within this experiment, DynamicRngBitGeneratorOp is represented via the
// `stablehlo.custom_call @stablehlo.dynamic_rng_bit_generator` custom call.
// This custom call has the regular operand of RngBitGeneratorOp plus an
// additional `output_shape` operand that determines the shape of the output:
//   * [0] => initial_state
//   * [1] => output_shape
//
// Semantics of DynamicRngBitGeneratorOp are inherited from semantics of
// https://github.com/openxla/stablehlo/blob/main/docs/spec.md#rng_bit_generator
// extended with an additional input (I3) and an additional constraint (C3):
//
// #### Inputs
//
// | Label | Name            | Type                                         |
// |-------|-----------------|----------------------------------------------|
// | (I1)  | `rng_algorithm` | enum of `DEFAULT`, `THREE_FRY`, and `PHILOX` |
// | (I2)  | `initial_state` | 1-dimensional tensor of type `ui64`          |
// | (I3)  | `output_shape`  | 1-dimensional tensor of integer type         |
//
// #### Outputs
//
// | Name           | Type                                     |
// |----------------|------------------------------------------|
// | `output_state` | 1-dimensional tensor of type `ui64`      |
// | `output`       | tensor of integer or floating-point type |
//
// #### Constraints
//
// * (C1) `type(initial_state) = type(output_state)`.
// * (C2) `size(initial_state)` is defined as:
//   * implementation-defined if `rng_algorithm = DEFAULT`.
//   * `2` if `rng_algorithm = THREE_FRY`.
//   * `2` or `3` if `rng_algorithm = PHILOX`.
// * (C3) `shape(output) = output_shape`.
class DynamicRngBitGeneratorOpAdaptor {
 public:
  DynamicRngBitGeneratorOpAdaptor(CustomCallOp op) : op_(op) {}
  operator Operation*() { return op_; }
  Operation* operator->() { return op_; }

  // Same accessors as for stablehlo::RngBitGeneratorOp, extended with the
  // additional `output_shape` operand.
  // These accessors assume that the operation is well-formed (i.e. that it
  // can pass verification).
  RngAlgorithm getRngAlgorithm();
  TypedValue<ShapedType> getInitialState();
  TypedValue<ShapedType> getOutputShape();
  TypedValue<ShapedType> getOutputState();
  TypedValue<ShapedType> getOutput();

  // Verifies the constraints documented above.
  // Emits errors if errors are detected.
  LogicalResult verify();

 private:
  CustomCallOp op_;
};

// Wraps a custom call in a DynamicRngBitGeneratorOpAdaptor.
// Fails if the call_target_name of the custom call doesn't match
// "stablehlo.dynamic_rng_bit_generator".
std::optional<DynamicRngBitGeneratorOpAdaptor> getDynamicRngBitGeneratorOp(
    CustomCallOp op);

// The DynamicTopKOp experiment provides a dynamic version of
// TopKOp. Once the dynamism RFC is figured out, we expect to have an
// upstream representation for this notion.
//
// Within this experiment, DynamicTopKOp is represented via the
// `stablehlo.custom_call @stablehlo.dynamic_top_k` custom call.
// This custom call has the regular operand of TopKOp plus an
// additional `k` operand that determines the shape of the output.
//
// Semantics of DynamicTopKOp are inherited from semantics of Chlo.TopKOp.
//
// #### Inputs
//
// | Label | Name            | Type                                         |
// |-------|-----------------|----------------------------------------------|
// | (I1)  | `operand`       | tensor of integer or floating-point type     |
// | (I2)  | `k`             | 0-dimensional tensor of integer or index type|
//
// #### Outputs
//
// | Name           | Type                                     |
// |----------------|------------------------------------------|
// | `values`       | tensor of integer or floating-point type |
// | `indices`      | tensor of si32 type                      |
//
// #### Constraints
//
// * (C1) `shape(values)[:-1] = shape(operand)[:-1]`
// * (C2) `element_type(values) = element_type(operand)`
// * (C3) `shape(values)[-1] <= shape(operand)[-1]`
// * (C4) `shape(indices) = shape(values)`
class DynamicTopKOpAdaptor {
 public:
  DynamicTopKOpAdaptor(CustomCallOp op) : op_(op) {}
  operator Operation*() { return op_; }
  Operation* operator->() { return op_; }

  // These accessors assume that the operation is well-formed (i.e. that it
  // can pass verification).
  TypedValue<ShapedType> getOperand();
  TypedValue<ShapedType> getK();
  TypedValue<ShapedType> getValues();
  TypedValue<ShapedType> getIndices();

  // Verifies the constraints documented above.
  // Emits errors if errors are detected.
  LogicalResult verify();

 private:
  CustomCallOp op_;
};

// Wraps a custom call in a DynamicTopKOpAdaptor.
// Fails if the call_target_name of the custom call doesn't match
// "stablehlo.dynamic_top_k".
std::optional<DynamicTopKOpAdaptor> getDynamicTopKOp(CustomCallOp op);

///////////////////
// MHLO Op Wrappers
// There are some ops in MHLO which have experimental support in StableHLO
// programs by representing them as custom_calls with the target `mhlo.op_name`.
// The level of support of these ops is similar to the other custom_calls in
// this file. Generally these ops will be added to StableHLO and their
// experimental support can be deprecated in favor of op's type inference.
///////////////////

// The TopK experiment provides a StableHLO adapter to MHLO TopKOp.
// In the future we expect stablehlo.top_k to be added which will use the same
// refinement rules.
//
// Within this experiment, TopKOp is represented via the serialized MHLO
// `stablehlo.custom_call @mhlo.topk` custom call.
//
// The semantics of experimental TopKOp are inherited from the semantics of
// mhlo.topk.
//
// #### Inputs
//
// | Label | Name            | Type                                         |
// |-------|-----------------|----------------------------------------------|
// | (I1)  | `operand`       | tensor of integer or floating-point type     |
// | (I2)  | `k`             | constant of type si64                        |
// | (I3)  | `largest`       | constant of type i1                          |
//
// #### Outputs
//
// | Name           | Type                                     |
// |----------------|------------------------------------------|
// | `values`       | tensor of integer or floating-point type |
// | `indices`      | tensor of si32 type                      |
//
// #### Constraints
//
// * (C1) `shape(values)[:-1] = shape(operand)[:-1]`
// * (C2) `shape(values)[-1] = k`
// * (C3) `element_type(values) = element_type(operand)`
// * (C4) `shape(indices) = shape(values)`
// * (C5) `k >= 0`
//
class TopKOpAdaptor {
 public:
  TopKOpAdaptor(CustomCallOp op) : op_(op) {}
  operator Operation*() { return op_; }
  Operation* operator->() { return op_; }

  // These accessors assume that the operation is well-formed (i.e. that it
  // can pass verification).
  TypedValue<ShapedType> getOperand();
  TypedValue<ShapedType> getValues();
  TypedValue<ShapedType> getIndices();
  int64_t getK();
  bool getLargest();

  // Verifies the constraints documented above.
  // Emits errors if errors are detected.
  LogicalResult verify();

 private:
  CustomCallOp op_;
};

// Wraps a custom call in a TopKOpAdaptor.
// Fails if the call_target_name of the custom call doesn't match
// "mhlo.topk".
std::optional<TopKOpAdaptor> getTopKOp(CustomCallOp op);

}  // namespace experimental
}  // namespace stablehlo
}  // namespace mlir

#endif  // STABLEHLO_EXPERIMENTAL_DIALECT_STABLEHLO_OPS_H
