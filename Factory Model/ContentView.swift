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
    static let manager = PersistenceManager(containerName: "DataModel")
    
    static var previews: some View {
        try? manager.createSampleData()
        
        return ContentView()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, manager.context)
    }
}
