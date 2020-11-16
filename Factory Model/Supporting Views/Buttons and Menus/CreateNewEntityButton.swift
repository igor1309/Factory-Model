//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    @Binding var isPresented: Bool
    
    var factory: Factory? = nil
    
    var asCard: Bool = true
    
    @State private var isActive = false
    
    var body: some View {
        if asCard {
            VStack(spacing: 16) {
                Image(systemName: T.icon)
                    .foregroundColor(T.color)
                    .font(.system(size: 52, weight: .ultraLight, design: .default))
                    .padding(.top, 6)
                
                Text(T.headline)
                    .font(.subheadline)
                
                button()
            }
            .simpleCardify()
        } else {
            button()
        }
    }
    
    private func button() -> some View {
        NavigationLink(
            destination: T.creator(isPresented: $isPresented, factory: factory),
            isActive: $isActive
        ) {
            Button {
                isActive = true
            } label: {
                if asCard {
                    Text("Create \(T.entityName)")
                        .frame(maxWidth: .infinity)
                        .accentColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                } else {
                    Label("Create \(T.entityName)", systemImage: T.icon)
                        .foregroundColor(T.color)
                }
            }
        }
    }
}

struct CreateNewEntityButton_Previews: PreviewProvider {
    @State private static var isPresented = false
    
    static var previews: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CreateNewEntityButton<Base>(isPresented: $isPresented, asCard: false)
                    Divider()
                    CreateNewEntityButton<Base>(isPresented: $isPresented)
                    CreateNewEntityButton<Packaging>(isPresented: $isPresented)
                    CreateNewEntityButton<Utility>(isPresented: $isPresented)
                }
                .padding(.horizontal)
                .navigationBarItems(trailing: CreateNewEntityBarButton<Utility>())
            }
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
