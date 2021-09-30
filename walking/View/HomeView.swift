//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit
import CoreData

struct HomeView: View {
    init() {
        //タブバーが透明になる、背景色が適用されない問題の解決方法
        //iOS15ではUITabBarが透明になってしまうことがあるので、iOS15未満と同じ挙動にするにはiOS15+のscrollEdgeAppearanceを指定する。
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor(Color.keyColor)
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    //HealthKitで管理される保存領域をHealthStoreという
    //インスタンス生成
    //ヘルスケアのデバイスデータとのやりとりはほぼ全てHKHealthStore経由で行う
    let healthStore = HKHealthStore()
    
    //アクセス許可が欲しいデータタイプを指定
    //読み込むデータ 歩数
    //扱うデータが歩数なのでデータの種類は「HKQuantityType」
    //HKQuantityTypeを生成するには何のデータを表すかのIDが必要、以下のように生成 100 種類以上のデータが扱えるので、引数にはその種類を表す ID を与え
    //quantityTypeメソッドの引数にIDを指定　stepCountは歩数のID
    let readTypes: HKQuantityType = (HKObjectType.quantityType(forIdentifier: .stepCount)!)
    
    //選択した日付を保持する状態変数
    @State private var selectionDate = Date()
    
    //歩数設定画面で選択された歩数をUserDefalutsから読み込んで保持するための状態変数（初期値は2000）
    @AppStorage("steps_Value") var targetNumOfSteps: Int = 2000
    
    //
    @State var steps: Int = 0
    
    var body: some View {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        //alignmentを.topに設定したZStack、NavigationViewとDatePickerを配置することで、最前面の上部であるナビゲーションバーの中央にDatePickerを表示する
        return ZStack(alignment: .top){
            NavigationView{
                //目標までの歩数、現在の歩数、目標歩数までの割合、移動距離を縦並びでレイアウトする
                VStack(spacing:30){
                    Text("目標歩数は\(targetNumOfSteps)歩")
                    Text("今日の歩数は\(steps)歩")
                    Text("目標歩数まで\(targetNumOfSteps - steps)歩！")
                    Text("現在の達成率は\(formatter.string(from:NSNumber(value:(Double(steps) / Double(targetNumOfSteps))))!)")
                    
                }
                .font(.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigation){
                        Button{
                            print("tap")
                        }label:{
                            DatePicker("今日", selection: $selectionDate,displayedComponents:.date)
                            //ja_JP（日本語＋日本地域）
                                .environment(\.locale, Locale(identifier: "ja_JP"))
                            //ラベルを非表示にする
                                .labelsHidden()
                        }
                    }
                })//.toolbar
            }//NavigationView
                //日付を選択するDatePickerを作成
                //selectionには、選択した日付を保持する状態変数selectionDateの値に$を付与して参照渡しが出来るようにする
                //displayedComponents:[.date]で日付のみを選択・表示する
               

        }//ZStack
        .onAppear{
            //HealthKitが自分の現在のデバイスで利用可能かを確認する
            //HKHealthStore.isHealthDataAvailable() → HealthKitが利用できるかのメソッド
            if HKHealthStore.isHealthDataAvailable(){
                print(type(of: readTypes))
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
    // 2021/9/19の00:00:00から2021/9/26日の00:00:00までの各日の合計歩数を取得するメソッド
    func getDailyStepCount(){
        //カレンダーを取得
        let calender = Calendar.current
        //取得するデータの開始日を指定
        let startDate = DateComponents(year: 2021, month: 9, day: 23, hour: 0, minute: 0, second: 0)
        //取得するデータの終了日を指定
        let endDate = DateComponents(year:2021, month: 9,day: 29, hour: 23, minute: 59, second: 59)
        let anchorDate = Date.mondayAt12AM()
        //取得するデータの開始(19日)と終わり(26日)を入れる
        let predicate = HKQuery.predicateForSamples(
            withStart: Calendar.current.date(from: startDate),
            end: Calendar.current.date(from: endDate)
        )
        //クエリを作る
        //HKObject(HealthKitで扱えるデータオブジェクト)をHelthStoreから問い合わせるためのクエリの１つ
        //HealthKitとのデータのやり取りはこのHKObjectを介して行う
        //HKStatisticsQueryはHKQuantitySampleの統計値(合計値・平均値・最大値・最小値)を計算するクエリ
        //一週間分の統計値を計算するならHKStatisticsQueryでも問題ないが、一年分となるとHKStatisticsQueryを365個生成しなければいけなくなる
        //解決方法としては、HKStatisticsQueryのコレクションであるHKStatisticsCollectionQuery使用する
        //これは指定した期間の統計値を問い合わせるクエリ　グラフやチャートのデータを生成することが出来る
        //またHKStatisticsCollectionQueryではstatisticsUpdateHandlerを用いることで歩数の変更を監視することもできるので便利
        let query = HKStatisticsCollectionQuery(quantityType: readTypes,
                                                quantitySamplePredicate: predicate,
                                                //第3引数にHKStatisticsOptionsを指定することによって、何を基準に取得するかを指定でき
                                                //今回はCumulativeSum（合計値）を引数として渡して、一日ごとの歩数の取得をする
                                                options: .cumulativeSum,
                                                //anchorDate:とintervalComponents:を組み合わせる事によって、特定の日付から決められた間隔の集計をすることができる
                                                anchorDate: anchorDate,
                                                //１日(毎日)ずつの間隔でデータを取得する
                                                intervalComponents: DateComponents(day:1))
        // クエリの実行結果のコールバックハンドラー
        //クロージャには取得の成否がコールバックされる
        query.initialResultsHandler = { query, statisticsCollection, error in
            statisticsCollection?.enumerateStatistics(
                from: calender.date(from: startDate)!,
                to: calender.date(from: endDate)!
            ){ statistics, stop in
                //返された各日の歩数の合計を出力
                print( statistics.sumQuantity() ?? "nil")
                //HKQuantity型をInt型に変換
                self.steps = Int(((statistics.sumQuantity() as AnyObject).doubleValue(for: HKUnit.count())))
            }
        }
        //クエリの開始
        //提供されたクエリの実行を開始します。
        self.healthStore.execute(query)
        print("query = \(query)")
    }//getDailyStepCount()
    
    //        //一週間の合計歩数を取得するメソッド
    //        //19日の00:00:00から26日の00:00:00までの合計なので19~25の合計歩数
    //       private func getWeekStepCount(){
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
 
}//HomeView

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
