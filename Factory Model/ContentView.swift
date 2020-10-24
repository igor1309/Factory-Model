//
//  ContentView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct ContentView: View {
    @State private var period: Period = .month()
    
    var body: some View {
        NavigationView {
            Testing(in: $period)
        }
        
//        NavigationView {
//            FactoryList(in: period)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, PersistenceManager.previewContext)
    }
}
