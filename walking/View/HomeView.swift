//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit
struct HomeView: View {
    //選択した日付を保持する状態変数
    @State private var selectionDate = Date()
    //選択されている歩数を保持するための状態変数（初期値は2000）
    @AppStorage("steps_Value") var stepsValue = 2000
    var body: some View {
        //alignmentを.topに設定したZStack、NavigationViewとDatePickerを配置することで、最前面の上部であるナビゲーションバーの中央にDatePickerを表示する
        ZStack(alignment: .top){
            NavigationView{
                //目標までの歩数、現在の歩数、目標歩数までの割合、移動距離を縦並びでレイアウトする
                VStack{
                    Text("一日の目標歩数は\(stepsValue)歩です！")
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button{
                            print("tap")
                        }label:{
                            Text("今日")
                        }
                    }
                })//.toolbar
            }//NavigationView
            HStack{
                Image(systemName: "lessthan")
                //日付を選択するDatePickerを作成
                //selectionには、選択した日付を保持する状態変数selectionDateの値に$を付与して参照渡しが出来るようにする
                //displayedComponents:[.date]で日付のみを選択・表示する
                DatePicker("今日", selection: $selectionDate,displayedComponents:.date)
                    //ja_JP（日本語＋日本地域）
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    //ラベルを非表示にする
                    .labelsHidden()
                Image(systemName: "greaterthan")
            }
        }//ZStack
    }//body
}//HomeView

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
