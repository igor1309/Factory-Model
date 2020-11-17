//
//  ReportsView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct ReportsView: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        TabView {
            ProfitAndLossView(for: factory)
            SalesAnalysis(for: factory)
            ProductionAnalysis(for: factory)
            Text("TBD")
        }
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .tabViewStyle(PageTabViewStyle())
        .navigationBarTitle("Books", displayMode: .inline)
    }
}

struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView(for: Factory.example)
            .environmentObject(Settings())
            .preferredColorScheme(.dark)
    }
}
