//
//  HealthViewModel.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/29.
//

import SwiftUI
import HealthKit

class HomeViewModel: ObservableObject{
    init() {
        //iOS15ではラージタイトルだけでなくすべてのナビゲーションバー・タブバーにscrollEdgeAppearanceが適用されるようになったので、
        //iOS15未満と同じ挙動にするにはscrollEdgeAppearanceを指定する必要があるよう。
        //iOS15ではUITabBarが透明になってしまうことがあるので、iOS15未満と同じ挙動にするにはiOS15+のscrollEdgeAppearanceを指定する。
        //タブバーの外観がおかしい時はナビゲーションバーと同様の対応をする。
        if #available(iOS 15.0,*) {
            let appearance = UITabBarAppearance()
            appearance.shadowColor = UIColor(Color.keyColor)
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    //HealthKitで管理される保存領域をHealthStoreという
    //HKHealthStoreのインスタンス生成
    //ヘルスケアのデバイスデータとのやりとりはほぼ全てHKHealthStore経由で行う
    let healthStore = HKHealthStore()
    
    //アクセス許可が欲しいデータタイプを指定　歩数
    //扱うデータが歩数なのでデータの種類は「HKQuantityType」
    //HKQuantityTypeを生成するには何のデータを表すかのIDが必要、以下のように生成 100種類以上のデータが扱えるので、引数にはその種類を表すIDを与える
    //quantityTypeメソッドの引数にIDを指定　stepCountは歩数のID
    let readTypes = HKObjectType.quantityType(forIdentifier: .stepCount)!
    
    //日時計算クラスCalenderのインスタンスを生成
    let calendar: Calendar = Calendar(identifier: .gregorian)
    
    //HealthDataModelのインスタンス変数HealthDMに @Publishedを付与してHomeViewに状態の変更を通知できるようにする
    //インスタンス生成の際にHealthDataModelで定義した変数の初期値を設定する
    @Published var HealthDM: HealthDataModel = HealthDataModel(date: Date(), steps: 0)
    
    //選択した日付を保持する状態変数
    @Published var selectionDate: Date = Date() {
        //selectionDateの値変更前
        willSet{
            print("willset\(selectionDate)")
        }
        //selectionDateの値変更後
        didSet {
            getDailyStepCount()
            print("didset\(selectionDate)")
        }
    }
    
    //00:00:00~23:59:59までを一日分として各日の合計歩数を取得するメソッド
    func getDailyStepCount(){
        //統計の開始時間と終了時間をして　00:00:00~23:459:59までを一日分として歩数データを取得する
        let startDate  = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: selectionDate)
        let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectionDate)
        //HealhStatsクラスを配列で保持するインスタンス変数
        //取得するデータの開始時間と終了時間を引数に指定
        let predicate = HKQuery.predicateForSamples(withStart:startDate,end:endDate,options:.strictStartDate)
        //クエリを作る
        //HKObject(HealthKitで扱えるデータオブジェクト)をHelthStoreから問い合わせるためのクエリの１つ
        //HealthKitとのデータのやり取りはこのHKObjectを介して行う
        //HKStatisticsQueryはHKQuantitySampleの統計値(合計値・平均値・最大値・最小値)を計算するクエリ
        //一週間分の統計値を計算するならHKStatisticsQueryでも問題ないが、一年分となるとHKStatisticsQueryを365個生成しなければいけなくなる
        //解決方法としては、HKStatisticsQueryのコレクションであるHKStatisticsCollectionQuery使用する
        //これは指定した期間の統計値を問い合わせるクエリ　グラフやチャートのデータを生成することが出来る
        //またHKStatisticsCollectionQueryではstatisticsUpdateHandlerを用いることで歩数の変更を監視することもできるので便利
        //またオブザーバークエリと同様に統計収集クエリは実行時間の長いクエリとして機能し、HealthKitストアのコンテンツが変更されたときに更新を受け取ります。
        let query = HKStatisticsCollectionQuery(quantityType:readTypes,
                                                quantitySamplePredicate:predicate,
                                                //第3引数にHKStatisticsOptionsを指定することによって、何を基準に取得するかを指定でき
                                                //今回はCumulativeSum（合計値）を引数として渡して、一日ごとの歩数の取得をする
                                                options:.cumulativeSum,
                                                //anchorDate:とintervalComponents:を組み合わせる事によって、特定の日付から決められた間隔の集計をすることができる
                                                anchorDate:startDate!,
                                                //取得するデータの間隔を指定
                                                //１日(毎日)ずつの間隔でデータを取得する
                                                intervalComponents:DateComponents(day:1))
        //クエリの実行結果の処理
        //クロージャには取得の成否が返される
        query.initialResultsHandler = { [self]query, results, error in
            //results(HKStatisticsCollection?)からクエリ結果を取り出してnilの場合はリターンされて処理を終了する
            guard let statisticsCollection = results else{
                return
            }
            DispatchQueue.main.async {
                //statisticsCollectionがnilではない場合は下の処理に入る
                //クエリ結果から期間（開始日・終了日）を指定して歩数の統計情報をstatisticsに取り出す。
                statisticsCollection.enumerateStatistics(from:startDate!,
                                                         to:self.selectionDate,
                                                         with:{(statistics,stop) in
                    //statisticsに最小単位（今回は１日分の歩数）のサンプルデータが返ってくる。
                    //statistics.sumQuantity()でサンプルデータの合計（１日の合計歩数）を取得する。
                    //HKQuantity型をInt型に変換
                    //返されるstatistics.sumQuantity()はOptional<HKQuantity>型なのでアンラップして値(一日の歩数データの合計)を取り出す
                    //statistics.sumQuantity()をアンラップしてその日の歩数データがあればself.stepsに代入する
                    if let sum = statistics.sumQuantity(){
                        //サンプルデータはquantity.doubleValueで取り出し、単位を指定して取得する。
                        //単位：歩数の場合HKUnit.count()と指定する。歩行距離の場合：HKUnit(from: "m/s")といった単位を指定する。
                        self.HealthDM.steps = Int(sum.doubleValue(for: HKUnit.count()))
                        //dateには統計の開始時間15:00:00 +0000が渡されて、stepsには今日の歩数を合計した値を引数として渡して、
                        //@Publishedを付与した変数HealthDMに代入してHomeViewに状態の変更を配信できるようにする。
                        self.HealthDM = HealthDataModel(date:statistics.startDate,steps:HealthDM.steps)
                        print("歩数取得後のHealthDataModelのstepsの値は\(HealthDM.steps)歩")
                        print("歩数取得後のHealthDataModelのdateの日付は統計の開始時間である\(HealthDM.date)")
                    }
                    //statistics.sumQuantity()をアンラップしてその日の歩数データがない場合の処理
                    else{
                        self.HealthDM.steps = 0
                        print("HealthDataVM.stepsはnil")
                    }
                })
            }
        }//DispatchQueue.main.async
        //statisticsUpdateHandlerはバックグラウンドでHealthStoreの監視をして歩数の変更を監視することに変更があれば取得を行うクエリ
        query.statisticsUpdateHandler = {query,results,statisticsCollection, error in
            //statisticsCollectionがnilではない場合は下の処理に入る
            //クエリ結果から期間（開始日・終了日）を指定して歩数の統計情報をstatisticsに取り出す。
            statisticsCollection?.enumerateStatistics(from:startDate!,
                                                      to:self.selectionDate,
                                                      with:{(statistics,stop) in
                //statisticsに最小単位（今回は１日分の歩数）のサンプルデータが返ってくる。
                //statistics.sumQuantity()でサンプルデータの合計（１日の合計歩数）を取得する。
                //HKQuantity型をInt型に変換
                //返されるstatistics.sumQuantity()はOptional<HKQuantity>型なのでアンラップして値(一日の歩数データの合計)を取り出す
                //statistics.sumQuantity()をアンラップしてその日の歩数データがあればself.HealthDataVM.stepsに代入する
                if let sum = statistics.sumQuantity(){
                    //サンプルデータはquantity.doubleValueで取り出し、単位を指定して取得する。
                    //単位：歩数の場合HKUnit.count()と指定する。歩行距離の場合：HKUnit(from: "m/s")といった単位を指定する。
                    self.HealthDM.steps = Int(sum.doubleValue(for: HKUnit.count()))
                    //歩数の取得を開始した日付と歩数をHealthDataModel構造体の変数の値として渡して、
                    //@Publishedを付与した変数HealthDMに代入してHomeViewに状態の変更を配信できるようにする。
                    //dateには統計の開始時間15:00:00 +0000が渡されて、stepsには今日の歩数を合計した値が渡される
                    self.HealthDM = HealthDataModel(date:statistics.startDate,steps:self.HealthDM.steps)
                }
                //statistics.sumQuantity()をアンラップしてその日の歩数データがない場合の処理
                else{
                    self.HealthDM.steps = 0
                    print("HealthDataVM.stepsはnil")
                }
            })
        }
        //クエリの開始
        //提供されたクエリの実行を開始します。
        healthStore.execute(query)
    }//getDailyStepCount()
}
