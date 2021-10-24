//
//  ReportView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

//import SwiftUI
//import HealthKit
//
//struct ReportView: View {
//    //HealthDataViewModelを参照する状態変数
//    //これでViewがViewModelのデータを監視できるようになる
//    @ObservedObject private var ReportVM: ReportViewModel = ReportViewModel()
//    
//    var body: some View {
//        NavigationView{
//            VStack{
//                //Pickerで選択した期間を表示
//                Text("\(ReportVM.selectionPeriod.rawValue)")
//            }
//            .toolbar{
//                ToolbarItem(placement:.principal){
//                    //HealthDataViewModelの @Published var selectionPeriod: period = .weekから
//                    //週間、月間、年間を列挙型で管理するperiod列挙体の状態の変化を受信してPickerに表示する。
//                    //選択された期間が(selection:$HealthDataVM.selectionPeriod)にセットされて、
//                    //選択された期間を表示するText("\(HealthDataVM.selectionPeriod.rawValue)")の中身を変更する。
//                    Picker(selection:$ReportVM.selectionPeriod,label:Text("選択")){
//                        //Pickerの左側に週間を表示
//                        Text("\(ReportViewModel.period.week.rawValue)")
//                            .tag(ReportViewModel.period.week)
//                        //Pickerの真ん中に月間を表示
//                        Text("\(ReportViewModel.period.month.rawValue)")
//                            .tag(ReportViewModel.period.month)
//                        //Pickerの右側に年間を表示
//                        Text("\(ReportViewModel.period.year.rawValue)")
//                            .tag(ReportViewModel.period.year)
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    //Pickerの幅を指定
//                    .frame(width:300)
//                }
//            }//.toolbar
//        }//NavigationView
//    }
//}
//
//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}
