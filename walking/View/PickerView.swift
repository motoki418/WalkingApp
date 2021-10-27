//
//  PickerView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct PickerView: View {
    //歩数をUserDefalutsから読み込んで保持するための状態変数（初期値は2000）
    @AppStorage("steps_Value") private var targetNumOfSteps: Int = 2000
    
    var body: some View {
        VStack{
            Spacer()
            //選択された歩数を表示する
            Text("\(targetNumOfSteps)歩")
                .font(.system(size: 45))
            //選択された歩数が(selection:$targetNumOfSteps)にセットされて、
            //@AppStorage("steps_value") var targetNumOfSteps = 2000にデータを渡してデータの永続化がされる。
            //SettingView,HomeViewでも選択された目標歩数を利用できるようになる。
            //選択された歩数を表示するText("\(targetNumOfSteps)歩")の中身を変更する
            Picker(selection:$targetNumOfSteps,label:Text("選択")){
                Text("2000")
                    .tag(2000)
                Text("3000")
                    .tag(3000)
                Text("4000")
                    .tag(4000)
                Text("5000")
                    .tag(5000)
                Text("6000")
                    .tag(6000)
                Text("7000")
                    .tag(7000)
                Text("8000")
                    .tag(8000)
                Text("9000")
                    .tag(9000)
                Text("10000")
                    .tag(10000)
                Text("20000")
                    .tag(20000)
            }
            //Pickerのスタイルを指定
            //Xocde12まではデフォルトがWheelPickerStyle()だったが、Xcode13からMenuPickerStyle()がデフォルト設定に変更されている
            .pickerStyle(WheelPickerStyle())
            Spacer()
        }//VStack
    }//body
}//PickerView

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
