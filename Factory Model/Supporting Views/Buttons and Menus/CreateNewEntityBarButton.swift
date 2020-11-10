//
//  CreateNewEntityBarButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 11.11.2020.
//

import SwiftUI

struct CreateNewEntityBarButton<T: Listable>: View where T.ManagedType == T {
    
    @State private var isPresented = false
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: T.plusButtonIcon)
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                T.creator(isPresented: $isPresented)
            }
        }
    }
}

struct CreateNewEntityBarButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color
                .blue
                .opacity(0.2)
                .navigationBarItems(trailing: CreateNewEntityBarButton<Base>())
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 200))
    }
}
