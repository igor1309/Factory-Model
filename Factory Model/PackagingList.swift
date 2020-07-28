//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var packagings: FetchedResults<Packaging>
    @FetchRequest private var orphans: FetchedResults<Packaging>
    @FetchRequest private var allPackagings: FetchedResults<Packaging>
    
    var factory: Factory
    
    init(
        for factory: Factory
    ) {
        self.factory = factory
        
        _packagings = Packaging.defaultFetchRequest(for: factory)
        
        let predicate2 = NSPredicate(
            format: "ANY %K = nil", #keyPath(Packaging.products_)
        )
        _orphans = Packaging.defaultFetchRequest(with: predicate2)
        
        _allPackagings = FetchRequest(
            entity: Packaging.entity(),
            sortDescriptors: Packaging.defaultSortDescriptors
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
            
            GenericListSection(title: "All Packagings", fetchRequest: _allPackagings) { packaging in
                PackagingView(packaging: packaging)
            }
            
            GenericListSection(title: "Factory Packagings", fetchRequest: _packagings) { packaging in
                PackagingView(packaging: packaging)
            }
            
            //  MARK: - FINISH THIS NOT UPDATING!!!! (((
            GenericListSection(title: "Orphans", fetchRequest: _orphans) { packaging in
                    PackagingView(packaging: packaging)
            }
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Packagings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: PlusButton(type: Packaging.self))
    }
    
    private func list(of packagings: FetchedResults<Packaging>) -> some View {
        func remove(at offsets: IndexSet) {
            //  MARK: - FINISH THIS удаление не сиротских объектов лучше не допускать без подтверждения
            for index in offsets {
                let packaging = packagings[index]
                moc.delete(packaging)
            }
            moc.saveContext()
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
}
