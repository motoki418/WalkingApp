//
//  SettingView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("steps_Value") private var targetNumOfSteps: Int = 2000
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: PickerView()) {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.keyColor)
                    Text("目標歩数")
                    Spacer()
                    Text("\(targetNumOfSteps)歩")
                }
            }
            .navigationBarTitle("設定")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
