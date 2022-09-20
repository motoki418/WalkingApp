//
//  PickerView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct PickerView: View {
    
    enum TargetNumberOfSteps: Int, CaseIterable {
        case twoThousand = 2000
        case threeThousand = 3000
        case fourThousand = 4000
        case fiveThousand = 5000
        case sixThousand = 6000
        case sevenThousand = 7000
        case eightThousand = 8000
        case nineThousand = 9000
        case tenThousand = 10000
    }
    
    @AppStorage("steps_Value") private var targetNumOfSteps: TargetNumberOfSteps = .twoThousand
    
    var body: some View {
        Text("\(targetNumOfSteps.rawValue)歩")
            .font(.system(size: 45))
        
        Picker("", selection: $targetNumOfSteps) {
            ForEach(TargetNumberOfSteps.allCases, id: \.self) { steps in
                Text("\(steps.rawValue)")
                    .font(.largeTitle)
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
