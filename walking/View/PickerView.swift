//
//  PickerView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct PickerView: View {
    //選択されている歩数を保持するための状態変数（初期値は2000）
    @AppStorage("steps_Value") var stepsValue = 2000
    
    var body: some View {
        VStack{
            Spacer()
            //テキストには選択された歩数を表示する
            Text("\(stepsValue)歩")
                .font(.system(size: 45))
            //tagと@AppStorage("steps_value") var stepsValue = 2000は連動している
            //.tagの値がselection: $timerValueにセットされて@AppStorage("steps_value") var stepsValue = 2000にデータを渡す。双方向のデータ連動ができる。
            //選択された歩数を表示する Text("\(stepsValue)歩")の中身を変更する
            Picker(selection: $stepsValue, label: Text("選択")){
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
            }
            Spacer()
        }//VStack
    }//body
}//PickerView

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
