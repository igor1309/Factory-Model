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
    
    private var kind: EntityButtonKind {
        if asCard {
            return .card
        } else {
            return .label
        }
    }
    
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
        if asCard {
            Group {
                CreateNewEntityButton<Base>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Buyer>(isPresented: $isPresented)
                CreateNewEntityButton<Department>(isPresented: $isPresented)
                CreateNewEntityButton<Division>(isPresented: $isPresented)
                CreateNewEntityButton<Equipment>(isPresented: $isPresented)
                CreateNewEntityButton<Employee>(isPresented: $isPresented)
                CreateNewEntityButton<Expenses>(isPresented: $isPresented)
            }
            Group {
                CreateNewEntityButton<Factory>(isPresented: $isPresented)
                CreateNewEntityButton<Ingredient>(isPresented: $isPresented)
                CreateNewEntityButton<Packaging>(isPresented: $isPresented)
                CreateNewEntityButton<Product>(isPresented: $isPresented)
                CreateNewEntityButton<Recipe>(isPresented: $isPresented)
                CreateNewEntityButton<Sales>(isPresented: $isPresented)
                CreateNewEntityButton<Utility>(isPresented: $isPresented)
            }
        } else {
            Group {
                CreateNewEntityButton<Base>(factory: factory, kind: kind)
                CreateNewEntityButton<Buyer>(kind: kind)
                CreateNewEntityButton<Department>(kind: kind)
                CreateNewEntityButton<Division>(kind: kind)
                CreateNewEntityButton<Equipment>(kind: kind)
                CreateNewEntityButton<Employee>(kind: kind)
                CreateNewEntityButton<Expenses>(kind: kind)
            }
            Group {
                CreateNewEntityButton<Factory>(kind: kind)
                CreateNewEntityButton<Ingredient>(kind: kind)
                CreateNewEntityButton<Packaging>(kind: kind)
                CreateNewEntityButton<Product>(kind: kind)
                CreateNewEntityButton<Recipe>(kind: kind)
                CreateNewEntityButton<Sales>(kind: kind)
                CreateNewEntityButton<Utility>(kind: kind)
            }
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
            .previewLayout(.fixed(width: 350, height: 500))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
