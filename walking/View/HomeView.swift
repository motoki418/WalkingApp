//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    //HealthDataViewModelを参照する状態変数
    //これでViewがViewModelのデータを監視できるようになる
    @ObservedObject var HomeVM: HomeViewModel = HomeViewModel()
    
    // この変数で表示位置を指定できる(中央はtag(1)なので1)
    @State private var selection = 1
    var body: some View {
        NavigationView{
            VStack {
                TabView(selection: $selection) {
                    Yesterday()
                        .tag(0)
                    Today()
                        .tag(1)
                    Tomorrow()
                        .tag(2)
                }
//                .onChange(of: selection, perform: { _ in
//
//                })
                .onAppear(){
                    print(selection)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        
    }
}//HomeView
