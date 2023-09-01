// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<2x7xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2xi32>, tensor<2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<2x7xi16>) {
    %0 = stablehlo.constant dense<"0x0000FFFFFAFF03000200FFFF03000500FEFFFEFF0500000000000200030004000000010000000300FCFFFFFF0100000001000200FCFFFAFFFFFFFCFFFAFFFCFF02000000050009000000000000000200040001000200FFFFFFFF000005000000FEFF0400FDFFFEFFFDFFFFFFFAFF000004000000FEFFFFFF04000100FCFFFDFFFFFF0000FEFF0300FAFF0000FFFF00000000FBFFFDFF000002000100FFFFFDFFFEFF00000100FDFF03000200040001000000030000000200000001000200FEFFFFFFFFFF0000030000000000FFFFFCFF030002000100FCFFFEFFFFFFFFFF0000FEFF00000400FFFF0000FCFF000000000400020000000200FEFF0200000001000100FEFFFFFF03000100FEFF0200FEFF01000000FFFFFFFFFBFF0300030003000000000000000000030003000100FFFF0000FCFF0100000003000000F9FF00000000FFFF0000FFFF03000000000003000000FFFF02000000FEFFFFFF0500010000000300020001000400FCFFFAFF0000FFFFFCFF00000000FFFFFBFF040001000000040003000100FFFFFFFF00000300FDFFFEFFFCFF01000500010005000300FEFFFFFF"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<[[-3, -2, 1, -1, -2, 0, -1], [0, 5, 2, 2, -4, 2, -2]]> : tensor<2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x0000FFFFFAFF03000200FFFF0300F1FF0400FEFFFBFF00000000FEFF030004000000010000000300FCFFFFFF0100000001000200FCFFFAFFFFFFFCFFFAFFFCFF02000000050009000000000000000200040001000200FFFFFFFF000005000000FEFF0400FDFFFEFFFDFFFFFFFAFF000004000000FEFFFFFF04000100FCFFFDFFFFFF0000FEFF0300FAFF0000FFFF00000000FBFFFDFF000002000100FFFFFDFFFEFF00000100FDFF03000200040001000000030000000200000001000200FEFFFFFFFFFF0000030000000000FFFFFCFF030000000500F8FFFCFF0400FEFF0000FEFF00000400FFFF0000FCFF000000000400020000000200FEFF0200000001000100FEFFFFFF03000100FEFF0200FEFF01000000FFFFFFFFFBFF0300030003000000000000000000030003000100FFFF0000FCFF0100000003000000F9FF00000000FFFF0000FFFF03000000000003000000FFFF02000000FEFFFFFF0500010000000300020001000400FCFFFAFF0000FFFFFCFF00000000FFFFFBFF040001000000040003000100FFFFFFFF00000300FDFFFEFFFCFF01000500010005000300FEFFFFFF"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

