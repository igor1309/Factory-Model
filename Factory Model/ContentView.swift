//
//  ContentView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Testing()
        }
        
//        NavigationView {
//            FactoryList(in: period)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceManager.previewContext)
            .environmentObject(Settings())
            .preferredColorScheme(.dark)
    }
}
