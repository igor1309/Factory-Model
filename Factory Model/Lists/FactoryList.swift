//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {    
    var body: some View {
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
            trailing:
                HStack(spacing: 16) {
                    MenuCreateNewOrSample()
                    CreateEntityPickerButton()
                }
        )
    }
}

