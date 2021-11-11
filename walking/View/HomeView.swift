//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    //HealthDataViewModelを参照する状態変数
    //これでViewがViewModelのデータを監視できるようになる
    //HomeViewModelの @Published var stepsと @Published var selectionDateの
    //2つの変数の状態を受信する
    @ObservedObject var HomeVM: HomeViewModel = HomeViewModel()
    
    //この変数で表示位置を指定できる(中央はtag(1)なので1)
    @State private var selection = 1
    
    var body: some View {
        //子ビューのHomeViewHeaderとHomeViewBodyを表示する
        VStack{
            //HomeVMを親ViewのHomeViewから、子ViewのHomeViewHeaderに引数として渡して
            //子ViewでもHomeViewModelのデータを受信して、Viewの更新がされるようにする
            HomeViewHeader(HomeVM: HomeVM)
            //TabViewのPageTabViewStyleで予め3画面分(前日・当日・翌日)を用意する
            TabView(selection: $selection){
                //HomeVMを親ViewのHomeViewから、子ViewのHomeViewBodyに引数として渡す
                HomeViewBody(HomeVM: HomeVM)
                    .tag(0)
                HomeViewBody(HomeVM: HomeVM)
                    .tag(1)
                HomeViewBody(HomeVM: HomeVM)
                    .tag(2)
            }//TabView
            .onAppear{
                //HealthKitが自分の現在のデバイスで利用可能かを確認する
                //HKHealthStore.isHealthDataAvailable() → HealthKitが利用できるかのメソッド
                if HKHealthStore.isHealthDataAvailable(){
                    //アプリからデバイスにデータへのアクセス権限をリクエスト
                    //toShareが書き込み、readが読み込み
                    print("承認されました")
                    HomeVM.healthStore.requestAuthorization(toShare:[],read:[HomeVM.readTypes]){success, error in
                        if success{
                            //リクエストが承認されたので一日ごとの合計歩数を取得するメソッドを呼び出す
                            HomeVM.getDailyStepCount()
                        }
                    }//requestAuthorization
                }//if HKHealthStore.isHealthDataAvailable()
            }//onAppear
            //表示位置を管理するselectionが変わったとき tag番号が変わった時の処理
            .onChange(of: selection){ newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    print("newValue = \(newValue)")
                    //右にスワイプしてnewValueが0になったら、selectionの値を1に戻して3画面の真ん中に表示する
                    if newValue == 0{
                        selection = 1
                        //表示する日付を前日にする処理
                        HomeVM.selectionDate = HomeVM.calendar.date(byAdding: DateComponents(day:-1),to:HomeVM.selectionDate)!
                    }
                    //左にスワイプしてnewValueが1になったら、selectionの値を1に戻して3画面の真ん中に表示する
                    else if newValue == 2{
                        selection = 1
                        //表示する日付を翌日にする処理
                        HomeVM.selectionDate = HomeVM.calendar.date(byAdding: DateComponents(day:1),to:HomeVM.selectionDate)!
                    }
                }// DispatchQueue.main.asyncAfter
            }//onChange
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }//VStack
    }//body
}//HomeView
