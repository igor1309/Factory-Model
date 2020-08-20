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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Group {
                        CreateNewEntityButton<Base>(isPresented: $isPresented)
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
                }
                .padding()
            }
            .navigationTitle("Create")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
