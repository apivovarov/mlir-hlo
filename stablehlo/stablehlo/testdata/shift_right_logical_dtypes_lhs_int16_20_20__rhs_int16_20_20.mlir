// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi16>, tensor<20x20xi16>)
    %1 = call @expected() : () -> tensor<20x20xi16>
    %2 = stablehlo.shift_right_logical %0#0, %0#1 : tensor<20x20xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi16>, tensor<20x20xi16>) {
    %0 = stablehlo.constant dense<"0x07000000FAFF0200FFFF0000FDFFFFFFFDFF01000000F9FF00000200FDFF00000000FDFFFFFF0100000001000000FFFF00000400FBFF020000000000FEFF0000000003000000000002000100FFFF070004000000000002000000FEFF06000200FCFFFFFF0300010000000000FDFF050002000200FDFF00000100FEFF0400FDFF040002000300FEFF07000200FEFF0000020000000300FFFF0300FDFF0100FEFFF7FFFFFF02000100000001000300FDFFFEFFFDFFFFFF00000000FCFF00000000000000000300FCFFFFFFFBFFFCFF0000010000000100FCFF01000000FDFFFFFFFCFFFFFFFEFFFFFFFEFF0600FDFF040001000400FFFF020000000200FEFF02000000FDFF0100FDFF01000200050000000000FFFF0000000002000100FDFFFAFF0100FDFF0000020000000300FCFF00000000FDFF0200FFFFFFFFFDFFFEFF0000FFFF01000000FFFF070000000000FDFFFFFF0100FEFFFEFF00000200FFFF0300FCFF000002000000FFFFFFFF0100020002000000FFFFFFFF0000000000000200FEFFFEFF0500FCFFFEFF010002000100FFFF00000000FFFF040000000200FDFFFDFFFFFF000002000000FFFF00000000030000000200000001000600010003000200FEFF0300FCFF00000000FFFFFCFF04000000FDFF000001000000FEFFFFFF0100FCFF01000000FEFF02000800FFFFFEFF05000000FBFF03000200FFFFFDFF000001000500FFFFFCFF000001000000FEFFFFFF000001000100030000000000FDFFFEFF00000400FCFF03000300FFFF030004000000FDFF000001000000FAFFFBFF00000200FDFFFDFF0000FFFFF8FF0200010001000000FFFF0000FEFFF9FF0400FEFFFDFFFEFFFBFF0300FDFF0000FCFF03000000F7FF040000000100FBFF04000100FFFFFAFF00000000010000000100040001000100020003000200FFFF00000300FCFF010003000000FBFFFFFFFDFFFEFF03000000FEFF0200FFFF000001000000020001000400FEFFFEFFFFFF03000000010001000300FBFF0300FDFFFFFF0000FDFF0400FEFFFEFFFFFFFEFF020000000100FEFFFFFF000000000200FFFFFDFFFEFF0000FEFF00000200FDFF0000FEFFFFFFFAFFFEFF00000000FFFF"> : tensor<20x20xi16>
    %1 = stablehlo.constant dense<"0x0000FFFF02000000020000000300FEFF000005000000FDFF00000000FDFFFFFFFCFFFBFF0000FEFF02000100FEFF050003000000010000000100000005000000000006000300FFFF0200FCFF01000000FBFF03000200FBFFFEFFFAFFFEFFFFFFFFFF03000100F9FF01000000FEFF02000100010003000600FFFFFFFF0100FFFF0200FCFF0000FBFF04000300030000000100FEFF0200FFFFFDFF00000000FCFF03000300FFFF0200FFFF0000FDFFFFFF0000000000000600FBFF0200FDFFFDFFFCFFFCFFF9FFFDFF0100FDFF0100FEFF0300FCFFFFFFFEFFFCFF01000000FFFF00000100FDFFFFFF00000200FFFF000000000000FCFF0100020003000100FFFFFFFFFEFFFBFFFFFF020000000100010002000600FFFF00000400000000000300FFFFFCFF03000000FFFFFEFFFCFFFDFFFFFFFEFF000001000300FCFF000003000000000001000000FFFFFDFF0000FFFF01000100FBFFFFFF00000100000000000000FEFF00000200030003000500FFFF0000000000000000FFFFF9FFFEFFFFFF0300000002000000010003000000FCFF0000F9FFFFFFFFFF06000000FEFFFDFFFFFF00000300FDFF000000000200FFFF0100010000000000FFFFFBFFFCFFFEFFFAFFFAFF0000FEFFFCFF0200000003000000FDFF0300FEFFFEFFFEFF00000000FEFFFEFF0000FDFFFCFFFFFF00000000FBFF0100FEFF02000200000001000000FEFF030000000600FFFF0000FDFFFDFF01000200FBFF0100FEFF0000FEFFFDFF0300000002000200000003000000FFFF0000FBFFFBFFFDFF0000FEFF02000000FFFFFFFF0400FCFF0300FCFFF8FF0000FFFF0000FFFF0200020002000500FCFF00000000FFFF0300F8FF0100FDFFFCFFFCFFFEFFFFFF0100FDFFFCFF030000000000FCFFFCFF00000000FFFF040002000400FFFFFFFF0000FBFF000000000000FDFF020003000000FBFFFCFF02000000000000000000FEFFFEFF0500FFFFFDFF000004000100FFFF040000000200FFFF030006000000FCFF0200FFFF0500000001000000FCFFFFFF030003000200FFFF0000FFFFFEFF0200FBFFFEFFFBFFFFFFFFFF0100FEFF0200FFFF0000FDFF010002000000000003000000000000000000"> : tensor<20x20xi16>
    return %0, %1 : tensor<20x20xi16>, tensor<20x20xi16>
  }
  func.func private @expected() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0x07000000FE3F0200FF3F0000FF1F0000FDFF000000000000000002000000000000000000FFFF0000000000000000FF0700000400FD7F020000000000FF070000000000000000000000000000FF7F0700000000000000000000000000000000000000FF1F01000000000000000000010001000100FF1F00000000000002000000010000000300000000000000FF1F000001000000000000000000FDFF01000000FE1FFF1F000000000000010000000000FEFFFDFFFFFF00000000FF3F000000000000000000000000FF7F0000FE7F0000000000000000000000000000FDFF0000FCFFFF7F00000000FEFF010000000400010004000000010000000000FF7F0000000000000000000000000200020000000000FF030000000000000100FDFFFF1F00000000000002000000000000000000000000000200FF7FFF1F0000FEFF0000FFFF01000000FFFF0000000000000000FF7F00000000000000000100FFFF0300FCFF000002000000FF1FFF1F0000000002000000FFFFFFFF0000000000000000FF1FFEFF0100FCFFFF7F000002000000FFFF00000000000000000000000000000000FFFF000000000000FFFF0000000001000000020000000000000000000000000000000300000000000000FFFFFF1F04000000FF1F000000000000FEFFFFFF0000000001000000000000000800FFFF000002000000FE3F00000200FF7FFDFF000000000500FF030000000000000000FF7FFF3F000000000000030000000000FF1FFEFF00000100FCFF0000030000000300000000000000000000000000FAFF0000000000000000FF1F00000000F8FF0000010000000000FF3F0000FF0700000400FEFF0000FF1F0000010000000000000000000000FB7F000000000000FBFF040000000000FAFF00000000000000000000000000000100000003000200FFFF00000000FF1F010000000000FE3FFFFFFDFFFEFF03000000000000000000000001000000010000000000FEFFFF3F00000000000001000000000000000000FDFFFF7F000000000000FF1FFF1FFF3F0000020000000000FF3F00000000000000000000FE7F00000000000000000000FE7F0000FEFFFFFFFF1FFEFF00000000FFFF"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
}
