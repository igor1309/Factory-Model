//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @Environment(\.managedObjectContext) var сontext
    
    @FetchRequest private var packagings: FetchedResults<Packaging>
    @FetchRequest private var orphans: FetchedResults<Packaging>
    @FetchRequest private var allPackagings: FetchedResults<Packaging>
    
    //    @ObservedObject
    var factory: Factory
    
    init(
        for factory: Factory
    ) {
        self.factory = factory
        
        _packagings = FetchRequest(
            entity: Packaging.entity(),
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \Packaging.name_, ascending: true
                )
            ]
            ,
            predicate: NSPredicate(
                format: "ANY %K.base.factory = %@", #keyPath(Packaging.products_), factory
            )
        )
        
        _orphans = FetchRequest(
            entity: Packaging.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Packaging.name_, ascending: true)
            ]
            ,
            predicate: NSPredicate(
                format: "ANY %K = nil", #keyPath(Packaging.products_)
            )
        )
        
        _allPackagings = FetchRequest(
            entity: Packaging.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Packaging.name_, ascending: true)
            ]
        )
    }
    
    var body: some View {
        List {
            Text("""
                PROBLEM:
                - adding packaging with +
                - packaging editing
                does not update the view
                
                LISTS:
                - (TBD: fix FetchRequest) used on factory
                - (TBD: fix FetchRequest) orphaned (not attached to the product)
                - all
                """)
                .foregroundColor(.systemRed)
                .font(.subheadline)
            
            if !allPackagings.isEmpty {
                Section(
                    header: Text("All Packagings")
                ) {
                    list(of: allPackagings)
                }
            }
            
            if !packagings.isEmpty {
                Section(
                    header: Text("Factory Packagings")
                ) {
                    list(of: packagings)
                }
            }
            
            if !orphans.isEmpty {
                Section(
                    header: Text("Orphans")
                ) {
                    list(of: orphans)
                }
            }
        }
        .onDisappear { сontext.saveContext() }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Packagings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: plusButton)
    }
    
    private func list(of packagings: FetchedResults<Packaging>) -> some View {
        func remove(at offsets: IndexSet) {
            //  MARK: - FINISH THIS удаление не сиротских объектов лучше не допускать без подтверждения
            for index in offsets {
                let packaging = packagings[index]
                сontext.delete(packaging)
            }
            
            сontext.saveContext()
        }
        
        return ForEach(packagings, id: \.objectID) { packaging in
            NavigationLink(
                destination: PackagingView(packaging: packaging)
            ) {
                ListRow(packaging)
            }
        }
        .onDelete(perform: remove)
    }
    
    private var plusButton: some View {
        Button {
            let packaging = Packaging(context: сontext)
            packaging.name = " New Packaging"
            //            packaging.addToProducts(product)
            //            factory.addToPackagings_(packaging)
            packaging.objectWillChange.send()
            сontext.saveContext()
            //  MARK: FINISH THIS: PROBLEM: VIEW NOT UPDATING!!!
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
