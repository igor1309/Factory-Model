//
//  CreateEntityPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI
import CoreData

struct CreateEntityPicker: View {
    @Binding var isPresented: Bool
    
    var factory: Factory? = nil
    
    var asCard: Bool = true
    
    var body: some View {
        if asCard {
            NavigationView {
                ScrollView {
                    VStack(spacing: 16) {
                        buttons()
                    }
                    .padding()
                }
                .navigationBarTitle("Create", displayMode: .inline)
                .toolbar{
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                }
            }
        } else {
            buttons()
        }
    }
    
    @ViewBuilder
    private func buttons() -> some View {
        Group {
            CreateNewEntityButton<Base>(isPresented: $isPresented, factory: factory, asCard: asCard)
            CreateNewEntityButton<Buyer>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Department>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Division>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Equipment>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Employee>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Expenses>(isPresented: $isPresented, asCard: asCard)
        }
        Group {
            CreateNewEntityButton<Factory>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Ingredient>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Packaging>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Product>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Recipe>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Sales>(isPresented: $isPresented, asCard: asCard)
            CreateNewEntityButton<Utility>(isPresented: $isPresented, asCard: asCard)
        }
    }
}

struct CreateEntityPicker_Previews: PreviewProvider {
    @State private static var isPresented = false
    
    static var previews: some View {
        Group {
            NavigationView {
                CreateEntityPicker(isPresented: $isPresented)
                    .navigationBarTitle("CreateEntityPicker", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 600))

            NavigationView {
                Form {
                    CreateEntityPicker(isPresented: $isPresented, asCard: false)
                }
                .navigationBarTitle("CreateEntityPicker", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 400))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
