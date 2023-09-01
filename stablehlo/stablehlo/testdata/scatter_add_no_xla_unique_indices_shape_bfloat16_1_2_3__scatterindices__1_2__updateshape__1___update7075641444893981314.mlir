// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[1, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xbf16>, tensor<1xbf16>)
    %2 = call @expected() : () -> tensor<1x2x3xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2]>, unique_indices = true} : (tensor<1x2x3xbf16>, tensor<2xi32>, tensor<1xbf16>) -> tensor<1x2x3xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xbf16>, tensor<1x2x3xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xbf16>, tensor<1xbf16>) {
    %0 = stablehlo.constant dense<[[[4.468750e+00, 1.984380e+00, 1.820310e+00], [6.328130e-01, -2.687500e+00, -4.031250e+00]]]> : tensor<1x2x3xbf16>
    %1 = stablehlo.constant dense<-8.632810e-01> : tensor<1xbf16>
    return %0, %1 : tensor<1x2x3xbf16>, tensor<1xbf16>
  }
  func.func private @expected() -> tensor<1x2x3xbf16> {
    %0 = stablehlo.constant dense<[[[4.468750e+00, 1.984380e+00, 1.820310e+00], [6.328130e-01, -2.687500e+00, -4.906250e+00]]]> : tensor<1x2x3xbf16>
    return %0 : tensor<1x2x3xbf16>
  }
}

