//
//  ReportView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//
//
import SwiftUI
import HealthKit

struct ReportView: View {
    // 週間、月間、年間を列挙型で管理
    enum period: String {
        case week = "週間"
        case month = "月間"
        case year = "年間"
    }
    // Pickerの現在選択されているtagの値を格納するための状態変数（初期値は.weekなので週間が選択された状態）
    // Picker(selection: $selectionPeriod)と連動している
    @State var selectionPeriod: period = .week

    var body: some View {
        NavigationView {
            VStack {
                // Pickerで選択した期間を表示
                Text("\(selectionPeriod.rawValue)")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // tagと @State var selectionPeriod:periodは連動している
                    // Pickerで期間が選択されると、選択されたtagの値(期間)がselection:$selectionPeriodにセットされて、
                    // @State var selectionPeriod:periodに選択された期間を渡す。
                    // @State var selectionPeriod:periodにtagの値が渡されると、
                    // Pickerで選択された期間を表示するText("\(selectionPeriod.rawValue)")の中身を変更する
                    // 双方向のデータ連動ができる。
                    Picker(selection: $selectionPeriod, label: Text("選択")) {
                        // Pickerの左側に週間を表示
                        Text("\(period.week.rawValue)")
                            .tag(period.week)
                        // Pickerの真ん中に月間を表示
                        Text("\(period.month.rawValue)")
                            .tag(period.month)
                        // Pickerの右側に年間を表示
                        Text("\(period.year.rawValue)")
                            .tag(period.year)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    // Pickerの幅を指定
                    .frame(width: 300)
                }
            }
        }// NavigationView
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
