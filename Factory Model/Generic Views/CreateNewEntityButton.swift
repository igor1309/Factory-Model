//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }
    
    init() {
        _isPresented = .constant(true)
    }
    
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: T.icon)
                .foregroundColor(T.color)
                .font(.system(size: 52, weight: .ultraLight, design: .default))
            
            Text(T.headline)
                .font(.subheadline)
            
            NavigationLink(
                destination: destination(),
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
    
    @ViewBuilder
    private func destination() -> some View {
        switch T.entityName {
            case Packaging.entityName: PackagingCreator(isPresented: $isPresented)
            default: Text("TBD")
        }
    }
}


struct NameEditor<T: Listable>: View where T.ManagedType == T {
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
            Section(
                header: Text(entity.name.isEmpty ? "" : "Edit \(T.entityName) Name")
            ) {
                TextField("\(T.entityName) Name", text: $entity.name)
            }
            
            GenericListSection(header: "Existing \(T.plural())", type: T.self, predicate: nil) { (entity: T) in
                editor()
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

