// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x20xi32>, tensor<20x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x20xi32>) -> tensor<20x20xi32>
    %3 = stablehlo.or %2, %0#1 : tensor<20x20xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x20xi32>, tensor<20x20xi32>) {
    %0 = stablehlo.constant dense<[[2, 3, 1, 0, 6, 1, 0, 1, 0, -1, 1, -3, -1, -2, -1, -7, 0, 6, 1, -2]]> : tensor<1x20xi32>
    %1 = stablehlo.constant dense<"0x000000000000000000000000FFFFFFFF0500000000000000000000000100000002000000FDFFFFFFFEFFFFFF0100000003000000FFFFFFFF01000000010000000400000002000000FCFFFFFF010000000000000000000000FEFFFFFFFEFFFFFFFDFFFFFF000000000000000004000000FFFFFFFFFEFFFFFFFFFFFFFF060000000100000001000000000000000100000001000000F9FFFFFFFFFFFFFFFFFFFFFF03000000040000000000000001000000010000000000000000000000FEFFFFFFFEFFFFFFFBFFFFFF03000000040000000100000002000000FFFFFFFFFFFFFFFF03000000FEFFFFFF00000000FFFFFFFF000000000000000004000000FEFFFFFFFEFFFFFF0300000005000000FCFFFFFFFEFFFFFF000000000000000000000000FFFFFFFF010000000000000002000000000000000500000001000000FFFFFFFF0000000000000000FCFFFFFF01000000FBFFFFFF000000000100000000000000000000000000000000000000FDFFFFFF03000000FEFFFFFF03000000FFFFFFFFFDFFFFFF0000000000000000FEFFFFFF000000000000000002000000000000000000000001000000FDFFFFFF000000000000000000000000010000000000000003000000000000000100000004000000FBFFFFFF060000000200000000000000020000000100000001000000FFFFFFFFFDFFFFFF04000000FDFFFFFFFDFFFFFFFDFFFFFFFFFFFFFF00000000FAFFFFFFFBFFFFFF050000000300000000000000FEFFFFFFFCFFFFFF000000000200000003000000FFFFFFFF0000000002000000FEFFFFFFFFFFFFFF0000000002000000FEFFFFFF020000000000000000000000FFFFFFFF00000000F9FFFFFF00000000F9FFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0200000000000000FFFFFFFF00000000FFFFFFFFFDFFFFFFFCFFFFFFFCFFFFFFFFFFFFFF01000000FDFFFFFFFEFFFFFF02000000FFFFFFFFFFFFFFFF01000000FFFFFFFF00000000010000000000000004000000FEFFFFFF060000000400000000000000FFFFFFFF00000000000000000000000000000000FDFFFFFF0000000004000000FDFFFFFFFEFFFFFF000000000000000002000000020000000000000001000000FAFFFFFFFCFFFFFF02000000FBFFFFFFFEFFFFFF000000000000000000000000000000000000000000000000FDFFFFFF0400000001000000040000000000000005000000FDFFFFFF02000000FDFFFFFF02000000020000000100000001000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000004000000000000000000000001000000010000000400000003000000F9FFFFFFFCFFFFFFFFFFFFFFFCFFFFFF01000000FDFFFFFF01000000FEFFFFFF0200000001000000FDFFFFFF0300000001000000000000000400000001000000FEFFFFFF0100000000000000020000000100000000000000FAFFFFFFFFFFFFFF0000000001000000FDFFFFFFFFFFFFFFFFFFFFFF0300000004000000030000000000000003000000F9FFFFFF0200000002000000FCFFFFFF00000000FDFFFFFFFFFFFFFF03000000000000000000000002000000010000000000000000000000FDFFFFFF02000000020000000200000003000000000000000000000002000000FCFFFFFFFCFFFFFF0000000002000000FEFFFFFFFEFFFFFF08000000010000000300000000000000FEFFFFFF0000000000000000000000000000000003000000FFFFFFFF0200000001000000FEFFFFFF00000000FAFFFFFF0200000006000000FEFFFFFF00000000FEFFFFFF020000000100000003000000000000000100000002000000000000000300000000000000FBFFFFFF03000000020000000200000002000000FEFFFFFF0000000002000000FCFFFFFF00000000FCFFFFFFFFFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFFFBFFFFFF000000000000000000000000FFFFFFFF0200000004000000FDFFFFFF0200000005000000FEFFFFFF08000000000000000400000003000000FAFFFFFFFFFFFFFFFCFFFFFF060000000000000000000000040000000000000000000000020000000000000000000000FFFFFFFF000000000300000003000000FEFFFFFFFCFFFFFFFEFFFFFF00000000FEFFFFFF00000000000000000300000007000000FAFFFFFFFCFFFFFFFFFFFFFF00000000000000000000000000000000FEFFFFFF010000000000000000000000FCFFFFFF"> : tensor<20x20xi32>
    return %0, %1 : tensor<1x20xi32>, tensor<20x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x020000000300000001000000FFFFFFFF0700000001000000000000000100000002000000FFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFF0400000006000000FDFFFFFFFFFFFFFF0200000003000000FFFFFFFFFEFFFFFFFFFFFFFF010000000000000005000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFF01000000FFFFFFFFFFFFFFFFFFFFFFFF03000000070000000100000001000000070000000100000000000000FFFFFFFFFEFFFFFFFFFFFFFF03000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF03000000FEFFFFFF01000000FFFFFFFF020000000300000005000000FEFFFFFFFEFFFFFF0300000005000000FDFFFFFFFEFFFFFFFFFFFFFF01000000FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF000000000700000001000000FFFFFFFF0200000003000000FDFFFFFF01000000FFFFFFFF01000000010000000100000000000000FFFFFFFF01000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFFFFFF0600000001000000FEFFFFFF020000000300000003000000000000000600000001000000FDFFFFFF0100000000000000FFFFFFFF01000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFBFFFFFF0600000003000000FEFFFFFF020000000300000001000000FFFFFFFFFFFFFFFF05000000FDFFFFFFFDFFFFFFFDFFFFFFFFFFFFFF01000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFEFFFFFFFEFFFFFF01000000FEFFFFFF03000000FFFFFFFF0100000002000000FEFFFFFFFFFFFFFF0000000003000000FEFFFFFFFFFFFFFF01000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFF9FFFFFFF9FFFFFFFFFFFFFF01000000FEFFFFFFFFFFFFFFFFFFFFFF0300000000000000FFFFFFFF01000000FFFFFFFFFDFFFFFFFCFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF07000000FFFFFFFFFEFFFFFF030000000300000005000000FEFFFFFF060000000500000000000000FFFFFFFF00000000FFFFFFFF01000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFEFFFFFF0600000001000000FEFFFFFF020000000300000001000000FAFFFFFFFEFFFFFF03000000FBFFFFFFFFFFFFFF00000000FFFFFFFF01000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF010000000600000001000000FFFFFFFFFFFFFFFF03000000FDFFFFFF02000000060000000100000001000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFF9FFFFFF010000000600000003000000FFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF01000000FFFFFFFF01000000FEFFFFFF0300000001000000FFFFFFFF03000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF010000000600000003000000FFFFFFFF02000000FBFFFFFFFFFFFFFF0000000007000000FDFFFFFFFFFFFFFFFFFFFFFF03000000FFFFFFFF03000000FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFCFFFFFF06000000FDFFFFFFFFFFFFFF03000000030000000100000002000000070000000100000000000000FDFFFFFF02000000FFFFFFFF03000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFCFFFFFF0600000003000000FEFFFFFFFEFFFFFF0B000000010000000300000006000000FFFFFFFF000000000100000000000000FFFFFFFF03000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFAFFFFFF0600000007000000FEFFFFFF02000000FFFFFFFF03000000010000000700000001000000010000000300000000000000FFFFFFFF01000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFBFFFFFFFEFFFFFF0600000003000000FEFFFFFF02000000FFFFFFFFFFFFFFFFFFFFFFFF0600000001000000FDFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF01000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF0200000007000000FFFFFFFFFEFFFFFF020000000700000003000000FAFFFFFFFFFFFFFFFDFFFFFF060000000100000000000000FFFFFFFF01000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF000000000700000003000000FEFFFFFFFEFFFFFFFFFFFFFF01000000FEFFFFFF06000000010000000300000007000000FAFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF010000000600000001000000FEFFFFFF"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
