//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    /// to update list (fetch) by publishing context saved event
    /// https://stackoverflow.com/a/58777603/11793043
    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            predicate: Packaging.factoryPredicate(for: factory),
            in: period
        ) {
            CreateOrphanButton<Packaging>()
            
            //  MARK: - FINISH THIS FIGURE OUT HIW TO CREATE PACKAGING FROM HERE
            // EmptyView()
            /* CreateChildButton(
             systemName: "plus.square",
             childType: Packaging.self,
             parent: factory,
             keyPath: \Factory.packagings_
             ) */
        } dashboard: {
            Section {
                Group {
                    /// refreshing UI if context was saved
                    LabelWithDetail("squareshape.split.3x3" + (refreshing ? "" : ""), "No of Packagings", factory.packagings.count.formattedGrouped)
                    //                    LabelWithDetail(<#T##systemName: String##String#>, <#T##title: _##_#>, <#T##detail: _##_#>)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            //            Text("TBD: dashboard: List of packaging types (??)")
            //                .font(.subheadline)
            //                .foregroundColor(.systemRed)
        } editor: { (packaging: Packaging) in
            PackagingEditor(packaging, in: period)
        }
        /// observing context saving
        .onReceive(didSave) { _ in
            refreshing.toggle()
        }
    }
}

struct PackagingList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PackagingList(for: Factory.preview, in: .month())
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .preferredColorScheme(.dark)
        }
    }
}
