//
//  SettingView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("steps_Value") private var targetNumOfSteps = 2000
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: PickerView()) {
                    Label("目標歩数の設定", systemImage: "figure.walk")
                }
                
                Button {
                    openURL(URL(string: "https://twitter.com/motoki0418")!)
                }label: {
                    Label("開発者にお問い合わせ", systemImage: "paperplane.fill")
                }
                
                Button {
                    openURL(URL(string: "https://apps.apple.com/jp/app/%E3%82%B7%E3%83%B3%E3%83%97%E3%83%AB%E6%AD%A9%E6%95%B0%E8%A8%88-simplewalking/id1590245946")!)
                }label: {
                    Label("アプリをレビューする", systemImage: "pencil.and.ellipsis.rectangle")
                }
            }
            .foregroundColor(.fontColor)
            .navigationTitle("設定")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
