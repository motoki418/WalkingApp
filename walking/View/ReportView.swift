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
    
    enum Period: String, CaseIterable {
        case week = "週間"
        case month = "月間"
        case year = "年間"
    }
    
    @State var selectionPeriod: Period = .week
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectionPeriod, label: Text("選択")) {
                    ForEach(Period.allCases, id: \.self) { period in
                        Text("\(period.rawValue)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
            }
            .navigationTitle("歩数")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
