# シンプル歩数計 - SimpleWalking
## 1. 概要

このアプリはHealthKitに保存されている歩数情報を取得して、設定画面で目標歩数を設定し、今日の進捗率や達成するために必要な歩数がわかる歩数計アプリです。

だれでも使えるようなシンプルなレイアウトで作りました。

## 2. ダウンロードリンク
[シンプル歩数計 - SimpleWalking](https://apps.apple.com/jp/app/simplewalking/id1590245946)


## 3.実行画面
https://user-images.githubusercontent.com/78193597/142972810-c5fb4fe8-500a-4177-82e7-eb56ea199285.mp4

## 4.  アプリの機能
### ホーム画面
ホーム画面では、右にスワイプすると前日、左にスワイプすると翌日の日付に変更し、日付が変更されると画面に表示している円グラフの再描画が行われ、一日でどれだけ歩いたのかが分かりやすいようになっています。
画面上部のDatePickerで日付を選択すると、選択した日付の歩数の表示が行われるようにしています。

<img width="320" alt="Simulator Screen Shot - iPhone 13 Pro Max - 2021-11-28 at 12 31 30" src="https://user-images.githubusercontent.com/78193597/143727815-2bc881ce-9e52-4e66-b14e-cf972cd33c9c.png">

### 設定画面
設定画面ではNavigationViewで画面レイアウトを作成して、NavigationLinkで歩数設定画面に遷移できるようにしています。
歩数設定画面では、Pickerを使用して歩数を選択できるようにし、選択した歩数はUserDefalutsを利用してデータの永続化を行い、ホーム画面でも目標歩数として表示できるようにしています。

| 設定画面 | 歩数設定画面 |
| --- | --- |
| !<img width="320" alt="Simulator Screen Shot - iPhone 13 Pro Max - 2021-11-28 at 12 31 38" src="https://user-images.githubusercontent.com/78193597/143728023-fc00ca95-5d29-454a-969b-5bf5ceec17bc.png"> | <img width="320" alt="Simulator Screen Shot - iPhone 13 Pro Max - 2021-11-28 at 12 31 34" src="https://user-images.githubusercontent.com/78193597/143728019-e6ae1e83-1eb5-421f-a229-8c5167c5c841.png"> |

## 5. アプリの設計について
<img width="1278" alt="スクリーンショット 2022-06-22 10 44 45" src="https://user-images.githubusercontent.com/78193597/174925555-e967c332-d35e-4b7a-a004-fab9464f1ad5.png">

| ファイル名 | 解説・概要 |
| ------------- | ------------- |
| ContentView.swift | TabViewを使用して、HomeView・SettingViewの2画面を管理するView  |
| HomeView.swift  | HomeViewHeaderとHomeViewBodyという二つの子ビューをまとめて、ホーム画面のレイアウトを作成するView  |
| HomeViewHeader.swift  |ホーム画面で表示する「今日」ボタン・DatePickerの表示を担当するHomeViewの子View |
| HomeViewBody.swift  | ホーム画面で表示する歩数・円グラフ・達成率の表示を担当するHomeViewの子View|
| SettingView.swift  |  設定画面のレイアウトを作成するView |
| PickerView.swift  |  アプリ内で表示する目標歩数をPickerで設定するView |
| HealthDataModel.swift  | HealthStoreから歩数データを取得するし、Viewにデータを配信するクラス |

## 6. アプリを作った時にこだわったポイント

### ポイント1.左右のスワイプで日付の切り替えを分かりやすくしました。

ホーム画面は、左右にスワイプした時に画面をページングさせて、日付が前後したことが分かりやすいようにしました。

スワイプした時にページングさせる機能についてはコードの下に用意してある資料を見ていただけると分かりやすいと思います。


``` Swift
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
```
<img width="529" alt="スクリーンショット 2021-11-27 8 22 33" src="https://user-images.githubusercontent.com/78193597/143660823-f0d52cb4-b7ba-4e25-a64b-315ababeca5d.png">

[<img width="868" alt="スクリーンショット 2021-12-09 9 36 53" src="https://user-images.githubusercontent.com/78193597/145313673-c6f6f14e-aa63-4155-aa29-c71670865dc5.png">](https://speakerdeck.com/motoki418/sinhurubu-shu-ji-homuhua-mian-dong-kinituite)

### ポイント2.HealthKitから歩数データを取得して表示

HealthDataModelでは歩数の取得を行うメソッドを作成しています。
このメソッドは次のケースで実行されます。
- ホーム画面で左右にスワイプした時
- DatePickerで日付を選択した時
- 「今日」ボタンをタップした時

上記のケースで、メソッドを呼び出して歩数の取得を行います。
``` Swift
        //00:00:00~23:59:59までを一日分として各日の合計歩数を取得するメソッド
    func getDailyStepCount(){
        //スワイプした時に日付が変わったことをわかりやすくするために取得した歩数を0にしてプログレスバーを再レンダリングする
        DispatchQueue.main.async{
            self.steps = 0
        }
        //統計の開始時間と終了時間をして　00:00:00~23:459:59までを一日分として歩数データを取得する
        let startDate  = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: selectionDate)
        let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectionDate)
        //取得するデータの開始時間と終了時間を引数に指定
        let predicate = HKQuery.predicateForSamples(withStart:startDate,end:endDate,options:.strictStartDate)
        //クエリを作る
        let query = HKStatisticsCollectionQuery(quantityType:readTypes,
                                                quantitySamplePredicate:predicate,
                                                options:.cumulativeSum,
                                                anchorDate:startDate!,
                                                intervalComponents:DateComponents(day:1))
        //クエリの実行結果の処理
        query.initialResultsHandler = {query, results, error in
            //results(HKStatisticsCollection?)からクエリ結果を取り出してnilの場合はリターンされて処理を終了する
            guard let statisticsCollection = results else{
                return
            }
            statisticsCollection.enumerateStatistics(from:startDate!,
                                                     to:self.selectionDate,
                                                     with:{(statistics,stop) in
                //statistics.sumQuantity()をアンラップしてその日の歩数データがあればself.stepsに代入する
                if let sum = statistics.sumQuantity(){
                    //歩数を0にしてから1秒後に歩数の取得処理を行う
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.steps = Int(sum.doubleValue(for: HKUnit.count()))
                    }//DispatchQueue.main.async
                }
                //statistics.sumQuantity()をアンラップしてその日の歩数データがない場合の処理
                else{
                    //@Publishedの変数を更新するときはメインスレッドで更新する必要がある
                    DispatchQueue.main.async{
                        self.steps = 0
                    }//DispatchQueue.main.async
                }
            })
        }
          //クエリの開始
        healthStore.execute(query)
        }
```
<img width="445" alt="スクリーンショット 2021-11-27 8 47 52" src="https://user-images.githubusercontent.com/78193597/143661479-034a794b-30a0-4008-a431-7963ca674aba.png">

## 7. 開発環境
- Xcode14.0
- macOS Monterey 12.6
- iOS16.0

## 8. 作成者
https://twitter.com/motoki0418
