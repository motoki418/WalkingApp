//
//  ColorExtention.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import Foundation
import SwiftUI

// Assets.xcassetsに登録したカラーをextensionでまとめる
// Color（カラーを管理する構造体）に、「keyColor」「backgroundColor」という2つのプロパティを追加する
// extensionを使うことで、定義したカラーが一元管理できるようになる
extension Color {
    static let keyColor = Color("blue")
    static let backgroundColor = Color("background")
}
