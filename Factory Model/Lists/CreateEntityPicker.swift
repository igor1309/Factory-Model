//
//  CreateEntityPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI
import CoreData

struct CreateEntityPicker: View {
    @Environment(\.presentationMode) private var presentation
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    CreateNewEntityButton<Packaging>()

                    Divider()
                    
                    Group {
                        CreateNewEntityButton<Base>()
                        CreateNewEntityButton<Buyer>()
                        CreateNewEntityButton<Department>()
                        CreateNewEntityButton<Division>()
                        CreateNewEntityButton<Equipment>()
                        CreateNewEntityButton<Employee>()
                        CreateNewEntityButton<Expenses>()
                    }
                    Group {
                        CreateNewEntityButton<Factory>()
                        CreateNewEntityButton<Ingredient>()
                        CreateNewEntityButton<Packaging>()
                        CreateNewEntityButton<Product>()
                        CreateNewEntityButton<Recipe>()
                        CreateNewEntityButton<Sales>()
                        CreateNewEntityButton<Utility>()
                    }
                }
                .padding()
            }
            .navigationTitle("Create")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
