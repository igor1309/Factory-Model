//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    @Binding var isPresented: Bool
    
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: T.icon)
                .foregroundColor(T.color)
                .font(.system(size: 52, weight: .ultraLight, design: .default))
                .padding(.top, 6)
            
            Text(T.headline)
                .font(.subheadline)
            
            NavigationLink(
                destination: T.creator(isPresented: $isPresented),
                isActive: $isActive
            ) {
                Button {
                    isActive = true
                } label: {
                    Text("Create \(T.entityName)")
                        .frame(maxWidth: .infinity)
                        .accentColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                }
            }
        }
        .simpleCardify()
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
            .navigationBarItems(trailing: CreateNewEntityBarButton<Utility>())
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
