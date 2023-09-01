// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x3x5x40xf32> {mhlo.sharding = ""}, %arg2: tensor<?x3x5x2xf32> {mhlo.sharding = ""}) -> tensor<?x3x5x40xf32> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi64>
    %1 = "stablehlo.scatter"(%arg1, %0, %arg2) ({
    ^bb0(%arg3: tensor<f32>, %arg4: tensor<f32>):
      %2 = stablehlo.minimum %arg3, %arg4 : tensor<f32>
      stablehlo.return %2 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1, 2], inserted_window_dims = [3], scatter_dims_to_operand_dims = [3], index_vector_dim = 1>} : (tensor<?x3x5x40xf32>, tensor<2x1xi64>, tensor<?x3x5x2xf32>) -> tensor<?x3x5x40xf32>
    return %1 : tensor<?x3x5x40xf32>
  }
}

