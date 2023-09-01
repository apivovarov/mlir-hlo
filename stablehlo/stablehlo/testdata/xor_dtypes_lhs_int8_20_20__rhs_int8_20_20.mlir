// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi8>, tensor<20x20xi8>)
    %1 = call @expected() : () -> tensor<20x20xi8>
    %2 = stablehlo.xor %0#0, %0#1 : tensor<20x20xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi8>, tensor<20x20xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi8>, tensor<20x20xi8>) {
    %0 = stablehlo.constant dense<"0x000500000005FEFF010200FEFC000000FF000102FDF900FFFEFF00FC0005FD03FD02FF00FDFF00000100FE01FEFF000000FF0000040006FE000001000003FFFC010004FD0001FE020000FDFD0003020002FD04060008010401FF0101FC04FF00FE00FFFC00020000FEFEFC000400FFFB000101FEFE000601050005FB0000000300FE02000102FFFF000303FF04FDFFFF0202010102FE00FFFF03FDFC0001FDFC0002FF04060102FB000101FC040000010100FFFFFE00020000FFFBFFFE020100FB060001FF00FEFF0401FC02FDFCFE010202FEFF00070002FCFD000001FCFD03FE06000301FCFDFEFE0202FB00FD000201FF000500000300FF0101FE0102FE00FF000202060002FCFE08FC0303FD01FF02FE00FC00FF0300000500FD010101FE03FF03000001FFFE0402000000FE000200000003FB0101FE00010001FEFFFCFC0000000002FC00FF01FD000300010000020100FEFF0003FE02FF020205FE040101FFFBFEFD01FCFD000002040004000201FE02FFFF03FEFE01FD01FF0204000001FF05FFFFFE04000301FFFDFBFF0400"> : tensor<20x20xi8>
    %1 = stablehlo.constant dense<"0xFF000600FF000000FE00FD03FE0100020100000000FBFFFF0400FDF701000701000005FFFF04FEFFFF0205030202FFFFFE01FCFF0402FB020003FCFDFEFCFB0201FF02FEFFFCFD010105010000030000FEFFFC03FFFDFD00FD000004FB0300FA00FC00F9000302FC0003FE000001FE02FF020401FF010404FEFC0000FF00FBFE0301FDFF0101F600FEFEFCFCFDFC00FFFFFF0300FE00FFFBFEFFFD0005FE06FC000102010501FF00010000FFFEFC010103FC0001000100FFFE0102FE00FCFD010103FF00FFFF01FC000000F901FE01FEFC00FDFE0001FF0000FDFD020000FF00FE0204FFFE00FDFBFFFFFC0001010000FE00FF02FB00000204FA000002FFFF0101FFFF020200FB00FCF9030300FF010100020001010000FEFDFD0505FC0004FC03FBFC01030100FC0001FF0002FC02FEFD00FC00FE00FD00FF0100FEFCFE03FC08010505FEFF03010102FE0100FDFB00000203FA0405FFFE00FE01010200FD000002FDFE05FFFD01FC00FDFD000001000402010000FC00040102FF01FCFFFE03010003010004FF000004000303FD0003"> : tensor<20x20xi8>
    return %0, %1 : tensor<20x20xi8>, tensor<20x20xi8>
  }
  func.func private @expected() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0xFF050600FF05FEFFFF02FDFD02010002FE000102FD02FF00FAFFFD0B0105FA02FD02FAFF02FBFEFFFE02FB02FCFDFFFFFEFEFCFF0002FDFC0003FDFDFEFF04FE00FF0603FFFD03030105FCFD00000200FC02F805FFF5FC04FCFF01050707FFFAFEFCFF05000102FCFEFD0200040101F9FF0305FF01010205FBFC05FBFF00FBFD03FFFFFF000309FFFEFDFF03F901FF00FDFD0201FCFEFF0401FC00FC05FFFB000003FD050300FDFB01010103FAFC010002FCFFFEFE0102FFFEFEF901FEFEFC01FA05FF0100FFFF030401FCFBFC02FFFFFE0203010006FF02FC00FD0201FC0203000404FCFFFC000501FDFEFB01FC0002FFFFFF07FB000302FBFB01FE03FD0101FEFFFD000400F9FC02F1FF00030200FE02FC00FD01FF03FEFDF805F8FD0105020004FF010300FF020403FF00020202FCFD00FC030501FCFEFF0000FF0201FF0008010505FC0303FE00FFFE0200FCFB0002030304FB05FC000201030307FEF90101FD0600F8FE01FCFC00FFF90004010205FC03FFFFFFFEFA00FFFEFEFEFBFE0300FF06FEFFFAFB000305FFFEF8020403"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
}
