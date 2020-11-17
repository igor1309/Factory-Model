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
    
    let factory: Factory?
    let asCard: Bool
    
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
                CreateNewEntityButton<Buyer>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Department>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Division>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Equipment>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Employee>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Expenses>(isPresented: $isPresented, factory: factory)
            }
            Group {
                CreateNewEntityButton<Factory>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Ingredient>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Packaging>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Product>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Recipe>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Sales>(isPresented: $isPresented, factory: factory)
                CreateNewEntityButton<Utility>(isPresented: $isPresented, factory: factory)
            }
        } else {
            Group {
                CreateNewEntityButton<Base>(factory: factory, kind: kind)
                CreateNewEntityButton<Buyer>(factory: factory, kind: kind)
                CreateNewEntityButton<Department>(factory: factory, kind: kind)
                CreateNewEntityButton<Division>(factory: factory, kind: kind)
                CreateNewEntityButton<Equipment>(factory: factory, kind: kind)
                CreateNewEntityButton<Employee>(factory: factory, kind: kind)
                CreateNewEntityButton<Expenses>(factory: factory, kind: kind)
            }
            Group {
                CreateNewEntityButton<Factory>(factory: factory, kind: kind)
                CreateNewEntityButton<Ingredient>(factory: factory, kind: kind)
                CreateNewEntityButton<Packaging>(factory: factory, kind: kind)
                CreateNewEntityButton<Product>(factory: factory, kind: kind)
                CreateNewEntityButton<Recipe>(factory: factory, kind: kind)
                CreateNewEntityButton<Sales>(factory: factory, kind: kind)
                CreateNewEntityButton<Utility>(factory: factory, kind: kind)
            }
        }
    }
}

struct CreateEntityPicker_Previews: PreviewProvider {
    @State private static var isPresented = false
    
    static var previews: some View {
        Group {
            NavigationView {
                CreateEntityPicker(isPresented: $isPresented, factory: nil, asCard: true)
                    .navigationBarTitle("CreateEntityPicker", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 600))

            NavigationView {
                Form {
                    CreateEntityPicker(isPresented: $isPresented, factory: nil, asCard: false)
                }
                .navigationBarTitle("CreateEntityPicker", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 500))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
