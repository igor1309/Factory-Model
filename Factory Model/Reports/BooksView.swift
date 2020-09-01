//
//  BooksView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct BooksView: View {
    let factory: Factory
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        TabView {
            ProfitLossStatement(for: factory, in: period)
            SalesAnalysis(for: factory, in: period)
            Text("TBD")
        }
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .tabViewStyle(PageTabViewStyle())
        .navigationTitle("Books")
        .navigationBarTitleDisplayMode(.inline)
    }
}
