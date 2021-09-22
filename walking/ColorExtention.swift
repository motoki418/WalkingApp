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
//Color（カラーを管理するクラス）に、「blueButton」「greenButton」「backgroundColor」という3つの新しいクラスプロパティが追加される。
//extensionを使うことで、定義したカラーが一元管理できるようになる
extension Color{
  
    static let keyColor = Color("blue")
    
    static let backgroundColor = Color("background")
}
//staticを付ける理由は、変数の場合は実際にパフォーマンスに影響して、関数の場合は、そのコードを読む人にインスタンスの状態依存の処理ではないことを明示的に伝えたいときや
//staticな処理に対して誤って動的なパラメータを記述してしまうミスを防ぐために書いたほうがいいものです。
