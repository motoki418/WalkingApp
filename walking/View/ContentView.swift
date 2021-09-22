//
//  ContentView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            //円グラフと目標までの歩数を表示する画面
            HomeView()//1枚目の子ビュー
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
            //週間・月間・年間の歩数と距離を棒グラフで表示する画面
            ReportView()//2枚目の子ビュー
                .tabItem {
                    Label("レポート", systemImage: "chart.bar.fill")
                }
            //アプリのテーマカラーと目標歩数を設定する画面
            SettingView()//3枚目の子ビュー
                .tabItem {
                    Label("設定", systemImage: "gearshape.fill")
                }
        }//TabView
    }//body
}//ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
