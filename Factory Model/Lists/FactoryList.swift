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
