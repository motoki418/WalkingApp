//
//  ReportView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit

struct ReportView: View {
    
    //Pickerで選択されているテキストを保持するための状態変数（初期値は2000）
    //Picker(selection: $selectionWeekと連動している
    @AppStorage("selection_Week") private var selectionWeek = "週間"
    
    var body: some View {
        ZStack(alignment: .top){
            NavigationView{
                VStack{
                    Text("\(selectionWeek)")
                }
            }//NavigationView
            //tagと@AppStorage("selection_Week") var  selectionWeek= "週間"は連動している
            //.tagの値がselection:$selectionWeekにセットされて ,@AppStorage("selection_Week") var selectionWeek = "週間"にデータを渡す。
            //双方向のデータ連動ができる。
            //選択されたテキストを表示する Text("\(selectionWeek)")の中身を変更する
            Picker(selection: $selectionWeek, label: Text("選択")){
                Text("週間")
                    .tag("週間")
                Text("月間")
                    .tag("月間")
                Text("年間")
                    .tag("年間")
               
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
