//
//  PickerView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct PickerView: View {
    
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
