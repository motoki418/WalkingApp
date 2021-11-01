//
//  HealthDataModel.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/29.
//

import SwiftUI

struct HealthDataModel : Identifiable{
    var id = UUID()
    var date: Date
    var count: Int
}
