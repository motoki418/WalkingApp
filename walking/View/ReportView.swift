//
//  ReportView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit

struct ReportView: View {
    private var healthStore = HealthStore()
    
    @State private var steps: [Step] = []
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate){ (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
    }
    //Pickerで表示するテキストを配列で管理
    let date = ["週間","月間","年間"]
    //Pickerの値が変更できるように状態変数で宣言
    @State private var selection = 0
    
    var body: some View {
        ZStack(alignment: .top){
            NavigationView{
                List(steps, id: \.id) { step in
                    VStack{
                        Text("\(step.count)歩")
                        Text(step.date, style: .date)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }//NavigationView
            Picker(selection: $selection, label: Text("")){
                ForEach(0 ..< date.count){ num in
                    Text(date[num])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width:200)
        }//ZStack
        .onAppear{
            //データの読み取りの権限をリクエスト
            healthStore.requestAuthorization{ success in
                //もしデータの読み取りの権限をリクエストしてアクセスできたら
                if success{
                    print("データにアクセスできます！")
                    healthStore.calculateSteps{ statisticsCollection in
                        if let statisticsCollection = statisticsCollection{
                            print(statisticsCollection)
                            updateUIFromStatistics(statisticsCollection)
                        }
                    }
                }// if success
            }
        }//.onAppear
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
