//
//  CreateNewEntityBarButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 11.11.2020.
//

import SwiftUI

private struct CreateNewEntityBarButton<T: Listable>: View where T.ManagedType == T {
    
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject private var settings: Settings
    
    var title: String = ""
    
    var useSheet = true
    
    @State private var isPresented = false
    
    var body: some View {
        if useSheet {
            button()
                .sheet(isPresented: $isPresented) {
                    NavigationView {
                        T.creator(isPresented: $isPresented, factory: nil)
                    }
                    .environment(\.managedObjectContext, context)
                    .environmentObject(settings)
                }
        } else {
            NavigationLink(
                destination: T.creator(isPresented: $isPresented, factory: nil),
                isActive: $isPresented
            ) {
                button()
            }
        }
    }
    
    private func button() -> some View {
        Button {
            withAnimation {
                isPresented = true
            }
        } label: {
            if title.isEmpty {
                Image(systemName: T.plusButtonIcon)
            } else {
                Label(title, systemImage: T.plusButtonIcon)
                    .foregroundColor(T.color)
            }
        }
    }
}

struct CreateNewEntityBarButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: Text("Sheet")) {
                    CreateNewEntityBarButton<Base>(title: "Create Base")
                    CreateNewEntityBarButton<Product>(title: "Create Product")
                }
                Section(header: Text("Navigation")) {
                    CreateNewEntityBarButton<Base>(title: "Create Base", useSheet: false)
                    CreateNewEntityBarButton<Product>(title: "Create Product", useSheet: false)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("CreateNewEntityBarButton", displayMode: .inline)
            .navigationBarItems(trailing: CreateNewEntityBarButton<Base>())
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 400))
    }
}
