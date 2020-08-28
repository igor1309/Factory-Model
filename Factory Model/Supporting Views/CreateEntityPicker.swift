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
    
    let period: Period
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Group {
                        CreateNewEntityButton<Base>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Buyer>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Department>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Division>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Equipment>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Employee>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Expenses>(isPresented: $isPresented, period: period)
                    }
                    Group {
                        CreateNewEntityButton<Factory>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Ingredient>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Packaging>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Product>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Recipe>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Sales>(isPresented: $isPresented, period: period)
                        CreateNewEntityButton<Utility>(isPresented: $isPresented, period: period)
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
