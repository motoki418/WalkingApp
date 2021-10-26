//
//  HealthDataModel.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/29.
//

import SwiftUI
//歩数データについての構造体を定義
struct HealthDataModel : Identifiable{
    var id = UUID()
    var date: Date
    var steps: Int
}
