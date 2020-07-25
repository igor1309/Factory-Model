//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var packagings: FetchedResults<Packaging>
    
    //    @ObservedObject
    var factory: Factory
    
    init(for factory: Factory){
        self.factory = factory
        _packagings = FetchRequest(
            entity: Packaging.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Packaging.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@", factory
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                Group {
                    NavigationLink(
                        destination: Text("TBD")
                    ) {
                        ListRow(
                            title: "Производство и продажи",
                            subtitle: "Общие выручка и затраты, средние цены продаж, маржа",
                            detail: "тут ли это показывать???",
                            icon: "cart"
                        )
                    }
                    
                    NavigationLink(
                        destination: Text("TBD")
                    ) {
                        ListRow(
                            title: "Агрегированные данные по группам (Packaging Type)",
                            subtitle: "Выручка и затраты, средние цены продаж, маржа",
                            detail: "тут ли это показывать???",
                            icon: "cart"
                        )
                    }
                }
                .font(.subheadline)
            }
            
            ForEach(packagings, id: \.objectID) { packaging in
                NavigationLink(
                    destination: PackagingView(packaging: packaging, factory: factory)
                ) {
                    ListRow(packaging)
                }
            }
            .onDelete(perform: removePackaging)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Packaging")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let packaging = Packaging(context: managedObjectContext)
            packaging.name = "New Packaging"
            factory.addToPackagings_(packaging)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removePackaging(at offsets: IndexSet) {
        for index in offsets {
            let packaging = packagings[index]
            managedObjectContext.delete(packaging)
        }
        managedObjectContext.saveContext()
    }
    
}
