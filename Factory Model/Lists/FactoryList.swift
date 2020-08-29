//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    
    let period: Period
    
    init(in period: Period) {
        self.period = period
    }
    
    var body: some View {
        List {
            GenericListSection(
                type: Factory.self,
                predicate: nil,
                useSmallerFont: false,
                in: period
            ) { factory in
                FactoryView(factory, in: period)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Factories")
        .navigationBarItems(
            trailing:
                HStack(spacing: 16) {
                    MenuCreateNewOrSample(period: period)
                    CreateEntityPickerButton(period: period)
                }
        )
    }
}

