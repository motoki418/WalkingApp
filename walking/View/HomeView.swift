//
//  HomeView.swift
//  walking
//
//  Created by nakamura motoki on 2021/09/20.
//

import SwiftUI

struct HomeView: View {
    
    @State private var selectionDate = Date()
    
    @State private var selection = 1
    
    private let calendar = Calendar(identifier: .gregorian)
    
    var body: some View {
        VStack {
            HomeViewHeader(selectionDate: $selectionDate)
            TabView(selection: $selection) {
                HomeViewBody(selectionDate: selectionDate)
                    .tag(0)
                HomeViewBody(selectionDate: selectionDate)
                    .tag(1)
                HomeViewBody(selectionDate: selectionDate)
                    .tag(2)
            }
            .onChange(of: selection) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    selection = 1
                    if newValue == 0 {
                        selectionDate = calendar.date(byAdding: DateComponents(day: -1), to: selectionDate)!
                    } else if newValue == 2 {
                        selectionDate = calendar.date(byAdding: DateComponents(day: 1), to: selectionDate)!
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
