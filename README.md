# シンプル歩数計 - SimpleWalking
## 概要

このアプリはヘルスケアに保存されている歩数、今日の進捗率、目標歩数を達成するために必要な歩数などが、シンプルなレイアウトで確認できる歩数計アプリです。

## 実行画面

https://user-images.githubusercontent.com/78193597/142744124-04670904-eacb-4c1c-8c5b-4aef9e873703.mov

##  アプリの機能
### ホーム画面
ホーム画面では、右にスワイプすると前日、左にスワイプすると翌日の日付に変更し、日付が変更されると画面に表示している円グラフの再描画が行われ、一日でどれだけ歩いたのかが分かりやすいようになっています。
画面上部のDatePickerで日付を選択すると、選択した日付の歩数の表示が行われるようにしています。

### 設定画面
設定画面ではNavigationViewで画面レイアウトを作成して、NavigationLinkで歩数設定画面に遷移できるようにしています。
歩数設定画面では、Pickerを使用して歩数を選択できるようにし、選択した歩数はUserDefalutsを利用してデータの永続化を行い、ホーム画面でも目標歩数として表示できるようにしています。
 
## ダウンロードリンク
[シンプル歩数計 - SimpleWalking](https://apps.apple.com/jp/app/simplewalking/id1590245946)

## アプリの設計について
今回はこのような設計図を作成し、MVVMで機能ごとにファイルを分割して作成しました。
<img width="975" alt="スクリーンショット 2021-11-21 12 12 52" src="https://user-images.githubusercontent.com/78193597/142796279-0b3b1542-ae47-40bb-b55d-1b09ea07c33a.png">

HomeViewがホーム画面、SettingViewが設定画面、PickerViewがPickerで歩数を設定する画面です。

HomeViewは、HomeViewHeaderとHomeViewBodyという二つの子ビューに分割して画面レイアウトを作成しています。

## プロジェクトでのポイント

- ホーム画面は、左右にスワイプした時に画面をページングさせて、スワイプした事が分かりやすいように作成しました。

事前に子ビューのHomeViewBodyを前日・当日・翌日の三画面分用意しておき、.onChangeで表示位置を指定する状態変数selectionの値の変化を監視し、値が変化すると条件に応じて、日付を格納している状態変数selectionDateに前日・翌日の日付を代入し、日付の変更をすると同時に歩数の取得を行う処理を実装しています。
スワイプした時にページングさせる機能についてはコードの下に用意してある資料を見ていただけると分かりやすいと思います。
``` 
 //選択した日付を保持する状態変数
    @State private var selectionDate: Date = Date()
 //この変数で表示位置を指定できる(中央はtag(1)なので1)
    @State private var selection = 1
 
 var body: some View {
  VStack{
            HomeViewHeader(selectionDate:$selectionDate)
            //TabViewのPageTabViewStyleで予め3画面分(前日・当日・翌日)を用意する
            TabView(selection: $selection){
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
            }
```
![image](https://user-images.githubusercontent.com/78193597/142799011-58fc9de0-625d-4a6b-91fa-e925d46e9bc0.png)
![image](https://user-images.githubusercontent.com/78193597/142799045-af9d5291-5196-4a56-b443-8bf1496c732f.png)

- HomeBodyViewModelでは歩数の取得を行うメソッドを作成し、ホーム画面で左右にスワイプした時、DatePickerで日付を選択した時、「今日」ボタンをタップした時に呼び出して歩数の取得を行なっています。
```
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
                    print("HealthDataVM.stepsはnil")
                }
            })
        }
          //クエリの開始
        healthStore.execute(query)
        }
```
## 開発環境
- xcode13.1
- macOS Monterey 12.0.1
- iPhone simulater 15.0
- iPhone実機15.1.1

# 作成者
https://twitter.com/motoki0418
