//
//  ReportView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit

struct ReportView: View {
    //Pickerで表示するテキストを配列で保持する変数
    private let date = ["週間","月間","年間"]
    //Pickerの値が変更できるように状態変数で宣言
    @State private var selection = 0
    
    var body: some View {
        ZStack(alignment: .top){
            NavigationView{
                VStack{
                    Text("Hello World")
                }
                .navigationBarTitleDisplayMode(.inline)
            }//NavigationView
            Picker(selection: $selection, label: Text("")){
                ForEach(0 ..< date.count){ num in
                    Text(date[num])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width:200)
        }//ZStack
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
