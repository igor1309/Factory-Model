//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    var iconOnly: Bool = false
    
    @Binding var isPresented: Bool
    
    @State private var isActive = false
    
    private var navigationLink: some View {
        NavigationLink(
            destination: T.creator(isPresented: $isPresented),
            isActive: $isActive
        ) {
            Button {
                isActive = true
            } label: {
                if iconOnly {
                    Image(systemName: T.plusButtonIcon)
                } else {
                    Text("Create \(T.entityName)")
                        .frame(maxWidth: .infinity)
                        .accentColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                }
            }
        }
    }
    
    var body: some View {
        if iconOnly {
            navigationLink
        } else {
            VStack(spacing: 16) {
                Image(systemName: T.icon)
                    .foregroundColor(T.color)
                    .font(.system(size: 52, weight: .ultraLight, design: .default))
                    .padding(.top, 6)
                
                Text(T.headline)
                    .font(.subheadline)
                
                navigationLink
            }
            .simpleCardify()
        }
    }
}

struct CreateNewEntityButton_Previews: PreviewProvider {
    @State private static var isPresented = false
    
    static var previews: some View {
        NavigationView {
            ScrollView {
                CreateNewEntityButton<Base>(isPresented: $isPresented)
                CreateNewEntityButton<Packaging>(isPresented: $isPresented)
                CreateNewEntityButton<Utility>(isPresented: $isPresented)
            }
            .padding(.horizontal)
            .navigationBarItems(trailing: CreateNewEntityButton<Utility>(iconOnly: true, isPresented: $isPresented))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
