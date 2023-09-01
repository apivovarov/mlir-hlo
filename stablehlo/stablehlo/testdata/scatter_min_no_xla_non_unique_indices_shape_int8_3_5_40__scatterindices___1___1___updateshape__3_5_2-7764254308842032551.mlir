// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xi8>, tensor<3x5x2xi8>)
    %2 = call @expected() : () -> tensor<3x5x40xi8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i8>
      stablehlo.return %5 : tensor<i8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xi8>, tensor<2x1xi32>, tensor<3x5x2xi8>) -> tensor<3x5x40xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xi8>, tensor<3x5x40xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xi8>, tensor<3x5x2xi8>) {
    %0 = stablehlo.constant dense<"0xFC01010001FEFFFF0303030501FDFDFF0002000101FFFF030100FDFB00FE030100FD0002FFFF0100FF0302FFFD0000FE05FAFA00FE07FD00FFFD01FE0200FD00000003FDFEFDFC02FE0009FE0000000101FF0000030000FB01FCFE040103010301FF0200010000FD0104FEFD0500010005FD0205000400FEFF06FCFF02050000000005050002FFFD000203FA000005F90200F9FF05FE04FFFE01FFFFFFFF01FDFD0600FF07050302FF0100FDFD0200FAFF00040200FC00FFFE02000000FD00020202FF0304FC0002FDFDF902FFFD04FC020001FE00FE01FD030400FB02FEFD0002FEFFFE06FFFCFCFC040201FD02030302FE0100FBFE01FE00FF0100040300060201FEFFFDFFFFFE04FFFF0300FEFBFDFE00FD06FEFD0200FE00040303FFFE000000000301000000000003FFFF050500FEFA02FE03FF0301040206FFFF0502FDFFFFFDFFFF0003020301050507FE00FF00000000020002FF00FDFE000000FC03FFFE0506FEFDFFFC0000000001FE000305F901030001FE00FFFE0302FF0001FFFF0001FF0000FAFCFC010305FEFFFC0002020305FF01010103FF00010001FF0200FF010003FD00FD05000003FFFFFC0102020100000005FF0105FF04FC01FC02FF00000000000100FEFF00FF00FF00FC0100FE04FFFB00FC03010000FF01030003FCFE03FDFC0300FF000100FB00FCFA09FE02FEFF0002F8F900FE0305FF060103000003FF05020700000001030200FEFD01FBFE000003FF000004F702FF0200F90100000501000101FF02FF050002FF01FE010102FB000000FDFF0301FC0300000001000103FF000401FCFB01FE01F9000001FE00050500"> : tensor<3x5x40xi8>
    %1 = stablehlo.constant dense<[[[-1, 1], [-1, 0], [-2, -1], [-4, 0], [-2, -1]], [[0, -3], [0, 8], [1, 0], [1, -2], [5, -3]], [[-2, -1], [-4, 0], [-6, 2], [1, 2], [1, 3]]]> : tensor<3x5x2xi8>
    return %0, %1 : tensor<3x5x40xi8>, tensor<3x5x2xi8>
  }
  func.func private @expected() -> tensor<3x5x40xi8> {
    %0 = stablehlo.constant dense<"0xFCFF010001FEFFFF0303030501FDFDFF0002000101FFFF030100FDFB00FE030100FD0002FFFF0100FFFF02FFFD0000FE05FAFA00FE07FD00FFFD01FE0200FD00000003FDFEFDFC02FE0009FE0000000101FE0000030000FB01FCFE040103010301FF0200010000FD0104FEFD0500010005FD0205000400FEFFFCFCFF02050000000005050002FFFD000203FA000005F90200F9FF05FE04FFFE01FFFFFFFF01FDFDFE00FF07050302FF0100FDFD0200FAFF00040200FC00FFFE02000000FD00020202FF0304FC0002FDFDF902FFFD04FC020001FE00FE01FD030400FB02FEFD0002FEFFFE06FFFCFCFC040201FD02030302FE0100FBFE01FE00FF0100040300060201FEFFFDFFFFFE04FFFF0300FEFBFDFE00FD06FEFD0200FE00040303FFFE000000000301000000000003FFFF050500FEFA02FE03FF0301040206FFFF0502FDFFFEFDFFFF0003020301050507FE00FF00000000020002FF00FDFE000000FC03FFFE0506FEFDFFFC00FD000001FE000305F901030001FE00FFFE0302FF0001FFFF0001FF0000FAFCFC010305FEFFFC0002FE0305FF01010103FF00010001FF0200FF010003FD00FD05000003FFFFFC0102020100000005FF01FCFF04FC01FC02FF00000000000100FEFF00FF00FF00FC0100FE04FFFB00FC03010000FF01030003FAFE03FDFC0300FF000100FB00FCFA09FE02FEFF0002F8F900FE0305FF060103000003FF05020700000001030200FEFD01FBFE000003FF000004F702FF0200F90100000501000101FF02FF050002FF01FE010102FB000000FDFF0301FC0300000001000103FF000401FCFB01FE01F9000001FE00050500"> : tensor<3x5x40xi8>
    return %0 : tensor<3x5x40xi8>
  }
}

