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
                    Label("ホーム",systemImage:"house.fill")
                }
            //目標歩数を設定する画面
            SettingView()//3枚目の子ビュー
                .tabItem {
                    Label("設定",systemImage:"gearshape.fill")
                }
        }//TabView
        //tabItemの色指定
        .accentColor(Color.keyColor)
    }//body
}//ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//HealthKitのデータ構造のまとめ
//ここまでHealthKitでデータを扱うためにまずはデータ構造について見てきました。
//HealthKitで扱うデータで重要なことはデータのタイプです。
//具体的には、
//定量的な(歩数や歩行距離)データのタイプはHKQuantityType、定質的な(生理痛の辛さや睡眠の質)データのタイプはHKCategoryType
//それに対応するデータは
//HKQuantityType →　HKQuantitySample、
//HKCategoryType　→　HKCategorySample
//のように表され、クラスの継承関係は以下のようになっています。

//HKObjectType/HKObjectがルートクラスであり、データを作成したアプリやデバイスの情報やメタデータなどを持っています。
//そしてそのサブクラスにHKSampleType/HKSampleがあり、これはデータを記録した日時などを持っています。
//そして最後に具体的なデータを表すHKQuantityType/HKQuantitySample、HKCategoryType/HKCategorySampleなどがあり、それぞれに適したデータを持っている、というような階層になっています。
