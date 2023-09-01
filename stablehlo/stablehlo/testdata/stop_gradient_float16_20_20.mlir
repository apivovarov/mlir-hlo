// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x02BE8BAD31C358440D3D254158C1513D6DB8A33D1E4212C20EB8123FF2402F42AAB8A445A2AB664113C352B33847FC45CF2C623BE7BD06BA6F3FB02C13C21BC8543F7EC2AABC293A494373435F438144AEC52EC5DB4431B3F7B468BEC7BF0F42FD3F13C10DC4D441E1C49C46A834853A99BAF2BBB6C4B7B263C2D3432A40FDBEA7C2A144E02F09415C436EC0F74068C04744F5BE4CC57DBDA6B79DB4DA352E4029BEECC447410B3FBBBB8B431FC26F3D52BC77380B423642E5C29BA4C6C31FB6D6351EBCED3F24C5EAC194B5C43E904280343E40053ADBC09BBDD03DE0457D384DB988BCC8BC2A425BBC2A46963AC3403342DB342CB12E3CCCBE3DBEBFBB3FC321B5F64125C2A2BFA93C64465C3C7D3CFBB7ED38CEC22EC12244F9C183C1544490BA21B4C2BA30B84FC3E632FE3E6CC21A424C4673C40A33DB360844FE40E93D75A158BC1E3E8642EBC1CC40084329C3572DD23E4A41C2392AC2DDB1D6BD7A45553F71C33F3BA038333B0CC04F438D3DD4C264C0FE43BCB96BB40D44F7453A2CB140043741414E42B54195C1F34300BA093EA437F740DBC2EDBEE4C2143CC23EC5351E410F3CD9BCE5B6513D7BBD61C154C291C345C0A1BC57C4EABE05C551C113BA6E380E3389C0DCC1D3C5CF2DD5BDCDC35C4321B06047F8B23D45213CC6C46239992E94B342C54C4060C2604563C76BBE72446CC04A39C73C0FBD3BC33DC2C4BD7DB7F13F0A2D81C28B3F56BD6DBFCD40ADC470413737EEBC50C0CA41CAC1B0B9BA42A03C71B8644456BEA232B8C3EBC194BC333F7E441638B7C3AE40D3C6AF415FB41EC876340C3D0D32F5BDFEBFC5BE15453D40193C60C06B428FC51FC4D5C6B53C5D40AB40DEC5BDB846C8B242333CA0414F42E6C30AC38AC25CB816C025BF0DB12AC411404F3C49C432BE5B43D1C0C9BD8E449337C94206B7FA4496C24A3780C04441D23D1DC352BE2ABC2EC639C289C49DC1C43C26BC8C401641853C35B4663F38C643C3A2BD1BC4553AF040593AD740383C5042E9BE9FC64037A1C70DC7EA409C38E13FAEC625C1B441AD3C58C1653CDAC175BDCB3A77407FB7DE38ECBD88C482BDA23062C41D4646C118B625C605BF65BFDAB6EE3CAAC1A5C05BC1"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x02BE8BAD31C358440D3D254158C1513D6DB8A33D1E4212C20EB8123FF2402F42AAB8A445A2AB664113C352B33847FC45CF2C623BE7BD06BA6F3FB02C13C21BC8543F7EC2AABC293A494373435F438144AEC52EC5DB4431B3F7B468BEC7BF0F42FD3F13C10DC4D441E1C49C46A834853A99BAF2BBB6C4B7B263C2D3432A40FDBEA7C2A144E02F09415C436EC0F74068C04744F5BE4CC57DBDA6B79DB4DA352E4029BEECC447410B3FBBBB8B431FC26F3D52BC77380B423642E5C29BA4C6C31FB6D6351EBCED3F24C5EAC194B5C43E904280343E40053ADBC09BBDD03DE0457D384DB988BCC8BC2A425BBC2A46963AC3403342DB342CB12E3CCCBE3DBEBFBB3FC321B5F64125C2A2BFA93C64465C3C7D3CFBB7ED38CEC22EC12244F9C183C1544490BA21B4C2BA30B84FC3E632FE3E6CC21A424C4673C40A33DB360844FE40E93D75A158BC1E3E8642EBC1CC40084329C3572DD23E4A41C2392AC2DDB1D6BD7A45553F71C33F3BA038333B0CC04F438D3DD4C264C0FE43BCB96BB40D44F7453A2CB140043741414E42B54195C1F34300BA093EA437F740DBC2EDBEE4C2143CC23EC5351E410F3CD9BCE5B6513D7BBD61C154C291C345C0A1BC57C4EABE05C551C113BA6E380E3389C0DCC1D3C5CF2DD5BDCDC35C4321B06047F8B23D45213CC6C46239992E94B342C54C4060C2604563C76BBE72446CC04A39C73C0FBD3BC33DC2C4BD7DB7F13F0A2D81C28B3F56BD6DBFCD40ADC470413737EEBC50C0CA41CAC1B0B9BA42A03C71B8644456BEA232B8C3EBC194BC333F7E441638B7C3AE40D3C6AF415FB41EC876340C3D0D32F5BDFEBFC5BE15453D40193C60C06B428FC51FC4D5C6B53C5D40AB40DEC5BDB846C8B242333CA0414F42E6C30AC38AC25CB816C025BF0DB12AC411404F3C49C432BE5B43D1C0C9BD8E449337C94206B7FA4496C24A3780C04441D23D1DC352BE2ABC2EC639C289C49DC1C43C26BC8C401641853C35B4663F38C643C3A2BD1BC4553AF040593AD740383C5042E9BE9FC64037A1C70DC7EA409C38E13FAEC625C1B441AD3C58C1653CDAC175BDCB3A77407FB7DE38ECBD88C482BDA23062C41D4646C118B625C605BF65BFDAB6EE3CAAC1A5C05BC1"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
