//
//  ColorExtention.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import Foundation
import SwiftUI

//［Assets.xcassets］に登録したカラーをextensionでまとめる
//extensionとは、拡張するという意味で、クラス・構造体・列挙型に対して機能を拡張出来る。拡張は追加するという意味合いがある
//Color（カラーを管理する構造体）に、「keyColor」「backgroundColor」という2つのプロパティを追加する
//extensionを使うことで、定義したカラーが一元管理できるようになる
extension Color {
  
    static let keyColor = Color("blue")
    
    static let backgroundColor = Color("background")
}

//スタティックプロパティ(static)は型のインスタンスではなく型自身に紐付くプロパティで、インスタンス間で共通する値の保持、設定をする場合などに使用できる。
//スタティックプロパティにはイニシャライザに相当する初期化のタイミングがないため、宣言時に必ず初期値をもたせる必要がある。ないとエラーが出る。

//この例文ではスタティックプロパティsignatureは全てのGreeting型の値に共通した値になっている
//スタティックプロパティにアクセスする時は型自身に紐づくためインスタンス.スタティックプロパティ名とするとエラーになる
//型名.スタティックプロパティ名でアクセスする

//struct Greeting{
//static let signature = "Sent form iPhone"
//
//var to = "yosuke Isikawa"
//var body = "Hello!"
//}
//func print(greeting : Greeting){
//    print("to: \(greeting.to)")
//    print("body: \(greeting.body)")
//    print("signature: \(Greeting.signature)")
//}
//
//let greeting1 = Greeting()
//var greeting2 = Greeting()
//greeting2.to = "Yusei Nishikawa"
//greeting2.body = "Hi!"
//
//print(greeting: greeting1)
//print("---")
//print(greeting: greeting2)

