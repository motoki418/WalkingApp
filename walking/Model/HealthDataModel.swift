//
//  HealthDataModel.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/29.
//
import SwiftUI
import HealthKit

class HealthDataModel: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    let readTypes = HKObjectType.quantityType(forIdentifier: .stepCount)!
    
    private let calendar = Calendar(identifier: .gregorian)
    
    var selectionDate = Date() {
        willSet {
        }
        didSet {
            getDailyStepCount()
        }
    }
    
    @Published var steps = 0
    
    // 00:00:00~23:59:59までを一日分として各日の合計歩数を取得するメソッド
    func getDailyStepCount() {
        DispatchQueue.main.async {
            self.steps = 0
        }
        let startDate  = calendar.date(bySettingHour: 0,
                                       minute: 0,
                                       second: 0,
                                       of: selectionDate)
        let endDate = calendar.date(bySettingHour: 23,
                                    minute: 59,
                                    second: 59,
                                    of: selectionDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)        
        let query = HKStatisticsCollectionQuery(quantityType: readTypes,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startDate!,
                                                intervalComponents: DateComponents(day: 1)
        )
        query.initialResultsHandler = { query, results, error in
            
            guard let statisticsCollection = results else {
                return
            }
            
            statisticsCollection.enumerateStatistics(from: startDate!,
                                                     to: self.selectionDate,
                                                     with: {( statistics, _) in
                if let sum = statistics.sumQuantity() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.steps = Int(sum.doubleValue(for: HKUnit.count()))
                    }
                } else {
                    DispatchQueue.main.async {
                        self.steps = 0
                    }
                }
            })
        }
        query.statisticsUpdateHandler = { query, results, statisticsCollection, error in
            statisticsCollection?.enumerateStatistics(from: startDate!,
                                                      to: self.selectionDate,
                                                      with: {(statistics, _) in
                if let sum = statistics.sumQuantity() {
                    DispatchQueue.main.async {
                        self.steps = Int(sum.doubleValue(for: HKUnit.count()))
                    }
                } else {
                    DispatchQueue.main.async {
                        self.steps = 0
                    }
                }
            })
        }
        healthStore.execute(query)
    }
}
