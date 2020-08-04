//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            List {
                
                Section(
                    header: Text("Ingredients. Temporary here")
                        .foregroundColor(.systemRed)
                ) {
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Base.self,
                                    predicate: nil
                                ) { (base: Base) in
                                    BaseEditor(base)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Text("Bases")
                    }

                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Ingredient.self,
                                    predicate: nil
                                ) { (ingredient: Ingredient) in
                                    List {
                                        //  IngredientRow(ingredient)
                                        IngredientEditorCore(ingredient)
                                    }
                                    .listStyle(InsetGroupedListStyle())
                                    .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Text("Ingredients")
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
                trailing: HStack {
                    plusSampleButton
                    CreateOrphanButton<Factory>()
                    CreateNewEntityButton()
                }
            )
        }
    }
        
    private var plusSampleButton: some View {
        Button {
            let _ = Factory.createFactory1(in: context)
            let _ = Factory.createFactory2(in: context)
            context.saveContext()
        } label: {
            Image(systemName: "rectangle.stack.badge.plus")
                .padding([.leading, .vertical])
        }
    }
}
