//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        List {
            GenericListSection(
                type: Factory.self,
                predicate: nil,
                smallFont: false,
                in: settings.period
            ) { factory in
                FactoryView(factory, in: $settings.period)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Factories")
        .navigationBarItems(
            trailing:
                HStack(spacing: 16) {
                    MenuCreateNewOrSample(period: settings.period)
                    CreateEntityPickerButton(period: settings.period)
                }
        )
    }
}


struct FactoryList_Previews: PreviewProvider {
    @State static var period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            FactoryList()
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
