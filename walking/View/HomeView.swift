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
    //一日の始まりは歩数データがないので初期値を0で宣言
    @State var steps: Int = 0
    
    var body: some View {
        
        NavigationView{
            //目標までの歩数、現在の歩数、目標歩数までの割合、移動距離を縦並びでレイアウトする
            VStack(spacing:30){
                Text("目標歩数は\(targetNumOfSteps)歩")
                Text("今日の歩数は\(steps)歩")
                //ZStackで２つのCircleを重ねて円形のプログレスバー・進捗表示を実装する
                ZStack(){
                    //背景用のCircle
                    Circle()
                    //strokeは円をくり抜いて輪を作るメソッド
                    //線の色と線の幅を指定　lineWidthは線の幅を指定 デフォルトは1
                        .stroke(Color.keyColor,style:StrokeStyle(lineWidth:20))
                    //円の透明度
                        .opacity(0.2)
                    //進捗用のCircle
                    //進捗Circleは歩数が格納されている状態変数stepsの値を使って長さを変える
                    Circle()
                    //trim()を使うことで指定した範囲でトリミングをすることができる
                    //from:トリミング開始位置 to:トリミング終了位置　0.0 〜 1.0の間で指定
                    //引数toの数値を変更ことで進捗率を変更することが出来る
                    //今回は引数toに今日歩いた歩数を目標歩数で割った達成率を設定することで、その達成率に応じて進捗を示すCircleの表示を行う
                    //Int型で割り算すると結果はInt型になり小数点以下は切り捨てられてしまうのでstepsとtargetNumOfStepsをDouble型に変換して計算を行う
                        .trim(from:0.0,to:CGFloat(min(Double(steps) / Double(targetNumOfSteps),1.0)))
                    //線の色と線の幅と線の先端のスタイルを指定 .roundで先端を丸めることが出来る
                        .stroke(Color.keyColor,style:StrokeStyle(lineWidth:20,lineCap:.round))
                    //アニメーションの設定
                    //1秒かけて進捗を示すCircleを表示する
                        .animation(.linear(duration:1.5))
                    //-90度を指定して円の始まりを一番上に持ってくるための処理。デフォルトだと開始位置が0度で円が右端から始まる
                        .rotationEffect(.degrees(-90))
                    VStack{
                        //達成率を計算するメソッドを呼び出して達成率を表示
                        Text("今日の達成率は\(achievementRate())")
                        //今日歩いた歩数が目標歩数を上回った時と上回っていない時の処理
                        //達成率が100％未満の場合
                        if steps < targetNumOfSteps{
                            Text("目標歩数まで\(targetNumOfSteps - steps)歩！")
                        }
                        //達成率が100%以上の場合
                        else{
                            Text("目標達成！🎉")
                        }
                    }//VStack
                }//ZStack
                //プログレスバーの幅と高さを指定
                .frame(width:300,height:300)
            }//VStack
            .font(.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                //ナビゲーションバーの左端に配置
                ToolbarItem(placement:.navigationBarLeading){
                    
                    Button{
                        print("今日")
                    }label:{
                        Text("今日")
                    }
                }
                //ナビゲーションバーの中央に配置
                ToolbarItem(placement:.principal){
                    Button{
                        print("DatePicker")
                    }label:{
                        //日付を選択するDatePickerを作成
                        //selectionには、選択した日付を保持する状態変数selectionDateの値に$を付与して参照渡しが出来るようにする
                        //displayedComponents:[.date]で日付のみを選択・表示する
                        DatePicker("",selection:$selectionDate,displayedComponents:.date)
                        //ja_JP（日本語＋日本地域）
                            .environment(\.locale,Locale(identifier:"ja_JP"))
                    }
                }
            }//.toolbar
        }//NavigationView
        //スワイプ機能
        //minimumDistance: 100でスワイプした距離が100に満たない場合はスワイプを検知しない
        .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
            //minimumDistanceが正常に機能しているのかを確認する
            //スワイプした距離が100を超えた場合にprint文を出力
            let moveWidth = value.translation.width
            let moveHeight = value.translation.height
            print("横移動量：\(moveWidth)")
            print("縦移動量：\(moveHeight)")
            //.heightでY方向にスワイプしたときの距離が-50~50の間に制限することで、どちらかの条件に合わない時は何もしない
            //縦方向、斜め方向のスワイプを無視する条件式
            if -50 < value.translation.height && value.translation.height < 50 {
                //左方向にスワイプした時
                if value.translation.width < -100  {
                    print("左方向のスワイプ")
                }
                //右方向にスワイプした時
                else if value.translation.width > 100{
                    print("右方向のスワイプ")
                }
            }
        })
        )//.gesture
        .onAppear{
            //HealthKitが自分の現在のデバイスで利用可能かを確認する
            //HKHealthStore.isHealthDataAvailable() → HealthKitが利用できるかのメソッド
            if HKHealthStore.isHealthDataAvailable(){
                print("readTypesのデータ型は\(type(of:readTypes))")
                print("HealthKitは使えます")
                // アプリからデバイスにデータへのアクセス権限をリクエスト
                //toShareが書き込み、readが読み込み
                healthStore.requestAuthorization(toShare:[],read: [readTypes]){success, error in
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
    
    //7日前の00:00:00から今日までの各日の合計歩数を取得するメソッド
    func getDailyStepCount(){
        let calendar = Calendar.current
        //統計の開始日とサンプルの分類方法を表す　アンカーが必要なので深夜0時を指定
        let anchorDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        // 今日の日付を取得
        let endDate = Date()
        //取得するデータの開始日を指定
        let startDate = Calendar.current.date(byAdding:.day,value:-7,to:endDate)
        //取得するデータの開始(23日)と終わり(今日)を入れる
        let predicate = HKQuery.predicateForSamples(withStart:startDate,end:endDate,options:.strictStartDate)
        //クエリを作る
        //HKObject(HealthKitで扱えるデータオブジェクト)をHelthStoreから問い合わせるためのクエリの１つ
        //HealthKitとのデータのやり取りはこのHKObjectを介して行う
        //HKStatisticsQueryはHKQuantitySampleの統計値(合計値・平均値・最大値・最小値)を計算するクエリ
        //一週間分の統計値を計算するならHKStatisticsQueryでも問題ないが、一年分となるとHKStatisticsQueryを365個生成しなければいけなくなる
        //解決方法としては、HKStatisticsQueryのコレクションであるHKStatisticsCollectionQuery使用する
        //これは指定した期間の統計値を問い合わせるクエリ　グラフやチャートのデータを生成することが出来る
        //またHKStatisticsCollectionQueryではstatisticsUpdateHandlerを用いることで歩数の変更を監視することもできるので便利
        let query = HKStatisticsCollectionQuery(quantityType:readTypes,
                                                quantitySamplePredicate:predicate,
                                                //第3引数にHKStatisticsOptionsを指定することによって、何を基準に取得するかを指定でき
                                                //今回はCumulativeSum（合計値）を引数として渡して、一日ごとの歩数の取得をする
                                                options:.cumulativeSum,
                                                //anchorDate:とintervalComponents:を組み合わせる事によって、特定の日付から決められた間隔の集計をすることができる
                                                anchorDate:anchorDate!,
                                                //取得するデータの間隔を指定
                                                //１日(毎日)ずつの間隔でデータを取得する
                                                intervalComponents:DateComponents(day:1))
        //クエリの実行結果の処理
        //クロージャには取得の成否が返される
        query.initialResultsHandler = {query, statisticsCollection, error in
            
            //statisticsCollectionがnilの場合はリターンされて処理を終了する
            guard let statisticsCollection = statisticsCollection else{
                print("エラーです")
                return
            }
            //statisticsCollectionがnilではない場合は下の処理に入る
            statisticsCollection.enumerateStatistics(from:startDate!,
                                                     to:endDate,
                                                     with:{(statistics,stop) in
                //HKQuantity型をInt型に変換
                //返されるstatistics.sumQuantity()はOptional<HKQuantity>型なのでアンラップして値(一日の歩数データの合計)を取り出す
                //statistics.sumQuantity()をアンラップしてその日の歩数データがあればself.stepsに代入する
                if let sum = statistics.sumQuantity(){
                    self.steps = Int(sum.doubleValue(for: HKUnit.count()) )
                    print("statistics.sumQuantity()のデータ型は\(type(of:statistics.sumQuantity()))")
                    print("データがある場合はsetpsには\(steps)が入る")
                    //返された各日(一日)の歩数の合計を出力
                    print(statistics.sumQuantity()!)
                }
                //statistics.sumQuantity()をアンラップしてその日の歩数データがない場合の処理
                else{
                    self.steps = 0
                    print("データがない場合はsetpsには\(steps)")
                    print("statistics.sumQuantity()がnil")
                }
            })
        }
        //クエリの開始
        //提供されたクエリの実行を開始します。
        self.healthStore.execute(query)
        print("queryの実行を開始")
        print("query = \(query)")
    }//getDailyStepCount()
    
    //達成率を計算するメソッド
    func achievementRate() -> String{
        //Formatterを使用して達成率を百分率で表示する
        let formatter = NumberFormatter()
        //数字を百分率にしたStringを得る　％表示
        formatter.numberStyle = .percent
        print("--------ここからがachievementRateメソッドの中身---------")
        print("formatterのデータ型は\(type(of: formatter))")
        print(type(of:  formatter.string(from:NSNumber(value: Double(steps) / Double(targetNumOfSteps)))))
        print(steps)
        print(targetNumOfSteps)
        print("--------ここまでがachievementRateメソッドの中身---------")
        //歩いた歩数を目標歩数で割って達成率を取得　計算結果をリターン
        return formatter.string(from:NSNumber(value: Double(steps) / Double(targetNumOfSteps)))!
    }
}//HomeView

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
