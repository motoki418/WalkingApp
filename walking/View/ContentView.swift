//
//  ContentView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/19.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    //インスタンス生成
    var healthStore = HKHealthStore()
    //アクセス許可が欲しいデータタイプを指定
    //読み込むデータ 歩数
    let readTypes = (HKObjectType.quantityType(forIdentifier: .stepCount)!)
    
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
        .onAppear{
            //HealthKitが自分の現在のデバイスで利用可能かを確認する
            //HKHealthStore.isHealthDataAvailable() → HealthKitが利用できるかのメソッド
            if HKHealthStore.isHealthDataAvailable(){
                print("HealthKitは使えます")
                // アプリからデバイスにデータへのアクセス権限をリクエスト
                //toShareが書き込み、readが読み込み
                healthStore.requestAuthorization(toShare: [], read: [readTypes]) { success, error in
                    if success{
                        print("ユーザーからリクエストが承認されました")
                        //リクエストが承認されたので一日ごとの合計歩数を取得するメソッドを呼び出す
                        getDailyStepCount()
                    }else{
                        print("ユーザーからリクエストが否認されました")
                    }
                }//requestAuthorization
            }//if HKHealthStore.isHealthDataAvailable()
        }//onAppear
    }//body
    
    // 19日の00:00:00から26日の00:00:00までの一日ごとの合計歩数を取得するメソッド
    func getDailyStepCount(){
        let calender = Calendar.current
        //取得するデータの開始日を指定
        let startDate = DateComponents(year: 2021, month: 9, day: 19)
        //取得するデータの終了日を指定
        let endDate = DateComponents(year:2021, month: 9,day: 26)
        // 取得するデータの開始(19日)と終わり(26日)を入れる
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(from: startDate), end: Calendar.current.date(from: endDate))
        // クエリを作る
        //HKStatisticsCollectionQueryは1日毎の集計を行いたい場合などに使用すると良い
        //統計データを取得するために使用するHKStatisticsQueryの集計する日数が多い時に使うバージョン
        //一週間だけとかならHKStatisticsQueryでも問題ないが、一年分となるとHKStatisticsQueryを365個生成しなければいけなくなるのでこちらを使用する
        let query = HKStatisticsCollectionQuery(quantityType: readTypes,
                                                quantitySamplePredicate: predicate,
                                                //options: .cumulativeSumは合計値を基にデータを取得する
                                                options: .cumulativeSum,
                                                //anchorDate:とintervalComponents:を組み合わせる事によって、特定の日付から決められた間隔の集計をすることができる
                                                anchorDate: calender.date(from: startDate)!,
                                                //１日(毎日)ずつの間隔でデータを取得する
                                                intervalComponents: DateComponents(day:1))
        // クエリの実行結果のコールバックハンドラー
        query.initialResultsHandler = { query, HKStatisticsCollection, error in
            HKStatisticsCollection?.enumerateStatistics(from: calender.date(from: startDate)!,
                                                        to: calender.date(from: endDate)!
            ){
                statistics, stop in
                print(statistics.sumQuantity() ?? "nil")
            }
        }
        //クエリの開始
        //提供されたクエリの実行を開始します。
        healthStore.execute(query)
    }//getDailyStepCount()
    
//        //一週間の合計歩数を取得するメソッド
//        //19日の00:00:00から26日の00:00:00までの合計なので19~25の合計歩数
//        func getWeekStepCount(){
//            let type = HKObjectType.quantityType(forIdentifier: .stepCount)!
//
//            let startDate = DateComponents(year: 2021, month: 9, day: 20)
//            let endDate = DateComponents(year:2021, month: 9,day: 26)
//            let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(from: startDate)!, end: Calendar.current.date(from: endDate)!)
//
//            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]){ query, statistics, error in
//                print(statistics!.sumQuantity()!)
//            }
//            healthStore.execute(query)
//        }//getWeekStepCount()
}//ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
