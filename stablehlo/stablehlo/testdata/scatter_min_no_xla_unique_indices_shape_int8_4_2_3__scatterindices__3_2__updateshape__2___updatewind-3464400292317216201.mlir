// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[3, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<4x2x3xi8>, tensor<2xi8>)
    %2 = call @expected() : () -> tensor<4x2x3xi8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i8>
      stablehlo.return %5 : tensor<i8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [0, 2], scatter_dims_to_operand_dims = [0, 2]>, unique_indices = true} : (tensor<4x2x3xi8>, tensor<2xi32>, tensor<2xi8>) -> tensor<4x2x3xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<4x2x3xi8>, tensor<4x2x3xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x2x3xi8>, tensor<2xi8>) {
    %0 = stablehlo.constant dense<[[[-2, -4, -1], [1, 1, 0]], [[-2, -1, 0], [2, -4, -3]], [[0, 1, 1], [3, -2, 0]], [[0, -3, -1], [3, 2, 0]]]> : tensor<4x2x3xi8>
    %1 = stablehlo.constant dense<1> : tensor<2xi8>
    return %0, %1 : tensor<4x2x3xi8>, tensor<2xi8>
  }
  func.func private @expected() -> tensor<4x2x3xi8> {
    %0 = stablehlo.constant dense<[[[-2, -4, -1], [1, 1, 0]], [[-2, -1, 0], [2, -4, -3]], [[0, 1, 1], [3, -2, 0]], [[0, -3, -1], [3, 2, 0]]]> : tensor<4x2x3xi8>
    return %0 : tensor<4x2x3xi8>
  }
}

