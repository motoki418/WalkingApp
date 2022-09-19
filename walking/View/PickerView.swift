//
//  PickerView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct PickerView: View {
    
    @AppStorage("steps_Value") private var targetNumOfSteps = 2000
    
    var body: some View {
        Text("\(targetNumOfSteps)歩")
            .font(.system(size: 45))
        
        Picker("", selection: $targetNumOfSteps) {
            Text("2000")
                .tag(2000)
            Text("3000")
                .tag(3000)
            Text("4000")
                .tag(4000)
            Text("5000")
                .tag(5000)
            Text("6000")
                .tag(6000)
            Text("7000")
                .tag(7000)
            Text("8000")
                .tag(8000)
            Text("9000")
                .tag(9000)
            Text("10000")
                .tag(10000)
        }
        .pickerStyle(WheelPickerStyle())
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
