//
//  SettingView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct SettingView: View {
    //HealthDataViewModelを参照する状態変数
    //これでViewがViewModelのデータを監視できるようになる
    @ObservedObject private var HealthDataVM = HealthDataViewModel()
    
    var body: some View {
        NavigationView{
            Form{
                //目標歩数を選択する画面に遷移する
                NavigationLink(destination:PickerView()){
                    Image(systemName:"figure.walk")
                        .foregroundColor(.keyColor)
                    Text("目標歩数")
                    Spacer()
                    //PickerViewで設定した目標歩数がHealthDataViewModelの
                    //@AppStorage("steps_Value") var targetNumOfSteps: Int = 2000 に格納されているので表示する
                    Text("\(HealthDataVM.targetNumOfSteps)歩")
                }
            }//Form
            .navigationBarTitle("設定")
        }//NavigationView
    }//body
}//SettingView

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
