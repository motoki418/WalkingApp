//
//  HealthStore.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/22.
//


import Foundation
import HealthKit

class HealthStore{
    
    var healthStore: HKHealthStore?
    
    //HKStatisticsCollectionQueryはHKStatisticsQueryのコレクションで指定した期間の統計値を問い合わせるクエリ
    //
    var query: HKStatisticsCollectionQuery?
    
    init() {
        //HealthKit が自分の現在のデバイスで利用可能かを確認する
        //HKHealthStore.isHealthDataAvailable()→HealthKitが利用できるかのメソッド
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
            print("HealthKitは使えます")
        }
    }
    //日毎の歩数を取得するメソッド
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void){
        // アクセス許可が欲しいデータタイプを指定　今回は歩数
        let stepType = (HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
        let date = Date()  // 今日の日付を取得
        //取得するデータの開始を指定
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        //
        let anchorDate = Date.mondayAt12AM()
        //取得するデータの間隔を指定　一日ずつ取得する
        let daily = DateComponents(day: 1)
        //// 取得するデータの開始(きのう)と終わり(きょう)を入れる
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        // クエリを作る  歩数を取得
        query = HKStatisticsCollectionQuery(quantityType: stepType,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        // クエリの実行結果のコールバックハンドラー
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        if let healthStore = healthStore,let query = self.query{
            healthStore.execute(query)
        }
    }
    
    //データの読み取りの権限をリクエストするメソッド
    func requestAuthorization(completion: @escaping (Bool) -> Void){
        // アクセス許可が欲しいデータタイプを指定　今回は歩数
        //ここで許可をもらうデータを設定する
        //歩行距離は量を表すデータであるため、量を表すデータを書き込めるようにquantityType(forIdentifier:)を使用してHKQuantityTypeを取得します。。
        let stepType = Set([HKQuantityType.quantityType(forIdentifier:
                                                            .stepCount)!,
                            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!])
        
        guard let healthStore = self.healthStore else {
            return completion(false)
        }
        //アプリからデバイスにデータへのアクセス権限をリクエスト
        healthStore.requestAuthorization(toShare: [], read: stepType){ (success, error)in
            completion(success)
            print(success)
        }
    }//requestAuthorization
}
