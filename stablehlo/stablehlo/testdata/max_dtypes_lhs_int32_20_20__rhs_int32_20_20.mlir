// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi32>, tensor<20x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.maximum %0#0, %0#1 : tensor<20x20xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi32>, tensor<20x20xi32>) {
    %0 = stablehlo.constant dense<"0x01000000FDFFFFFF03000000FFFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF02000000020000000000000005000000FFFFFFFF010000000000000000000000FCFFFFFFFEFFFFFF05000000000000000400000000000000FFFFFFFF0100000000000000000000000000000003000000030000000100000000000000FEFFFFFF0100000002000000F9FFFFFF04000000FEFFFFFFFEFFFFFFFEFFFFFF0000000001000000FFFFFFFF02000000FCFFFFFF0500000000000000FFFFFFFF0000000000000000FEFFFFFFFFFFFFFF0000000000000000F9FFFFFF0300000000000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0300000000000000FFFFFFFF010000000100000002000000020000000200000000000000FCFFFFFF0600000000000000FCFFFFFF0200000000000000FDFFFFFFFDFFFFFFFFFFFFFF00000000000000000100000004000000FEFFFFFFFFFFFFFFF9FFFFFFFFFFFFFF00000000010000000300000000000000FBFFFFFF02000000040000000300000001000000FDFFFFFFF9FFFFFFFFFFFFFFFCFFFFFF000000000000000002000000FFFFFFFF0100000003000000FBFFFFFFFDFFFFFFFFFFFFFF00000000000000000200000000000000FEFFFFFF0100000006000000FFFFFFFFFEFFFFFF0200000001000000FDFFFFFF01000000FFFFFFFF02000000000000000300000005000000FFFFFFFF020000000100000006000000FBFFFFFF00000000FFFFFFFFFBFFFFFFFDFFFFFFFAFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000010000000200000002000000FCFFFFFF0100000000000000FEFFFFFFFDFFFFFF03000000FEFFFFFF01000000FFFFFFFF00000000FEFFFFFF0300000001000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFF000000000000000000000000FFFFFFFFFEFFFFFF00000000FEFFFFFF0000000002000000FEFFFFFF0000000003000000FFFFFFFFFDFFFFFF00000000FDFFFFFF0100000001000000FEFFFFFF0000000002000000FFFFFFFF03000000FFFFFFFF01000000070000000100000003000000FEFFFFFF0100000000000000FEFFFFFF01000000FBFFFFFF00000000030000000100000001000000FCFFFFFF020000000100000003000000FFFFFFFFFDFFFFFFFDFFFFFF0300000000000000000000000100000005000000FFFFFFFFFEFFFFFFFFFFFFFF010000000100000000000000010000000000000000000000000000000000000004000000FDFFFFFF020000000200000000000000FFFFFFFF00000000FFFFFFFF00000000030000000000000000000000F9FFFFFF0200000000000000FEFFFFFF030000000100000000000000FFFFFFFF00000000FEFFFFFFFCFFFFFF010000000100000003000000FDFFFFFF00000000020000000100000000000000020000000400000001000000FFFFFFFF0300000000000000FDFFFFFFFDFFFFFF00000000FDFFFFFF010000000000000002000000FFFFFFFF00000000FEFFFFFF000000000000000003000000FBFFFFFF0000000003000000FEFFFFFF02000000010000000100000000000000FEFFFFFFFEFFFFFF0100000000000000FDFFFFFFFFFFFFFF010000000200000005000000FDFFFFFF0300000001000000FEFFFFFF0200000000000000FCFFFFFFFEFFFFFF00000000FEFFFFFF0000000000000000FEFFFFFF01000000010000000100000002000000FFFFFFFF0500000000000000FDFFFFFF00000000FEFFFFFF00000000020000000200000000000000FCFFFFFF06000000FEFFFFFF0200000001000000FCFFFFFFFFFFFFFFFEFFFFFF00000000FEFFFFFF00000000FDFFFFFFFEFFFFFFFDFFFFFFFEFFFFFF000000000000000000000000FFFFFFFF01000000000000000000000001000000FDFFFFFF05000000FCFFFFFFFEFFFFFF0000000002000000FDFFFFFF000000000000000001000000FEFFFFFF0500000000000000FFFFFFFF0500000000000000FFFFFFFF04000000FFFFFFFFFFFFFFFFFEFFFFFF00000000FDFFFFFFFCFFFFFF00000000FDFFFFFF0000000001000000FCFFFFFF0400000002000000FDFFFFFFFCFFFFFF00000000FCFFFFFFFDFFFFFF00000000FEFFFFFF02000000030000000100000006000000050000000000000003000000FDFFFFFF05000000FEFFFFFF0100000002000000FFFFFFFF0000000001000000FFFFFFFFFEFFFFFF000000000300000000000000030000000200000000000000"> : tensor<20x20xi32>
    %1 = stablehlo.constant dense<"0x0100000000000000FFFFFFFF01000000FEFFFFFF00000000FDFFFFFF000000000000000000000000FFFFFFFF010000000100000004000000FFFFFFFF000000000100000000000000010000000200000001000000FFFFFFFF02000000FFFFFFFF00000000FFFFFFFFFEFFFFFFFFFFFFFFFBFFFFFFFDFFFFFF0000000002000000FAFFFFFFFBFFFFFF04000000FFFFFFFF01000000FFFFFFFF020000000200000000000000FEFFFFFF0600000001000000000000000000000000000000FBFFFFFFFEFFFFFF00000000040000000100000003000000FCFFFFFFFEFFFFFFFDFFFFFFFDFFFFFF0300000002000000FCFFFFFF02000000FFFFFFFFFFFFFFFF02000000FEFFFFFFFDFFFFFFFFFFFFFFFEFFFFFF0000000001000000FBFFFFFF04000000FDFFFFFF0700000001000000040000000300000000000000FDFFFFFFFCFFFFFFFFFFFFFF01000000FDFFFFFF01000000010000000000000004000000FEFFFFFF00000000050000000100000001000000FCFFFFFFFFFFFFFF0000000000000000FDFFFFFF00000000010000000000000002000000050000000300000000000000FAFFFFFF0000000003000000FBFFFFFF01000000FCFFFFFF000000000100000000000000FCFFFFFF000000000000000000000000000000000000000001000000FFFFFFFFFFFFFFFF010000000000000002000000FAFFFFFF03000000010000000100000000000000FDFFFFFF00000000FCFFFFFF03000000FCFFFFFF00000000FFFFFFFF01000000010000000500000002000000FFFFFFFFFFFFFFFF01000000FEFFFFFF0000000004000000FDFFFFFF05000000FEFFFFFF00000000FFFFFFFF04000000FFFFFFFFFCFFFFFF00000000FEFFFFFF0300000000000000FDFFFFFFFFFFFFFF01000000010000000200000001000000FFFFFFFFFDFFFFFF00000000FFFFFFFF00000000000000000100000000000000FEFFFFFFFCFFFFFF0300000005000000000000000000000000000000FCFFFFFFFCFFFFFFFDFFFFFF0700000002000000080000000000000002000000000000000600000001000000FDFFFFFF0200000004000000FFFFFFFF0000000003000000FEFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFBFFFFFF01000000FFFFFFFFFAFFFFFFFFFFFFFF0000000000000000FCFFFFFF0000000000000000FEFFFFFFFEFFFFFF0100000000000000000000000500000004000000FFFFFFFF0A00000002000000000000000000000001000000FDFFFFFFFFFFFFFF00000000020000000500000001000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FAFFFFFF04000000020000000100000001000000FEFFFFFFFFFFFFFF0100000003000000FFFFFFFF07000000000000000500000000000000000000000000000000000000FFFFFFFF01000000FDFFFFFFFCFFFFFF010000000000000000000000FEFFFFFF04000000FEFFFFFF00000000FDFFFFFF0000000000000000FCFFFFFF0100000000000000FCFFFFFF01000000FFFFFFFF00000000FEFFFFFF0000000000000000000000000300000001000000020000000000000002000000FFFFFFFFFCFFFFFFFEFFFFFF00000000FFFFFFFF00000000000000000400000007000000FFFFFFFFFCFFFFFF01000000FFFFFFFF0200000000000000FBFFFFFF0000000003000000020000000100000000000000FEFFFFFFFEFFFFFF0300000000000000FEFFFFFF00000000FEFFFFFF000000000300000000000000FDFFFFFF00000000FAFFFFFFFEFFFFFF010000000000000000000000FFFFFFFF0000000000000000000000000000000004000000010000000000000003000000020000000000000002000000FEFFFFFF0000000001000000FDFFFFFF04000000FDFFFFFF0100000003000000FFFFFFFF01000000FFFFFFFFFBFFFFFFFFFFFFFFFEFFFFFF0000000001000000FCFFFFFF080000000000000001000000FFFFFFFFFDFFFFFFFBFFFFFF010000000100000000000000FCFFFFFF00000000FEFFFFFF0000000004000000FFFFFFFFFDFFFFFFFFFFFFFF0000000001000000FFFFFFFF00000000FEFFFFFF0100000003000000FFFFFFFF0000000000000000030000000000000001000000FDFFFFFF00000000FEFFFFFF040000000000000003000000FEFFFFFF01000000FAFFFFFF00000000FFFFFFFF01000000FFFFFFFF00000000FDFFFFFF0000000000000000FFFFFFFF0800000000000000"> : tensor<20x20xi32>
    return %0, %1 : tensor<20x20xi32>, tensor<20x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x01000000000000000300000001000000FEFFFFFF00000000FFFFFFFF0200000002000000000000000500000001000000010000000400000000000000000000000100000005000000010000000400000001000000FFFFFFFF0200000000000000000000000000000003000000030000000100000000000000000000000200000002000000FBFFFFFF04000000FFFFFFFF01000000FFFFFFFF02000000020000000000000002000000060000000500000000000000000000000000000000000000FEFFFFFF000000000400000001000000030000000300000000000000FDFFFFFFFFFFFFFF03000000020000000300000002000000FFFFFFFF0100000002000000020000000200000002000000000000000000000006000000000000000400000002000000070000000100000004000000030000000000000000000000010000000400000001000000FFFFFFFF01000000010000000000000004000000030000000000000005000000020000000400000003000000010000000000000000000000FFFFFFFF00000000010000000000000002000000050000000300000003000000FBFFFFFF000000000300000000000000010000000200000000000000010000000100000006000000000000000000000002000000010000000000000001000000FFFFFFFF02000000010000000300000005000000FFFFFFFF030000000100000006000000000000000000000000000000FCFFFFFF03000000FCFFFFFF00000000FFFFFFFF01000000010000000500000002000000020000000200000001000000010000000000000004000000FDFFFFFF05000000FEFFFFFF01000000FFFFFFFF04000000FFFFFFFF0300000001000000FFFFFFFF030000000000000000000000FFFFFFFF01000000010000000200000001000000FFFFFFFF00000000000000000000000002000000000000000100000003000000FFFFFFFFFDFFFFFF03000000050000000100000001000000000000000000000002000000FFFFFFFF0700000002000000080000000700000002000000030000000600000001000000000000000200000004000000FFFFFFFF00000000030000000100000001000000FDFFFFFF020000000100000003000000FFFFFFFFFDFFFFFFFFFFFFFF0300000000000000000000000100000005000000FFFFFFFFFEFFFFFF0100000001000000010000000500000004000000000000000A0000000200000000000000040000000100000002000000020000000000000002000000050000000100000000000000030000000000000000000000FFFFFFFF020000000000000004000000030000000100000001000000FFFFFFFF0000000001000000030000000100000007000000030000000500000000000000020000000100000000000000020000000400000001000000FFFFFFFF030000000000000000000000FEFFFFFF04000000FEFFFFFF010000000000000002000000000000000000000001000000000000000000000003000000FFFFFFFF0000000003000000000000000200000001000000030000000100000002000000000000000200000000000000FDFFFFFFFFFFFFFF010000000200000005000000000000000400000007000000FFFFFFFF0200000001000000FFFFFFFF0200000000000000FEFFFFFF0000000003000000020000000100000001000000010000000200000003000000050000000000000000000000000000000000000003000000020000000200000000000000FCFFFFFF06000000010000000200000001000000FFFFFFFF00000000000000000000000000000000040000000100000000000000030000000200000000000000020000000000000000000000010000000000000004000000010000000100000005000000FFFFFFFF010000000000000002000000FFFFFFFF000000000000000001000000FEFFFFFF0800000000000000010000000500000000000000FFFFFFFF040000000100000000000000FEFFFFFF00000000FEFFFFFF0000000004000000FFFFFFFF000000000100000000000000040000000200000000000000FEFFFFFF0100000003000000FFFFFFFF0000000000000000030000000300000001000000060000000500000000000000040000000000000005000000FEFFFFFF0100000002000000000000000000000001000000FFFFFFFF00000000000000000300000000000000030000000800000000000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
