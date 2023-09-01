// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xi32>, tensor<1xi32>)
    %2 = call @expected() : () -> tensor<1x125xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<1x125xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xi32>, tensor<1x125xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xi32>, tensor<1xi32>) {
    %0 = stablehlo.constant dense<"0xFAFFFFFFFCFFFFFF000000000000000003000000FFFFFFFF00000000000000000000000000000000FDFFFFFF01000000FEFFFFFF0100000003000000020000000000000001000000FFFFFFFF07000000FEFFFFFFFCFFFFFF0400000002000000FFFFFFFFFFFFFFFF0200000002000000FFFFFFFFFCFFFFFF050000000300000000000000FBFFFFFF02000000FDFFFFFF00000000FFFFFFFFFAFFFFFF0000000000000000FFFFFFFF070000000000000001000000FDFFFFFF00000000050000000100000001000000FEFFFFFF040000000400000002000000010000000000000003000000FEFFFFFF00000000FFFFFFFF000000000300000002000000FFFFFFFF0500000000000000020000000300000001000000FDFFFFFF00000000FFFFFFFF01000000FFFFFFFFFFFFFFFF02000000FEFFFFFF000000000000000000000000FCFFFFFF060000000000000000000000050000000100000000000000FEFFFFFF0300000000000000FDFFFFFF02000000FEFFFFFF03000000FFFFFFFFFFFFFFFF0100000005000000000000000100000002000000FDFFFFFF00000000FEFFFFFF0000000000000000FEFFFFFFFFFFFFFF00000000FBFFFFFFFEFFFFFF000000000200000000000000FDFFFFFF00000000FDFFFFFF010000000100000000000000FDFFFFFFFEFFFFFF07000000FDFFFFFF03000000"> : tensor<1x125xi32>
    %1 = stablehlo.constant dense<-4> : tensor<1xi32>
    return %0, %1 : tensor<1x125xi32>, tensor<1xi32>
  }
  func.func private @expected() -> tensor<1x125xi32> {
    %0 = stablehlo.constant dense<"0x18000000FCFFFFFF000000000000000003000000FFFFFFFF00000000000000000000000000000000FDFFFFFF01000000FEFFFFFF0100000003000000020000000000000001000000FFFFFFFF07000000FEFFFFFFFCFFFFFF0400000002000000FFFFFFFFFFFFFFFF0200000002000000FFFFFFFFFCFFFFFF050000000300000000000000FBFFFFFF02000000FDFFFFFF00000000FFFFFFFFFAFFFFFF0000000000000000FFFFFFFF070000000000000001000000FDFFFFFF00000000050000000100000001000000FEFFFFFF040000000400000002000000010000000000000003000000FEFFFFFF00000000FFFFFFFF000000000300000002000000FFFFFFFF0500000000000000020000000300000001000000FDFFFFFF00000000FFFFFFFF01000000FFFFFFFFFFFFFFFF02000000FEFFFFFF000000000000000000000000FCFFFFFF060000000000000000000000050000000100000000000000FEFFFFFF0300000000000000FDFFFFFF02000000FEFFFFFF03000000FFFFFFFFFFFFFFFF0100000005000000000000000100000002000000FDFFFFFF00000000FEFFFFFF0000000000000000FEFFFFFFFFFFFFFF00000000FBFFFFFFFEFFFFFF000000000200000000000000FDFFFFFF00000000FDFFFFFF010000000100000000000000FDFFFFFFFEFFFFFF07000000FDFFFFFF03000000"> : tensor<1x125xi32>
    return %0 : tensor<1x125xi32>
  }
}

