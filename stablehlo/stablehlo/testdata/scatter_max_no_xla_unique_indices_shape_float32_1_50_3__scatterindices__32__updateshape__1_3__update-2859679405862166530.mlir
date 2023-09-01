// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<32> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x50x3xf32>, tensor<1x3xf32>)
    %2 = call @expected() : () -> tensor<1x50x3xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x50x3xf32>, tensor<1xi32>, tensor<1x3xf32>) -> tensor<1x50x3xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x50x3xf32>, tensor<1x50x3xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x50x3xf32>, tensor<1x3xf32>) {
    %0 = stablehlo.constant dense<"0x1DF5F7BFD8531A400489FA3FF977D2BF1ED38CC03C1E6FBFB5F851BEEC2CB0C06B0E35C02CE97B4082DF9BBFA9D510C078D7D3BEF8CC1DBFE731D73E4C2ADFC02A9618C1CE918D40880255405601C03F57DF83BED75DC6BF7405B03F5962B43F9B80293EE6055DC0A387DC3EAFC70340048464BF77AA43C003C58EBFE894594080E58BBF5C7E753FA906044041B17ABC12662F4086FAE7C0C3262B3F0BDE44C019D3F5BF9AF46F3F985E9240E74274C0D9E165404A9CFD3FDA45EDBF7A9CA83FB69A9CBD706B76C0831C6F3F3B05DDC0004532C0A63D8BBEBE9A7DC0F9F74BC07FD7B7BF64B83F3E0D6BDD3F946796C0144D7C40236C8140E50022BFB9AEDE40BB9F0D411C2E7240C0F72BC0F609283FA0908ABF3E8B2BC0CDA2F33F505815BF72876940C3900541FC4EA93E5FB30640D828EE40FB187B402D42D0C0CA48DE3FC93F7DC09EC965C035CD8B4056A1C1C0AE9A90C088F7A8406D6DE53F3160513F8BF58A3FB0C5E6C0CB1F1C40EB9AE63E53C39F400FC64A40919C5A3F7075BBC019FE0FC06F688840B728F5BE8BAF6B40EECEC53EC5813E40F55371BEA8946C40B9D1C03F3F46404084258DBF217D5540FD46D13CFDE63E40527119C07B2D963F26C303409B92A840788401BF8F3085BF6C920D4088B009BF7757B240A418A0BFBDDF613A9DBFF83DE7D12E404E11B2BF49F7E93F5F4779C0ADEC77BFD5458B3D37176A40DB7127C076BC57BFFA23384035FD4E40F0F8DFBF4956A5BF5D2804C109DFE33F2BB652BD4F344340D67098404F0BF53F4F1F6040827121405D6492BD8B4C38C05CD037BFFBA6A3C0AC2D3AC01DF9A2BF37CEC9BF"> : tensor<1x50x3xf32>
    %1 = stablehlo.constant dense<[[0.385554671, 1.80621946, -1.30838525]]> : tensor<1x3xf32>
    return %0, %1 : tensor<1x50x3xf32>, tensor<1x3xf32>
  }
  func.func private @expected() -> tensor<1x50x3xf32> {
    %0 = stablehlo.constant dense<"0x1DF5F7BFD8531A400489FA3FF977D2BF1ED38CC03C1E6FBFB5F851BEEC2CB0C06B0E35C02CE97B4082DF9BBFA9D510C078D7D3BEF8CC1DBFE731D73E4C2ADFC02A9618C1CE918D40880255405601C03F57DF83BED75DC6BF7405B03F5962B43F9B80293EE6055DC0A387DC3EAFC70340048464BF77AA43C003C58EBFE894594080E58BBF5C7E753FA906044041B17ABC12662F4086FAE7C0C3262B3F0BDE44C019D3F5BF9AF46F3F985E9240E74274C0D9E165404A9CFD3FDA45EDBF7A9CA83FB69A9CBD706B76C0831C6F3F3B05DDC0004532C0A63D8BBEBE9A7DC0F9F74BC07FD7B7BF64B83F3E0D6BDD3F946796C0144D7C40236C8140E50022BFB9AEDE40BB9F0D411C2E7240C0F72BC0F609283FA0908ABF3E8B2BC0CDA2F33F505815BF72876940C3900541FC4EA93E5FB30640D828EE40FB187B402D42D0C0CA48DE3FC93F7DC09EC965C035CD8B4056A1C1C0AE9A90C088F7A8406D6DE53F3160513F8BF58A3FB0C5E6C0CB1F1C40EB9AE63E53C39F400FC64A40919C5A3F7075BBC06C67C53E6F688840B728F5BE8BAF6B40EECEC53EC5813E40F55371BEA8946C40B9D1C03F3F46404084258DBF217D5540FD46D13CFDE63E40527119C07B2D963F26C303409B92A840788401BF8F3085BF6C920D4088B009BF7757B240A418A0BFBDDF613A9DBFF83DE7D12E404E11B2BF49F7E93F5F4779C0ADEC77BFD5458B3D37176A40DB7127C076BC57BFFA23384035FD4E40F0F8DFBF4956A5BF5D2804C109DFE33F2BB652BD4F344340D67098404F0BF53F4F1F6040827121405D6492BD8B4C38C05CD037BFFBA6A3C0AC2D3AC01DF9A2BF37CEC9BF"> : tensor<1x50x3xf32>
    return %0 : tensor<1x50x3xf32>
  }
}

