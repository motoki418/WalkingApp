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
    
    enum period: String {
        case week = "週間"
        case month = "月間"
        case year = "年間"
    }
    
    @State var selectionPeriod: period = .week

    var body: some View {
        NavigationView {
            VStack {
                Text("\(selectionPeriod.rawValue)")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker(selection: $selectionPeriod, label: Text("選択")) {
                        Text("\(period.week.rawValue)")
                            .tag(period.week)
                        
                        Text("\(period.month.rawValue)")
                            .tag(period.month)
                        
                        Text("\(period.year.rawValue)")
                            .tag(period.year)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 300)
                }
            }
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
