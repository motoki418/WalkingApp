//
//  Hom.swift
//  walking
//
//  Created by nakamura motoki on 2021/11/07.
//

import SwiftUI

struct HomeViewHeader: View {
    // 選択した日付を保持する状態変数
    // 親ビューのHomeViewと双方向にデータ連動する
    @Binding var selectionDate: Date
    
    var body: some View {
        HStack(spacing: 100) {
            Button {
                // 今日の日付を取得
                selectionDate = Date()
            }label: {
                Text("今日")
                    .font(.title2)
            }// Buttonここまで
            DatePicker("", selection: $selectionDate, displayedComponents: .date)
                .labelsHidden()
            // ja_JP（日本語＋日本地域）
                .environment(\.locale, Locale(identifier: "ja_JP"))
        }// HStackここまで
    }// bodyここまで
}// HomeViewHeaderここまで
