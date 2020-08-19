//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    @Environment(\.managedObjectContext) private var context
    
    @State private var showModal = false
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Temporary here")
                        .foregroundColor(.systemRed)
                ) {
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Product.self,
                                    predicate: nil
                                ) { (product: Product) in
                                    ProductEditor(product)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Product.plural, systemImage: Product.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Buyer.self,
                                    predicate: nil
                                ) { (buyer: Buyer) in
                                    BuyerEditor(buyer)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Buyer.plural, systemImage: Buyer.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Department.self,
                                    predicate: nil
                                ) { (department: Department) in
                                    //EquipmentView(equipment)
                                    DepartmentEditor(department)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Department.plural, systemImage: Department.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Employee.self,
                                    predicate: nil
                                ) { (employee: Employee) in
                                    //EquipmentView(equipment)
                                    EmployeeEditor(employee)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Employee.plural, systemImage: Employee.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Equipment.self,
                                    predicate: nil
                                ) { (equipment: Equipment) in
                                    //EquipmentView(equipment)
                                    EquipmentEditor(equipment)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Equipment.plural, systemImage: Equipment.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Packaging.self,
                                    predicate: nil
                                ) { (packaging: Packaging) in
                                    PackagingEditor(packaging)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Packaging.plural, systemImage: Packaging.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Ingredient.self,
                                    predicate: nil
                                ) { (ingredient: Ingredient) in
                                    IngredientView(ingredient)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Ingredient.plural, systemImage: Ingredient.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Recipe.self,
                                    predicate: nil
                                ) { (recipe: Recipe) in
                                    List {
                                        //  RecipeRow(recipe)
                                        RecipeEditorCore(recipe)
                                    }
                                    .listStyle(InsetGroupedListStyle())
                                    .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Recipe.plural, systemImage: Recipe.icon)
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Base.self,
                                    predicate: nil
                                ) { (base: Base) in
                                    BaseView(base)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label(Base.plural, systemImage: Base.icon)
                    }
                }
                
                GenericListSection(
                    type: Factory.self,
                    predicate: nil,
                    useSmallerFont: false
                ) { factory in
                    FactoryView(factory)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Factories")
            .navigationBarItems(
                leading: MenuCreateNewOrSample(),
                trailing: modalButton()
            )
        }
    }
    private func modalButton() -> some View {
        Button {
            showModal = true
        } label: {
            Image(systemName: "plus.rectangle.on.rectangle")
        }
        .sheet(isPresented: $showModal) {
            CreateEntityPicker(isPresented: $showModal)
                .environment(\.managedObjectContext, context)
        }
    }
}
