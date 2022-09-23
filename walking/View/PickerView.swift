//
//  PickerView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct PickerView: View {
    
    @AppStorage("steps_Value") private var targetNumberOfSteps: TargetNumberOfSteps = .twoThousand
    
    var body: some View {
        Text("\(targetNumberOfSteps.rawValue)歩")
            .font(.system(size: 45))
        
        Picker("", selection: $targetNumberOfSteps) {
            ForEach(TargetNumberOfSteps.allCases, id: \.self) { targetNumOfStep in
                Text("\(targetNumOfStep.rawValue)")
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
