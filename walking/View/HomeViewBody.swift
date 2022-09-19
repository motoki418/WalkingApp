//
//  HomeViewBody.swift.swift
//  walking
//
//  Created by nakamura motoki on 2021/11/07.
//

import SwiftUI
import HealthKit

struct HomeViewBody: View {
    
    @ObservedObject private var HealthDM: HealthDataModel
    
    init(selectionDate: Date) {
        HealthDM = HealthDataModel()
        HealthDM.selectionDate = selectionDate
    }
    
    @AppStorage("steps_Value") private var targetNumOfSteps = 2000
    
    var body: some View {
        VStack(spacing: 50) {
            if HealthDM.steps < targetNumOfSteps {
                Text("目標歩数まで \(targetNumOfSteps - HealthDM.steps) 歩！")
                    .font(.title)
            } else {
                Text("今日の目標達成！🎉🎉🎉")
                    .font(.title)
            }
            ZStack {
                Circle()
                    .stroke(Color.keyColor, style: StrokeStyle(lineWidth: 20))
                    .opacity(0.2)
                // 進捗用のCircle
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(HealthDM.steps) / Double(targetNumOfSteps), 1.0)))
                    .stroke(Color.keyColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .animation(.linear(duration: 1))
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("現在   \(HealthDM.steps)")
                    Divider()
                        .frame(width: 170, height: 4)
                        .background(Color.keyColor)
                    Text("目標   \(targetNumOfSteps)")
                }
                .font(.title)
            }
            .frame(width: 300, height: 300)
        }
        .onAppear {
            if HKHealthStore.isHealthDataAvailable() {
                HealthDM.healthStore.requestAuthorization(toShare: [], read: [HealthDM.readTypes]) { success, _ in
                    if success {
                        HealthDM.getDailyStepCount()
                    }
                }
            }
        }
    }
    // 達成率を計算するメソッド
    func achievementRate() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: NSNumber(value: Double(HealthDM.steps) / Double(targetNumOfSteps)))!
    }
}
