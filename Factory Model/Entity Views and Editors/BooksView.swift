//
//  BooksView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct BooksView: View {
    var factory: Factory
    
    var body: some View {
        TabView {
            ProfitLossStatement()
            Text("TBD")
        }
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .tabViewStyle(PageTabViewStyle())
        .navigationTitle("Books")
        .navigationBarTitleDisplayMode(.inline)
    }
}
