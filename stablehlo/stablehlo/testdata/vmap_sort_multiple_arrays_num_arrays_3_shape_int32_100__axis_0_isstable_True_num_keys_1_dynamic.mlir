// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x100xi32> {mhlo.sharding = ""}, %arg2: tensor<?x100xi32> {mhlo.sharding = ""}, %arg3: tensor<?x100xf32> {mhlo.sharding = ""}) -> (tensor<?x100xi32>, tensor<?x100xi32>, tensor<?x100xf32>) {
    %0:3 = "stablehlo.sort"(%arg1, %arg2, %arg3) ({
    ^bb0(%arg4: tensor<i32>, %arg5: tensor<i32>, %arg6: tensor<i32>, %arg7: tensor<i32>, %arg8: tensor<f32>, %arg9: tensor<f32>):
      %1 = stablehlo.compare  LT, %arg4, %arg5,  SIGNED : (tensor<i32>, tensor<i32>) -> tensor<i1>
      stablehlo.return %1 : tensor<i1>
    }) {dimension = 1 : i64, is_stable = true} : (tensor<?x100xi32>, tensor<?x100xi32>, tensor<?x100xf32>) -> (tensor<?x100xi32>, tensor<?x100xi32>, tensor<?x100xf32>)
    return %0#0, %0#1, %0#2 : tensor<?x100xi32>, tensor<?x100xi32>, tensor<?x100xf32>
  }
}

