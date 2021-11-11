//
//  Hom.swift
//  walking
//
//  Created by nakamura motoki on 2021/11/07.
//

import SwiftUI

struct HomeViewHeader: View {
    //HomeView経由でHomeViewModelを監視する
    @ObservedObject var HomeVM: HomeViewModel
    
    var body: some View {
        HStack(spacing:100){
            Button{
                //今日の日付を取得
                HomeVM.selectionDate = Date()
            }label:{
                Text("今日")
                    .font(.title2)
            }
            DatePicker("",selection:$HomeVM.selectionDate,displayedComponents:.date)
            //プロパティの変更を検知する.onChangeを使用してHomeVMHomeVM.HomeVM.selectionDateに格納されている日付が変更されたら、
            //HomeVMgetDailyStepCount()を呼び出して日付に合った歩数を表示する
                .onChange(of:HomeVM.selectionDate,perform: { _ in
                    HomeVM.getDailyStepCount()
                    print(HomeVM.selectionDate)
                })
                .labelsHidden()
            //ja_JP（日本語＋日本地域）
                .environment(\.locale,Locale(identifier:"ja_JP"))
        }//HStack
    }
}
