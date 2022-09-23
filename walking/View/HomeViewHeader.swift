//
//  Hom.swift
//  walking
//
//  Created by nakamura motoki on 2021/11/07.
//

import SwiftUI

struct HomeViewHeader: View {
    // 選択した日付を保持
    @Binding var selectionDate: Date
    
    var body: some View {
        HStack(spacing: 100) {
            
            todayButton
            
            DatePicker("", selection: $selectionDate, displayedComponents: .date)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ja_JP"))
        }
    }
    
    private var todayButton: some View {
        Button {
            selectionDate = Date()
        } label: {
            Text("今日")
                .font(.title2)
        }
    }
}
