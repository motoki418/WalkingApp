//
//  SettingView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct SettingView: View {
    //選択されている歩数を保持するための状態変数（初期値は2000）
    @AppStorage("steps_Value") private var targetNumOfSteps: Int = 2000
    
    var body: some View {
        NavigationView{
            Form{
                //目標歩数を選択する画面に遷移する
                NavigationLink(destination: PickerView()){
                    Image(systemName: "figure.walk")
                        .foregroundColor(.keyColor)
                    Text("目標歩数")
                    Spacer()
                    //PickerViewで設定した歩数を表示する
                    Text("\(targetNumOfSteps)歩")
                }
                .navigationBarTitle("設定")
            }//Form
          
        }//NavigationView
    }//body
}//SettingView

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
