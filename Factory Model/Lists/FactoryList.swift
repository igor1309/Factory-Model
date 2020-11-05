//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    
    @Binding var period: Period
    
    init(in period: Binding<Period>) {
        _period = period
    }
    
    var body: some View {
        List {
            GenericListSection(
                type: Factory.self,
                predicate: nil,
                smallFont: false,
                in: period
            ) { factory in
                FactoryView(factory, in: $period)
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


struct FactoryList_Previews: PreviewProvider {
    @State static var period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            FactoryList(in: $period)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .preferredColorScheme(.dark)
        }
    }
}
