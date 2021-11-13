//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct HomeView: View {
    //選択した日付を保持する状態変数
    //子ビューのHomeViewHeaderと双方向にデータ連動する
    @State private var selectionDate: Date = Date()
    
    //この変数で表示位置を指定できる(中央はtag(1)なので1)
    @State private var selection = 1
    
    //日時計算クラスCalenderのインスタンスを生成
    private let calendar: Calendar = Calendar(identifier: .gregorian)
    
    var body: some View {
        //子ビューのHomeViewHeaderとHomeViewBodyを表示する
        VStack{
            //HomeViewHeaderを表示する時に引数としてselectionDate指定して日付を渡す
            //HomeViewHeaderでも日付を変更するので、変更した日付を受け取れるように$を付与してバインディングする
            HomeViewHeader(selectionDate:$selectionDate)
            //TabViewのPageTabViewStyleで予め3画面分(前日・当日・翌日)を用意する
            TabView(selection: $selection){
                //HomeViewBodyを表示する時に引数としてselectionDateを指定して日付を渡す
                //HomeViewBodyでは日付を変更しないので、$を付与しない。
                HomeViewBody(selectionDate: selectionDate)
                    .tag(0)
                HomeViewBody(selectionDate: selectionDate)
                    .tag(1)
                HomeViewBody(selectionDate: selectionDate)
                    .tag(2)
            }//TabView
            //表示位置を管理するselectionが変わったとき tag番号が変わった時の処理
            .onChange(of: selection){ newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    print("newValue = \(newValue)")
                    selection = 1
                    //右にスワイプしてnewValueが0になったら表示する日付を前日にする
                    if newValue == 0{
                        selectionDate = calendar.date(byAdding: DateComponents(day:-1),to:selectionDate)!
                    }
                    //左にスワイプしてnewValueが2になったら表示する日付を翌日にする
                    else if newValue == 2{
                        selectionDate = calendar.date(byAdding: DateComponents(day:1),to:selectionDate)!
                    }
                }// DispatchQueue.main.asyncAfter
            }//onChange
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }//VStack
    }//body
}//HomeView
