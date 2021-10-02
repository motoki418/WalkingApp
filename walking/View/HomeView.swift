//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit

struct HomeView: View {
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
    
    //歩数を格納する状態変数
    @State var steps: Int = 0
    
    var body: some View {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        return NavigationView{
            //目標までの歩数、現在の歩数、目標歩数までの割合、移動距離を縦並びでレイアウトする
            VStack(spacing:30){
                Text("目標歩数は\(targetNumOfSteps)歩")
                Text("今日の歩数は\(steps)歩")
                ZStack{
                    //背景用のCircle
                    //Circleの上にCircleを重ねて進捗を円で表示するプログレスバーを作成する
                    Circle()
                    //strokeは円をくり抜いて輪を作るメソッド
                    //線の色と線の幅を指定　lineWidthは線の幅を指定 デフォルトは1
                        .stroke(Color.keyColor, style: StrokeStyle(lineWidth:20))
                    //円の透明度
                        .opacity(0.2)
                    //進捗用のCircle
                    //進捗Circleは歩数が格納されている状態変数stepsの値を使って長さを変える
                    Circle()
                    //trim()を使うことで指定した範囲でトリミングをすることができる
                    //from:トリミング開始位置 to:トリミング終了位置　0.0 〜 1.0の間で指定
                    //引数toを歩数が格納されている状態変数stepsの値を指定することで、歩いた歩数の進捗を表示するプログレスバーが使えるはず。
                        .trim(from: 0.0, to: CGFloat(min(Double(steps), 1.0)))
                    //線の色と線の幅と線の先端のスタイルを指定 .roundで先端を丸めることが出来る
                        .stroke(Color.keyColor, style: StrokeStyle(lineWidth:20, lineCap: .round))
                    //デフォルトだと開始位置が0度で真右になっているので、-90度を指定して開始位置を上に設定
                        .rotationEffect(.degrees(-90))
                    VStack{
                        Text("現在の達成率は\(formatter.string(from:NSNumber(value:(Double(steps) / Double(targetNumOfSteps))))!)")
                        //今日歩いた歩数が目標歩数を上回ったときと上回っていない時の処理
                        if steps < targetNumOfSteps{
                            Text("目標歩数まで\(targetNumOfSteps - steps)歩！")
                        }else{
                            Text("目標達成！")
                        }
                    }//VStack
                }//ZStack
                //プログレスバーの幅と高さを指定
                .frame(width: 300, height: 300)
            }
            .font(.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        print("今日")
                    }label:{
                        Text("今日")
                    }
                }
                ToolbarItem(placement: .principal){
                    Button{
                        print("DatePicker")
                    }label:{
                        //日付を選択するDatePickerを作成
                        //selectionには、選択した日付を保持する状態変数selectionDateの値に$を付与して参照渡しが出来るようにする
                        //displayedComponents:[.date]で日付のみを選択・表示する
                        DatePicker("", selection: $selectionDate,displayedComponents:.date)
                        //ja_JP（日本語＋日本地域）
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                }
            })//.toolbar
        }//NavigationView
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
        //統計の開始日とサンプルの分類方法を表す　アンカーが必要なので月曜日の深夜12時を指定
        let anchorDate = Date.mondayAt12AM()
        // 今日の日付を取得
        let endDate = Date()
        //取得するデータの開始日を指定
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate)
        //取得するデータの開始(23日)と終わり(今日)を入れる
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
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
                                                //取得するデータの間隔を指定
                                                //１日(毎日)ずつの間隔でデータを取得する
                                                intervalComponents: DateComponents(day:1))
        // クエリの実行結果のコールバックハンドラー
        //クロージャには取得の成否がコールバックされる
        query.initialResultsHandler = { query, statisticsCollection, error in
            statisticsCollection?.enumerateStatistics(
                from: startDate!,
                to: endDate
            ){ statistics, stop in
                //返された各日の歩数の合計を出力
                print( statistics.sumQuantity() ?? "nil")
                //HKQuantity型をInt型に変換
                self.steps = Int((statistics.sumQuantity() as AnyObject).doubleValue(for: HKUnit.count()))
            }
        }
        //クエリの開始
        //提供されたクエリの実行を開始します。
        self.healthStore.execute(query)
        print("query = \(query)")
    }//getDailyStepCount()
}//HomeView

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
