// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2xi32>, tensor<2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<2x7xf32>) {
    %0 = stablehlo.constant dense<"0x47D627BFADB21140AD17BAC0FEA74140A9BB9BBF567794BD1A3CBB3E242B573F6203CB3F94FC483F3E94EFBF248B8D409D34DC3FEC7124400F009DBF7299784096626ABFD9C2ABBE22CA4AC010D49B3F98F4D43EB8FF43401A05C4C07E1A5DC05B83C53FE38F03C01824143FCE6AD6C0DD4EE03F86E02F4033E9AC3F4FF2F4BC94F6003D3C3B9ABFB89315408BB3F33EA214A1C04A6EAEC066933440E56F18C0BD6E8DC00C6529BD073C8E3FB797B03FBA5875BF3630AA3F243BD8C0A7FA84BFC9C9403E348047C0D8F8F0BFF1F868401112083F759DB3C001AF1AC0F8A98CBD4346154026D1B8BF117DBFBFAD65F0BEB3EF664076CD0BC068B6B2C09970C93F8A4B95BF7DC41FC0341DC6C0744C1E40C45F8C4079B39FBE58112BC008B380C04808994096133DC0EF6C19C0136BC6C0DE96C43FA49F0F4080C1933F55EC8C40C33F393E85CC7640414FB64006B0B43F3B4E113FDABE0DBFBC85DD3EAC3A26405E088F3FFED99040F4E228BF811596409655E1BF6D6BBAC0C03564BF981D6C3FAF03ACC0951D7BBF200F72C0F9A7E0C029740FC056B69F3F4CE289C05D4218C0034CEFBF785E493E3A5A4ABF241B433FBB78493F8180913F133E9A3F052E37BE46933A40A09B1E40C8F254C0E81A34BF2F75D2C07F51F4BFBA7CEA3EABE38A3F4AE1D4BFB9EB8440BCE1E8BE3E437D406CE74B40505FCD3F28B025BF8EDCE0BFD0AA1DBFF6E0F93F89A823BF5C48DBBFA8E09E3FCEDC01C09E89E53F056BC93FF653D5C02D99913F469C44400938063F3E786FBD71537C40673633C0D0DA3CC030DADB3D11DE00400615823F5D8A49BD3D3477C05E740C407029B8BF5A5A12C05F1453C042DA07404D353D3F1DE5853E96A1ADBF26FD913FF8E3B3BFBEF6FD3FC55886401E5B92BF88A5963F9551AF4018DB2F3DF28453C0C284A3C0FBA8B43E7D0604C090F93AC0EA45A5C0564E46C00D25B03F139E66C0148610C0DCFB8B3ED153E1403C9B763E8AC234C039D234C0AA242DC0D21365BEFE43B53E0E25E8C01239D43F55BE6E3FCB9052BC1B1D8BC00C218EC04A74883F58F38340EE212840C1867840B9D52D405EDCAFC05DF084BFE43CBD3F65B3B5C0F100F7BEA2F4C63F75495740EDC851C0D60E493D1FB68B403447C33F43E92740E7CDD7BDF80D52C047E6893E4B5200C0"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[0.0335783735, -3.84593415, -1.43245518, -0.278185546, -2.75695825, -0.575453162, 0.0353178568], [-3.23545241, -1.89988875, -1.43240726, 2.14100957, -0.559337735, -0.452455759, 0.370548546]]> : tensor<2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x47D627BFADB21140AD17BAC0FEA74140A9BB9BBF567794BD1A3CBB3EBCC35F3F18A210C0CEB825BFEA9709C08E48D53F2A8C923F92B426400F009DBF7299784096626ABFD9C2ABBE22CA4AC010D49B3F98F4D43EB8FF43401A05C4C07E1A5DC05B83C53FE38F03C01824143FCE6AD6C0DD4EE03F86E02F4033E9AC3F4FF2F4BC94F6003D3C3B9ABFB89315408BB3F33EA214A1C04A6EAEC066933440E56F18C0BD6E8DC00C6529BD073C8E3FB797B03FBA5875BF3630AA3F243BD8C0A7FA84BFC9C9403E348047C0D8F8F0BFF1F868401112083F759DB3C001AF1AC0F8A98CBD4346154026D1B8BF117DBFBFAD65F0BEB3EF664076CD0BC068B6B2C09970C93F8A4B95BF7DC41FC0341DC6C0744C1E40C45F8C4079B39FBE58112BC008B380C04808994096133DC0EF6C19C0136BC6C0DE96C43FA49F0F4080C1933F55EC8C40C33F393E85CC7640414FB64006B0B43F3B4E113FDABE0DBFBC85DD3EAC3A26405E088F3FFED99040F4E228BF811596409655E1BF6D6BBAC0C03564BF981D6C3FAF03ACC0951D7BBF200F72C0F9A7E0C029740FC056B69F3F4CE289C05D4218C0034CEFBFC07B42C0562E2CC01A972BBF7C643B4040D0133F02A8403F0F43443E46933A40A09B1E40C8F254C0E81A34BF2F75D2C07F51F4BFBA7CEA3EABE38A3F4AE1D4BFB9EB8440BCE1E8BE3E437D406CE74B40505FCD3F28B025BF8EDCE0BFD0AA1DBFF6E0F93F89A823BF5C48DBBFA8E09E3FCEDC01C09E89E53F056BC93FF653D5C02D99913F469C44400938063F3E786FBD71537C40673633C0D0DA3CC030DADB3D11DE00400615823F5D8A49BD3D3477C05E740C407029B8BF5A5A12C05F1453C042DA07404D353D3F1DE5853E96A1ADBF26FD913FF8E3B3BFBEF6FD3FC55886401E5B92BF88A5963F9551AF4018DB2F3DF28453C0C284A3C0FBA8B43E7D0604C090F93AC0EA45A5C0564E46C00D25B03F139E66C0148610C0DCFB8B3ED153E1403C9B763E8AC234C039D234C0AA242DC0D21365BEFE43B53E0E25E8C01239D43F55BE6E3FCB9052BC1B1D8BC00C218EC04A74883F58F38340EE212840C1867840B9D52D405EDCAFC05DF084BFE43CBD3F65B3B5C0F100F7BEA2F4C63F75495740EDC851C0D60E493D1FB68B403447C33F43E92740E7CDD7BDF80D52C047E6893E4B5200C0"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

