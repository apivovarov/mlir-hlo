// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xf32>, tensor<3x2x4xf32>)
    %2 = call @expected() : () -> tensor<3x5x4xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xf32>, tensor<2x1xi32>, tensor<3x2x4xf32>) -> tensor<3x5x4xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xf32>, tensor<3x5x4xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xf32>, tensor<3x2x4xf32>) {
    %0 = stablehlo.constant dense<[[[4.24478674, 3.86827397, -2.43493819, 2.05139446], [-0.89943248, 2.82788277, 0.86208254, 2.32477951], [-0.0918131247, -5.60720158, -6.06350279, -1.41214228], [-3.11885214, -1.56018901, -5.743620e-01, 2.65182543], [-0.252302825, -5.38761473, 3.09350348, -0.524730384]], [[1.60065794, 0.699411035, 3.47338176, -0.529724121], [5.04692125, -3.0344696, 1.82694352, -1.74638569], [-1.46364844, 0.157018065, 3.4870379, -4.46960878], [-1.93555963, -0.156598106, 0.144896582, -0.427126765], [0.310405463, 5.63829184, -6.68862534, -0.527657747]], [[-0.806461393, 4.29795122, -1.25742364, -2.37719345], [-1.97653174, -1.65398347, -2.38028836, 1.89819694], [5.75848436, -5.37792683, 4.3457551, -3.49929643], [-7.47394609, -0.409498781, -1.4077729, -2.97457099], [0.0785050317, -0.365164161, 3.07180166, -0.118581019]]]> : tensor<3x5x4xf32>
    %1 = stablehlo.constant dense<[[[5.45896196, -3.43881488, 2.91289949, 0.6330325], [2.42488313, -9.84783458, 3.71845865, 2.95315433]], [[2.0089798, 3.69347882, -2.17107487, -4.97527885], [-1.81241775, -2.50568676, 1.15265787, -5.29542398]], [[-3.23657584, 2.08662534, -2.34390235, -1.2453866], [-3.66094875, -0.881780743, 0.597904623, -0.453830153]]]> : tensor<3x2x4xf32>
    return %0, %1 : tensor<3x5x4xf32>, tensor<3x2x4xf32>
  }
  func.func private @expected() -> tensor<3x5x4xf32> {
    %0 = stablehlo.constant dense<[[[4.24478674, 3.86827397, -2.43493819, 2.05139446], [-0.89943248, -9.84783458, 0.86208254, 0.6330325], [-0.0918131247, -5.60720158, -6.06350279, -1.41214228], [-3.11885214, -1.56018901, -5.743620e-01, 2.65182543], [-0.252302825, -5.38761473, 3.09350348, -0.524730384]], [[1.60065794, 0.699411035, 3.47338176, -0.529724121], [-1.81241775, -3.0344696, -2.17107487, -5.29542398], [-1.46364844, 0.157018065, 3.4870379, -4.46960878], [-1.93555963, -0.156598106, 0.144896582, -0.427126765], [0.310405463, 5.63829184, -6.68862534, -0.527657747]], [[-0.806461393, 4.29795122, -1.25742364, -2.37719345], [-3.66094875, -1.65398347, -2.38028836, -1.2453866], [5.75848436, -5.37792683, 4.3457551, -3.49929643], [-7.47394609, -0.409498781, -1.4077729, -2.97457099], [0.0785050317, -0.365164161, 3.07180166, -0.118581019]]]> : tensor<3x5x4xf32>
    return %0 : tensor<3x5x4xf32>
  }
}

