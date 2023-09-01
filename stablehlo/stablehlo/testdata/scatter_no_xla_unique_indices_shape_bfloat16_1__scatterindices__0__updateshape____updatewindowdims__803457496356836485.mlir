// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1xbf16>, tensor<bf16>)
    %2 = call @expected() : () -> tensor<1xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      stablehlo.return %arg1 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<inserted_window_dims = [0], scatter_dims_to_operand_dims = [0]>, unique_indices = true} : (tensor<1xbf16>, tensor<1xi32>, tensor<bf16>) -> tensor<1xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1xbf16>, tensor<1xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1xbf16>, tensor<bf16>) {
    %0 = stablehlo.constant dense<5.507810e-01> : tensor<1xbf16>
    %1 = stablehlo.constant dense<2.296880e+00> : tensor<bf16>
    return %0, %1 : tensor<1xbf16>, tensor<bf16>
  }
  func.func private @expected() -> tensor<1xbf16> {
    %0 = stablehlo.constant dense<2.296880e+00> : tensor<1xbf16>
    return %0 : tensor<1xbf16>
  }
}

