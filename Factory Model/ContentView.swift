//
//  ContentView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FactoryList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}


import CoreData

struct TestingCoreDataModel: View {
    @Environment(\.presentationMode) private var presentation
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Group {
                        CreateNewEntityButton<Base>(headline: "Create base product with ingredients.")
                        CreateNewEntityButton<Buyer>(headline: "Create \(Buyer.entityName.lowercased()).")
                        CreateNewEntityButton<Department>(headline: "Create \(Department.entityName.lowercased()).")
                        CreateNewEntityButton<Division>(headline: "Create \(Division.entityName.lowercased()).")
                        CreateNewEntityButton<Employee>(headline: "Create \(Employee.entityName.lowercased()).")
                        CreateNewEntityButton<Equipment>(headline: "Create \(Equipment.entityName.lowercased()).")
                        CreateNewEntityButton<Expenses>(headline: "Create \(Expenses.entityName.lowercased()).")
                    }
                    Group {
                        CreateNewEntityButton<Factory>(headline: "Create \(Factory.entityName.lowercased()).")
                        CreateNewEntityButton<Ingredient>(headline: "Create \(Ingredient.entityName.lowercased()).")
                        CreateNewEntityButton<Packaging>(headline: "Create \(Packaging.entityName.lowercased()).")
                        CreateNewEntityButton<Product>(headline: "Create a product for sale with base product, base product quantity, packaging, VAT and other parameters.")
                        CreateNewEntityButton<Recipe>(headline: "Create \(Recipe.entityName.lowercased()).")
                        CreateNewEntityButton<Sales>(headline: "Create \(Sales.entityName.lowercased()).")
                    }
                    CreateNewEntityButton<Utility>(headline: "Create \(Utility.entityName.lowercased()).")
                }
                .padding()
            }
            .navigationTitle("New Entity New Entity New Entity New Entity")
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

struct NameEditor<T: Managed & Monikerable>: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var entity: T
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                TextField("Name", text: $entity.name)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("New \(T.entityName)")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    try? context.save()
                    presentation.wrappedValue.dismiss()
                }
            }
            //            ToolbarItem(placement: .cancellationAction) {
            //                Button {
            //                    //  MARK: - DELETE ENTITY FROM CONTEXT HERE??????
            //                    presentation.wrappedValue.dismiss()
            //                } label: {
            //                    Label("Back", systemImage: "chevron.left")
            //                }
            //            }
        }
    }
}


struct CreateNewEntityButton<T: Managed & Monikerable & Summarizable>: View {
    //  MARK: - FINISH THIS
    //  DO NOT FORGET TO DELETE ENTITY FROM CONTEXT IF SAVE BUTTON WAS NOT TAPPED
    @Environment(\.managedObjectContext) private var context
    
    let headline: String
    
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: T.icon)
                .foregroundColor(T.color)
                .font(.system(size: 52, weight: .ultraLight, design: .default))
            
            Text(headline)
                .font(.subheadline)
            
            NavigationLink(
                destination: NameEditor(entity: T.create(in: context))
                    .environment(\.managedObjectContext, context),
                isActive: $isActive
            ) {
                Button {
                    isActive = true
                } label: {
                    Text("Create \(T.entityName)")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                }
            }
        }
        .simpleCardify()
    }
}
