//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest private var packagings: FetchedResults<Packaging>
    @FetchRequest private var orphans: FetchedResults<Packaging>
    
    @ObservedObject var factory: Factory
    
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
            ],
            predicate: NSPredicate(
                format: "ANY %K = nil", #keyPath(Packaging.products_)
            )
        )
    }
    
    var body: some View {
        List {
            Text("PROBLEM: adding packaging with + does not update the view")
                .foregroundColor(.red)
                .font(.subheadline)
            
            ListRow(
                title: "Name",
                subtitle: "TBD: сводка?",
                detail: "TBD: что еще?",
                icon: "shippingbox"
            )
            
            if !packagings.isEmpty {
                Section(
                    header: Text("TESTING Factory Packagings")
                ) {
                    list(of: packagings)
                }
            }
            
            Section(
                header: Text("Factory Packagings")
            ) {
                ForEach(packagings, id: \.objectID) { packaging in
                    ListRow(packaging)
                }
                .onDelete(perform: removePackagings)
            }
            
            if !orphans.isEmpty {
                Section(
                    header: Text("TESTING Orphans")
                ) {
                    list(of: orphans)
                }
            }
            
            Section(
                header: Text("Orphans")
            ) {
                ForEach(orphans, id: \.objectID) { packaging in
                    ListRow(packaging)
                }
                .onDelete(perform: removeOrphans)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Packagings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: plusButton)
    }
    
    private func list(of packagings: FetchedResults<Packaging>) -> some View {
        func remove(at offsets: IndexSet) {
            for index in offsets {
                let packaging = packagings[index]
                managedObjectContext.delete(packaging)
            }
            
            managedObjectContext.saveContext()
        }
        
        return ForEach(packagings, id: \.objectID) { packaging in
            ListRow(packaging)
        }
        .onDelete(perform: remove)
    }
    
    private func removePackagings(at offsets: IndexSet) {
        for index in offsets {
            let packaging = packagings[index]
            managedObjectContext.delete(packaging)
        }
        
        managedObjectContext.saveContext()
    }
    
    private func removeOrphans(at offsets: IndexSet) {
        for index in offsets {
            let orphan = orphans[index]
            managedObjectContext.delete(orphan)
        }
        
        managedObjectContext.saveContext()
    }
    
    private var plusButton: some View {
        Button {
            let packaging = Packaging(context: managedObjectContext)
            packaging.name = "New Packaging"
            //            packaging.addToProducts(product)
            //            factory.addToPackagings_(packaging)
            managedObjectContext.saveContext()
            //  MARK: FINISH THIS: PROBLEM: VIEW NOT UPDATING!!!
            //            packaging.objectWillChange.send()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
