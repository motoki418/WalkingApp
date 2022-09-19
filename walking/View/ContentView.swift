//
// ContentView.swift
// walking
//
// Created by nakamura motoki on 2021/09/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
            
            ReportView()
                .tabItem {
                    Label("レポート", systemImage: "chart.bar.fill")
                }
            
            SettingView()
                .tabItem {
                    Label("設定", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.keyColor)
    }
}
