//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    //HomeViewModelを参照する状態変数
    //これでViewがViewModelのデータを監視できるようになる
    @ObservedObject var HomeVM: HomeViewModel = HomeViewModel()
    
    //歩数をUserDefalutsから読み込んで保持するための状態変数（初期値は2000）
    @AppStorage("steps_Value") private var targetNumOfSteps: Int = 2000
    
    var body: some View {
        NavigationView{
            //目標までの歩数、現在の歩数、目標歩数までの割合、移動距離を縦並びでレイアウトする
            VStack(spacing:30){
                //PickerViewで設定した目標歩数がHomeViewModelの
                //@AppStorage("steps_Value") var targetNumOfsteps: Int = 2000 に格納されているので表示する
                Text("目標歩数は\(targetNumOfSteps)歩")
                Text("今日の歩数は\(HomeVM.HealthDM.steps)歩")
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
                    //進捗Circleは歩数が格納されている状態変数HomeVM.stepsの値を使って長さを変える
                    Circle()
                    //trim()を使うことで指定した範囲でトリミングをすることができる
                    //from:トリミング開始位置 to:トリミング終了位置　0.0 〜 1.0の間で指定
                    //引数toの数値を変更ことで進捗率を変更することが出来る
                    //今回は引数toに今日歩いた歩数を目標歩数で割った達成率を設定することで、その達成率に応じて進捗を示すCircleの表示を行う
                    //Int型で割り算すると結果はInt型になり小数点以下は切り捨てられてしまうのでHomeVM.HealthDM.stepsと
                    //targetNumOfstepsをDouble型に変換して計算を行う
                        .trim(from:0.0,to:CGFloat(min(Double(HomeVM.HealthDM.steps) / Double(targetNumOfSteps),1.0)))
                    //線の色と線の幅と線の先端のスタイルを指定 .roundで先端を丸めることが出来る
                        .stroke(Color.keyColor,style:StrokeStyle(lineWidth:20,lineCap:.round))
                    //アニメーションの設定
                    //1.3秒かけて進捗を示すCircleを表示する
                        .animation(.linear(duration:1.3))
                    //-90度を指定して円の始まりを一番上に持ってくるための処理。デフォルトだと開始位置が0度で円が右端から始まる
                        .rotationEffect(.degrees(-90))
                    VStack{
                        //達成率を計算するメソッドを呼び出して達成率を表示
                        Text("今日の達成率は\(achievementRate())")
                        //今日歩いた歩数が目標歩数を上回った時と上回っていない時の処理
                        //達成率が100％未満の場合
                        if HomeVM.HealthDM.steps < targetNumOfSteps{
                            Text("目標歩数まで\(targetNumOfSteps - HomeVM.HealthDM.steps)歩！")
                        }
                        //達成率が100%以上の場合
                        else{
                            Text("目標達成！🎉")
                        }
                    }//VStack
                }//ZStack
                //プログレスバーの幅と高さを指定
                .frame(width:300,height:300)
            }//VStack(spacing:30)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                //ナビゲーションバーの左端に配置
                ToolbarItem(placement:.navigationBarLeading){
                    Button{
                        //今日の日付を取得
                        HomeVM.selectionDate = Date()
                    }label:{
                        Text("今日")
                    }
                }//今日ボタン
                //ナビゲーションバーの中央に配置
                ToolbarItem(placement:.principal){
                    //日付を選択するDatePickerを作成
                    //selectionには、選択した日付を保持する状態変数HomeVM.selectionDateの値に$を付与して参照渡しが出来るようにする
                    //displayedComponents:[.date]で日付のみを選択・表示する
                    DatePicker("",selection:$HomeVM.selectionDate,displayedComponents:.date)
                    //プロパティの変更を検知する.onChangeを使用してHomeVM.selectionDateに格納されている日付が変更されたら、 HomeVM.getDailyStepCount()を呼び出して日付に合った歩数を表示する
                        .onChange(of:HomeVM.selectionDate,perform: { _ in
                            HomeVM.getDailyStepCount()
                        })
                        .labelsHidden()
                    //ja_JP（日本語＋日本地域）
                        .environment(\.locale,Locale(identifier:"ja_JP"))
                }//DatePicker
                //ナビゲーションバーの右端に配置 リロードボタン
                ToolbarItem{
                    Button{
                    }label:{
                        Image(systemName: "arrow.clockwise")
                    }
                }//リロードボタン
            }//.toolbar
        }//NavigationView
        .font(.title2)
        //スワイプ機能
        //minimumDistance: 100でスワイプした移動量が100に満たない場合はスワイプを検知しない
        .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
            //minimumDistanceが正常に機能しているのかを確認する
            //スワイプした距離が100を超えた場合にprint文を出力
            let moveWidth = value.translation.width
            let moveHeight = value.translation.height
            print("横移動量：\(moveWidth)")
            print("縦移動量：\(moveHeight)")
            //縦方向、斜め方向のスワイプを無視する条件式
            //どちらかの条件が当てはまった時は何もしない　上方向の移動量が-50以上　もしくは下方向の移動量が50以上の場合は何もしない
            //何もしない = 途中でreturnするという意味
            //.heightで縦方向(Y方向)にスワイプしたときの移動量が-50~50の間
            //どちらかの条件に当てはまらなかった場合は左右にスワイプした時の条件式に進む
            if value.translation.height < -160 || 160 < value.translation.height{
                return
            }
            //左方向にスワイプした時に表示している日付に一日分を足して翌日の日付を表示するための条件式
            //左方向の移動量が-100以上の時にprintで出力
            if value.translation.width < -100{
                //HomeVM.calendar型の日時計算関数を利用して翌日を表示
                HomeVM.selectionDate = HomeVM.calendar.date(byAdding: DateComponents(day:1),to:HomeVM.selectionDate)!
            }
            //右方向にスワイプした時に表示している日付から一日分を引いて前日の日付を表示するための条件式
            //右方向の移動量が100以上の時にprintで出力
            else if value.translation.width > 100{
                //HomeVM.calendar型の日時計算関数を利用して前日を表示
                HomeVM.selectionDate = HomeVM.calendar.date(byAdding:DateComponents(day:-1),to:HomeVM.selectionDate)!
            }
        })
        )//.gesture
        .onAppear{
            //HealthKitが自分の現在のデバイスで利用可能かを確認する
            //HKHealthStore.isHealthDataAvailable() → HealthKitが利用できるかのメソッド
            if HKHealthStore.isHealthDataAvailable(){
                //アプリからデバイスにデータへのアクセス権限をリクエスト
                //toShareが書き込み、readが読み込み
                print("承認されました")
                HomeVM.healthStore.requestAuthorization(toShare:[],read:[HomeVM.readTypes]){success, error in
                    if success{
                        //リクエストが承認されたので一日ごとの合計歩数を取得するメソッドを呼び出す
                        self.HomeVM.getDailyStepCount()
                    }
                }//requestAuthorization
            }//if HKHealthStore.isHealthDataAvailable()
        }//onAppear
    }//body
    //達成率を計算するメソッド
    func achievementRate() -> String{
        //Formatterを使用して達成率を百分率で表示する
        let formatter = NumberFormatter()
        //数字を百分率にしたStringを得る　％表示
        formatter.numberStyle = .percent
        //歩いた歩数を目標歩数で割って達成率を取得　計算結果をリターン
        return formatter.string(from:NSNumber(value:Double(HomeVM.HealthDM.steps) / Double(targetNumOfSteps)))!
    }
}//HomeView

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
