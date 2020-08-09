//
//  BooksView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct BooksView: View {
    var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        TabView {
            ProfitLossStatement(for: factory)
            Text("TBD")
        }
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .tabViewStyle(PageTabViewStyle())
        .navigationTitle("Books")
        .navigationBarTitleDisplayMode(.inline)
    }
}
