// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>) {
    %0 = stablehlo.constant dense<"0x60C0C5BFE63F6EC022BF73C0403F75C00C403D3F03C0673F30C0893FE13D9EC071C056408BBC1BC023C019BFE0BF81BF3EBF6BBFB1C0D6C03FBF6440733F033F0DC0D13FF140B740F6407ABEE4BE2C4049C0E440A0C0983EFE40DA404340ECC080C003BF1EBF9EC00E40A8C0EA40D2BFC7BF27C0283E33BF04BF47BE9B4084BF06C0393FAD3FBBBFDFC08EBFE93F32404E3F14C089C095BF7CC089BFD33FD2403EBE61408040ADBF80BFAABF01C0FE3FDFBFDF3F5E3FFB3CEABD97C0FBBF7DBF90C02D4090BE54405F4085BFA840ABBF0141A33F76C0EEBFC4BF13401E404B4090BF55BF75C00AC0143EF8BF26C0643F1CBDA3C09540803F75BF964047C0B5BF09C0593F6E3EA54018C0B2BF463F49401CBF64BB7DBF42C0953FB03EBA3FCFBFAA40B24084C0B23F2340093F98BF8840264085407240EFBF234041C01B40DEBF0A3FCFBD7D3DC0C011C0453F6E40FABEFE3FF8BF07BFD0C035C0393E08BF7FC03F402340BA4008C0BDBF8E3FF63F14C091BFA3C07240723EA5404E401E40673F2D3F8DBF6040E93F203FF7BFC4BC1B3FB83FF03FCD3F49C0CCBF9D409CC0193E814083BF"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<"0x4EBFAC3E963E343E8CC0193E134029408A3FD53E063D9E3FDCBF4BC008C0AA3F13C0B1BF113FF2BF1A402240C6BF9A3F4BBF1FBFE6C08B3E0CBF203F9640B9C00BC06DC0E4BFC73F27C0C7C0D0C085C0A63F9EBFBD3FBEC0CABF8EBF373ED1402B3F9B3F26C0A1BF1D40B940D5C055C06AC00AC09A3F53C05540593F8D3F3BBEA8C082BF48405ABE873F3C3E6BBF62BE09C01DBF12BFC3BF44BF64BF9A4095C058C0DFBFBF40574094BF8CBB05C1B14085BF9BC013C112C089C0D8BF75408DBF75C065C0BF3F1D4074400CBF4040954017C0FEBE843FE33F57C0F73EAABD9FC0883F25C0944020BF68401FBD9B3F05C059C0283FA5BFC93FC9BE783F383E72BF9F403DBE56C0963FD43D3AC028BFCEC0A7BFF93EFB3F433F"> : tensor<5x2x2x7xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0x4EBFAC3EE63F343E22BF193E134029400C403D3F063D9E3FDCBF893FE13DAA3F13C05640113FF2BF1A402240C6BF9A3F3EBF1FBFB1C08B3E3FBF6440733F033F0DC0D13FF140B740F6407ABEE4BE2C4049C0E4400CBF203FFE40DA4043406DC0E4BFC73F1EBF9EC00E4085C0EA409EBFBD3F27C0283E33BF373ED1409B409B3F06C0393F1D40B940D5C08EBFE93F32404E3F14C089C095BF7CC089BFD33FD2403EBE61408040ADBF80BFAABF9A3FFE3F5540DF3F8D3FFB3CEABD82BF48405ABE873F2D4090BE54405F401DBFA840ABBF0141A33F9A40EEBFC4BF1340BF40574090BF55BF75C00AC0143EF8BF26C0643F1CBDA3C09540803F75BF964094BF8CBB09C0B1406E3EA54018C0B2BF463F4940754064BB7DBF42C0BF3F1D4074400CBFAA40B24017C0B23F2340E33F98BF8840264085407240EFBF234041C01B40DEBF0A3FCFBD7D3DC0C011C0453F6E40FABEFE3FF8BF944020BF6840393E9B3F05C03F402340BA40C93FC9BE8E3FF63F72BF9F403DBE7240963FA5404E401E40673F2D3FF93E6040E93F203FF7BFC4BC1B3FB83FF03FCD3F49C0CCBF9D409CC0193E814083BF"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

