// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2xi8>, tensor<2xi8>)
    %1 = call @expected() : () -> tensor<2xi8>
    %2 = stablehlo.remainder %0#0, %0#1 : tensor<2xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2xi8>, tensor<2xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2xi8>, tensor<2xi8>) {
    %0 = stablehlo.constant dense<[4, -1]> : tensor<2xi8>
    %1 = stablehlo.constant dense<[3, -5]> : tensor<2xi8>
    return %0, %1 : tensor<2xi8>, tensor<2xi8>
  }
  func.func private @expected() -> tensor<2xi8> {
    %0 = stablehlo.constant dense<[1, -1]> : tensor<2xi8>
    return %0 : tensor<2xi8>
  }
}
