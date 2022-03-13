//
//  HomeViewBody.swift.swift
//  walking
//
//  Created by nakamura motoki on 2021/11/07.
//

import SwiftUI
import HealthKit

struct HomeViewBody: View {
    //HomeViewBodyModelを監視する
    @ObservedObject private var HealthDM: HealthDataModel
    
    //日付をHomeViewからもらいつつ、HomeBodyViewModelのselectionDateにセットしてあげることで、データの再取得が行われてグラフが再描画される。
    //HomeView → HomeViewBody → HomeViewBodyModelの順でselectionDateを渡す
    //initで初期化する
    init(selectionDate: Date){
        HealthDM = HealthDataModel()
        HealthDM.selectionDate = selectionDate
    }
    
    //歩数をUserDefalutsから読み込んで保持するための状態変数（初期値は2000）
    @AppStorage("steps_Value") private var targetNumOfSteps: Int = 2000
    
    var body: some View {
        //日付、目標までの歩数、現在の歩数、目標歩数までの割合、移動距離を縦並びでレイアウトする
        VStack(spacing:50){
            //今日歩いた歩数が目標歩数を上回った時と上回っていない時の処理
            //達成率が100％未満の場合
            if HealthDM.steps < targetNumOfSteps{
                HStack{
                    Text("目標歩数まで")
                    Text("\(targetNumOfSteps - HealthDM.steps)")
                        .foregroundColor(Color.keyColor)
                    Text("歩！")
                }
                .font(.title)
            }
            //達成率が100%以上の場合
            else{
                Text("今日の目標達成！🎉🎉🎉")
                    .font(.title)
            }
            //ZStackで２つのCircleを重ねて円形のプログレスバー・進捗表示を実装する
            ZStack{
                //背景用のCircle
                Circle()
                //strokeは円をくり抜いて輪を作るメソッド
                //線の色と線の幅を指定　lineWidthは線の幅を指定 デフォルトは1
                    .stroke(Color.keyColor,style:StrokeStyle(lineWidth:20))
                //円の透明度
                    .opacity(0.2)
                //進捗用のCircle
                //進捗Circleは歩数が格納されている状態変数HomeBodyVM.stepsの値を使って長さを変える
                Circle()
                //trim()を使うことで指定した範囲でトリミングをすることができる
                //from:トリミング開始位置 to:トリミング終了位置　0.0 〜 1.0の間で指定
                //引数toの数値を変更ことで進捗率を変更することが出来る
                //今回は引数toに今日歩いた歩数を目標歩数で割った達成率を設定することで、その達成率に応じて進捗を示すCircleの表示を行う
                //Int型で割り算すると結果はInt型になり小数点以下は切り捨てられてしまうのでHomeBodyVM.stepsとtargetNumOfHomeBodyVM.stepsをDouble型に変換して計算を行う
                    .trim(from:0.0,to:CGFloat(min(Double(HealthDM.steps) / Double(targetNumOfSteps),1.0)))
                //線の色と線の幅と線の先端のスタイルを指定 .roundで先端を丸めることが出来る
                    .stroke(Color.keyColor,style:StrokeStyle(lineWidth:20,lineCap:.round))
                //アニメーションの設定
                //1秒かけて進捗を示すCircleを表示する
                    .animation(.linear(duration:1))
                //-90度を指定して円の始まりを一番上に持ってくるための処理。デフォルトだと開始位置が0度で円が右端から始まる
                    .rotationEffect(.degrees(-90))
                //プログレスバーの中に表示するテキスト
                VStack{
                    //今日の歩数
                    Text("現在   \(HealthDM.steps)")
                    //区切り線で割合を表現
                    Divider()
                        .frame(width: 170,height:4)
                        .background(Color.keyColor)
                    //目標歩数
                    Text("目標   \(targetNumOfSteps)")
                    
                }//VStack
                .font(.title)
            }//ZStack
            //プログレスバーの幅と高さを指定
            .frame(width:300,height:300)
        }//VStack(spacing:30)
        .onAppear(){
            //HealthKitが自分の現在のデバイスで利用可能かを確認する
            //HKHealthStore.isHealthDataAvailable() → HealthKitが利用できるかのメソッド
            if HKHealthStore.isHealthDataAvailable(){
                //アプリからデバイスにデータへのアクセス権限をリクエスト
                //toShareが書き込み、readが読み込み
                HealthDM.healthStore.requestAuthorization(toShare:[],read:[HealthDM.readTypes]){success, error in
                    if success{
                        //リクエストが承認されたので一日ごとの合計歩数を取得するメソッドを呼び出す
                        HealthDM.getDailyStepCount()
                    }
                }//requestAuthorization
            }
        }//onAppear
    }//body
    //達成率を計算するメソッド
    func achievementRate() -> String{
        //Formatterを使用して達成率を百分率で表示する
        let formatter = NumberFormatter()
        //数字を百分率にしたStringを得る　％表示
        formatter.numberStyle = .percent
        //歩いた歩数を目標歩数で割って達成率を取得　計算結果をリターン
        return formatter.string(from:NSNumber(value: Double(HealthDM.steps) / Double(targetNumOfSteps)))!
    }//achievementRate()
}//HomeViewBody
