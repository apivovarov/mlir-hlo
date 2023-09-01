// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xi32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>) -> tensor<2x3x6x6xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xi32>, tensor<2x3x6x6xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>) {
    %0 = stablehlo.constant dense<"0x0000010000000400FCFFFAFF000005000000FDFF02000000FFFF01000000FBFF02000200FCFFFFFF04000000FEFF0000FDFF0300FEFFFFFFFEFF020003000300FEFFFFFFFBFF0100FCFF00000300FEFFFEFFFFFF0000FCFF000000000200FCFF00000400020003000500FEFF0000FFFFFFFFFDFF0000000001000000000003000000000000000300FFFFFFFFFDFF01000200FDFF00000100FFFFFEFF0400FBFFFDFFFFFF050001000300FFFFFDFFFBFF020001000100FEFFFCFF0500030000000000FEFFFDFFFEFF050000000000FEFFFEFF0000000000000100FBFF03000100FFFF0200FFFF0000FFFF0300FDFF00000000000000000200FFFF0000FFFF010004000100040001000100FFFF000001000200FFFF02000000FDFF060004000100FFFFFAFFFDFF060000000000000000000400020000000000FFFFFFFF0900FFFFFFFFFFFF020001000000000002000000FFFFFDFF04000100000001000100050001000000000000000300FDFFFAFF000002000400070003000000FDFF00000100FFFFFFFFFEFF03000300010002000600FBFF0000FAFF03000000FFFF04000000FCFF0300000002000000FEFF0000FFFF030004000000FEFF000003000100FCFF050000000000020000000000FFFF05000000FCFF0600000002000000FBFF030000000100FFFFFEFFFEFFF8FFFAFF00000000FDFF040002000000000000000000FDFF02000000FEFF0000FEFF020001000000FFFF0100FCFF0000FEFF04000000050000000100FFFF0500000004000400000000000000FEFFFFFFFCFF0200F8FF030004000000030000000000FDFF01000200FFFF000001000000030000000000FFFF07000200FEFFFEFF010002000000FEFF000000000100FFFFFDFF0300010001000000000005000300FBFFFFFFFFFFFDFF0200000000000000FDFF0300000000000000FCFF000001000000FFFFFFFF00000000FDFF0200010002000500050001000200FEFF0000FFFFFCFFFEFF030006000300FDFF01000600FEFFFDFFFCFF070001000100FDFF02000200FEFF02000200FDFF020000000500FBFF030003000100FEFF030001000100FDFFFDFF0100FFFF000002000000000001000600FDFF0100FDFFFDFF020000000000FDFF05000300FEFFFEFFFDFF0300FEFF0300FFFFF9FF00000100FCFF0100FDFFFDFF00000100FFFF0200FFFF080005000200FCFF0000FCFF0000020001000300020003000300FEFF0000FFFF0000FEFF01000300FFFFFFFFFEFFFFFFFFFFFFFFFCFF01000000030005000200FFFF0100010002000300FEFFFFFFFFFF00000100FEFF0200010004000100FEFF0000FFFF0000FEFF00000200FDFFFDFFFFFF01000300FEFFFEFF0000FEFFFDFFFDFF0000FFFFFEFF0200030002000200020001000200FDFF02000000FCFF0000000005000300FFFFFEFF010000000500FCFFFBFF00000000FEFF0000FFFF0000FFFF00000000FEFF03000000000000000200FCFF05000100FFFF0000FCFFFFFF"> : tensor<2x3x9x10xi16>
    %1 = stablehlo.constant dense<"0x010002000000FCFF0100FDFFFFFF0500FFFF0400FBFFFDFF01000200FFFF010000000200FEFFFBFF0100FDFFFFFF0300FFFFFCFF0200FFFFF9FFFFFF00000300000003000400FBFF04000300FCFF030001000100000003000000FFFFFEFF030000000000FFFFFFFF030001000300FFFF0000FFFF0300FCFFFFFF0200FFFFFEFFFFFF0000FFFFFEFF000003000600000001000500FEFFFDFF03000700020000000000FBFF0000050000000200FCFF0000FFFFFEFF00000600FFFFFFFF01000000FFFFFFFFFFFF0000000001000300FAFF04000100FEFF02000200000002000200FFFF06000200FFFF0000FFFFFBFFFFFF0100000000000300FCFF0000FEFF03000100FAFFFBFF00000200000003000000FFFF0400FBFF00000000FBFF0000FDFF0100FFFF0000010001000000FCFF05000000FFFF0000040002000300FDFF010000000000FFFF00000100FCFFFCFFFFFFFDFFFFFF02000000FEFFFDFF01000000030002000000FFFF"> : tensor<3x3x4x5xi16>
    return %0, %1 : tensor<2x3x9x10xi16>, tensor<3x3x4x5xi16>
  }
  func.func private @expected() -> tensor<2x3x6x6xi32> {
    %0 = stablehlo.constant dense<"0xE1FFFFFF2D000000320000001D000000EDFFFFFFEEFFFFFF7BFFFFFFF7FFFFFF1F000000270000003200000023000000FCFFFFFFF7FFFFFFEAFFFFFF58000000F6FFFFFFDAFFFFFF16000000EBFFFFFFDFFFFFFFF0FFFFFF28000000DEFFFFFF18000000D2FFFFFF13000000ADFFFFFFFBFFFFFF39000000BEFFFFFF32000000F1FFFFFF4700000019000000B5FFFFFF46000000CCFFFFFF08000000F6FFFFFF91FFFFFFDFFFFFFFF3FFFFFFF8FFFFFFE4FFFFFF10000000ECFFFFFF17000000CFFFFFFF01000000DEFFFFFFEAFFFFFF290000001200000049000000730000007E0000000A000000D4FFFFFF0300000003000000CDFFFFFFEEFFFFFF060000000A000000C5FFFFFF1B000000D5FFFFFFF2FFFFFFBDFFFFFFFCFFFFFF36000000E3FFFFFF56000000A9FFFFFFDAFFFFFF0D000000E5FFFFFF380000000C0000000F000000EFFFFFFF50000000B1FFFFFF56000000E9FFFFFF3200000022000000BCFFFFFF0800000034000000CDFFFFFFEDFFFFFFF8FFFFFF8DFFFFFFD7FFFFFF11000000E0FFFFFF1800000019000000E9FFFFFFAFFFFFFF250000001B000000240000005C0000005900000047000000FFFFFFFFD7FFFFFFEFFFFFFFC2FFFFFF67000000D8FFFFFFAFFFFFFF010000002000000013000000F3FFFFFFA4FFFFFFF6FFFFFF2B000000FEFFFFFF600000000700000071FFFFFFB8FFFFFF17000000F8FFFFFFAEFFFFFF150000000400000009000000030000000000000033000000DAFFFFFF3B00000099FFFFFF15000000580000000F000000F5FFFFFFFBFFFFFF0600000049000000E6FFFFFF10000000EBFFFFFF2200000027000000D4FFFFFF3E00000038000000BBFFFFFFE3FFFFFF000000000100000013000000EEFFFFFFDFFFFFFFE7FFFFFF1000000042000000A1FFFFFF0000000062000000D4FFFFFFFDFFFFFFCEFFFFFF40000000A3FFFFFF150000004100000032000000DFFFFFFFD7FFFFFFC9FFFFFFBDFFFFFF3000000097FFFFFF05000000AFFFFFFF2D00000032000000CEFFFFFFFBFFFFFFEEFFFFFFA3FFFFFF38000000D1FFFFFFB9FFFFFFF2FFFFFFA5FFFFFF4F00000024000000F1FFFFFF8EFFFFFF1B000000E2FFFFFF2800000010000000E1FFFFFFC7FFFFFF0500000005000000EEFFFFFF2B000000C4FFFFFF32000000D7FFFFFF1D000000E0FFFFFF35000000420000000E000000"> : tensor<2x3x6x6xi32>
    return %0 : tensor<2x3x6x6xi32>
  }
}

