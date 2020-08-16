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

struct CreateNewEntityButton<T: Managed & Monikerable & Summarizable>: View {
    //  MARK: - FINISH THIS
    //  DO NOT FORGET TO DELETE ENTITY FROM CONTEXT IF SAVE BUTTON WAS NOT TAPPED
    @Environment(\.managedObjectContext) private var context
    
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: T.icon)
                .foregroundColor(T.color)
                .font(.system(size: 52, weight: .ultraLight, design: .default))
            
            Text(T.headline)
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

struct NameEditor<T: Managed & Monikerable>: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var entity: T
    
    private var buttonName: String {
        switch T.entityName {
            case Packaging.entityName: return "Next"
            default: return "Save"
        }
    }
    
    @ViewBuilder
    private func editor() -> some View {
        switch T.entityName {
            case Base.entityName:       BaseEditor(entity as! Base)
            case Buyer.entityName:      BuyerView(entity as! Buyer)
            case Department.entityName: DepartmentView(entity as! Department)
            case Division.entityName:   DivisionView(entity as! Division)
            case Equipment.entityName:  EquipmentView(entity as! Equipment)
            case Employee.entityName:   EmployeeView(entity as! Employee)
            case Expenses.entityName:   ExpensesView(entity as! Expenses)
            case Factory.entityName:    FactoryView(entity as! Factory)
            case Ingredient.entityName: IngredientView(entity as! Ingredient)
            case Packaging.entityName:  PackagingView(entity as! Packaging)
            case Product.entityName:    ProductView(entity as! Product)
            case Recipe.entityName:     RecipeView(entity as! Recipe)
            case Sales.entityName:      SalesView(entity as! Sales)
            case Utility.entityName:    UtilityView(entity as! Utility)
            default: EmptyView()
        }
    }
    
    @State private var isActive = false
    
    var body: some View {
        NavigationLink(destination: editor(), isActive: $isActive) { EmptyView() }
        List {
            Section(header: Text("Name")) {
                TextField("Name", text: $entity.name)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("New \(T.entityName)")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                    Button("Next") {//buttonName) {//"Save") {
                        isActive = true
                        //                    try? context.save()
                        //                    presentation.wrappedValue.dismiss()
                    }
                    .disabled(entity.name.isEmpty)
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

