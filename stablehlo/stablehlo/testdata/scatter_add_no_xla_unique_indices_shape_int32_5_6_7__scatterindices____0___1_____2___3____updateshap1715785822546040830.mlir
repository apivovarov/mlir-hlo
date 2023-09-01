// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x1xi32>, tensor<5x2x2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>) {
    %0 = stablehlo.constant dense<"0x00000000000000000000000001000000000000000200000000000000FDFFFFFF000000000000000000000000010000000100000000000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFFFFFF040000000000000002000000FDFFFFFF04000000FFFFFFFF00000000020000000900000000000000FEFFFFFFFFFFFFFF0100000000000000000000000000000002000000FFFFFFFF02000000FDFFFFFF03000000FDFFFFFF020000000000000001000000000000000300000001000000FEFFFFFFFAFFFFFFFEFFFFFF03000000FFFFFFFF060000000000000001000000000000000100000000000000FDFFFFFFFAFFFFFF010000000100000000000000000000000100000000000000FEFFFFFFFFFFFFFF0400000000000000FFFFFFFFFDFFFFFFFCFFFFFF03000000FDFFFFFF00000000FEFFFFFF02000000FDFFFFFF03000000FFFFFFFFFFFFFFFF0500000002000000010000000100000000000000FFFFFFFF00000000FFFFFFFF02000000FEFFFFFFFBFFFFFFFEFFFFFF0200000001000000FEFFFFFFFFFFFFFF0300000002000000FDFFFFFF01000000FEFFFFFF05000000FDFFFFFF020000000000000001000000050000000000000001000000FBFFFFFFFEFFFFFF010000000000000000000000030000000100000002000000FDFFFFFFFEFFFFFF01000000000000000100000001000000FFFFFFFFFEFFFFFFFFFFFFFF0000000006000000FFFFFFFFFEFFFFFFFEFFFFFF0300000000000000FBFFFFFFFEFFFFFF01000000080000000000000002000000FEFFFFFF02000000FEFFFFFFFCFFFFFF0200000000000000FEFFFFFF000000000000000001000000FFFFFFFFFDFFFFFF03000000FDFFFFFFFFFFFFFF04000000F7FFFFFFFEFFFFFF01000000FDFFFFFF01000000000000000200000006000000FEFFFFFF00000000000000000500000000000000FAFFFFFF04000000FFFFFFFF00000000FBFFFFFF0000000001000000FBFFFFFFFBFFFFFF00000000FCFFFFFFFEFFFFFFFDFFFFFFFEFFFFFF00000000FEFFFFFF0000000005000000FDFFFFFFFFFFFFFF03000000FFFFFFFFFFFFFFFF01000000000000000400000002000000FEFFFFFF02000000000000000100000003000000050000000000000000000000FDFFFFFF0200000003000000FFFFFFFF01000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<"0x0400000002000000FDFFFFFF010000000300000000000000FCFFFFFF00000000000000000500000000000000070000000000000001000000010000000100000001000000FFFFFFFF0300000000000000FFFFFFFF03000000FFFFFFFFFEFFFFFFFEFFFFFF030000000200000005000000FFFFFFFF00000000FEFFFFFF0000000000000000FFFFFFFFFEFFFFFF0000000002000000FCFFFFFFFBFFFFFF0400000000000000000000000000000002000000FEFFFFFFFEFFFFFFFFFFFFFF00000000000000000000000002000000FDFFFFFFFAFFFFFF03000000FCFFFFFF0400000000000000FDFFFFFFFEFFFFFF00000000FCFFFFFF00000000FDFFFFFF010000000000000001000000000000000000000005000000000000000600000003000000FDFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FAFFFFFFFCFFFFFF000000000300000001000000FDFFFFFF01000000000000000600000001000000000000000700000006000000FCFFFFFFFFFFFFFF00000000FFFFFFFF00000000FDFFFFFF01000000010000000300000001000000FCFFFFFF0200000000000000FBFFFFFF04000000FDFFFFFFFDFFFFFF010000000100000002000000000000000000000001000000FEFFFFFF0600000000000000010000000400000000000000020000000000000000000000FBFFFFFF00000000FCFFFFFFFEFFFFFFFFFFFFFF0300000000000000010000000200000000000000FAFFFFFFFFFFFFFF00000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF"> : tensor<5x2x2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x0400000002000000FDFFFFFF020000000300000002000000FCFFFFFFFDFFFFFF00000000050000000000000008000000010000000100000000000000FFFFFFFF00000000FEFFFFFF0000000004000000FFFFFFFF05000000FCFFFFFF02000000FDFFFFFF03000000040000000E00000000000000FEFFFFFFFFFFFFFF0100000000000000000000000000000002000000FFFFFFFF02000000FDFFFFFF03000000FDFFFFFF02000000FFFFFFFF01000000FEFFFFFF0300000001000000FDFFFFFFF8FFFFFFFEFFFFFF05000000FBFFFFFF010000000400000001000000000000000100000002000000FBFFFFFFF8FFFFFF0000000001000000000000000000000003000000FDFFFFFFF8FFFFFF020000000000000004000000FFFFFFFFFDFFFFFFFCFFFFFF03000000FDFFFFFF00000000FEFFFFFF02000000FDFFFFFF03000000FFFFFFFFFFFFFFFF050000000200000001000000FEFFFFFFFEFFFFFFFFFFFFFFFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF020000000100000003000000FFFFFFFF0900000005000000FAFFFFFF01000000FDFFFFFF04000000FCFFFFFF02000000FAFFFFFFFDFFFFFF050000000300000002000000F8FFFFFFFEFFFFFF010000000000000000000000030000000100000002000000FDFFFFFFFEFFFFFF01000000000000000100000001000000FFFFFFFFFFFFFFFFFFFFFFFF0600000007000000FFFFFFFF0500000004000000FFFFFFFFFFFFFFFFFBFFFFFFFDFFFFFF010000000500000001000000030000000100000003000000FAFFFFFFFEFFFFFF02000000FBFFFFFF02000000FDFFFFFFFDFFFFFF0200000000000000FFFFFFFF03000000FDFFFFFFFFFFFFFF04000000F7FFFFFFFEFFFFFF01000000FDFFFFFF01000000000000000200000006000000FEFFFFFF00000000000000000500000001000000F8FFFFFF0A000000FFFFFFFF01000000FFFFFFFF0000000003000000FBFFFFFFFBFFFFFFFBFFFFFFFCFFFFFFFAFFFFFFFBFFFFFFFDFFFFFF03000000FEFFFFFF0100000007000000FDFFFFFFF9FFFFFF02000000FFFFFFFFFDFFFFFF00000000FEFFFFFF0300000002000000FEFFFFFF02000000000000000100000003000000050000000000000000000000FDFFFFFF0200000003000000FFFFFFFF01000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

