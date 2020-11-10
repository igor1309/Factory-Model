//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    /// to update list (fetch) by publishing context saved event
    /// https://stackoverflow.com/a/58777603/11793043
    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    private func dashboard() -> some View {
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
    }
    
    var body: some View {
        
//        EntityListWithDashboard(for: factory, dashboard: dashboard) { (packaging: Packaging) in
//            PackagingEditor(packaging)
//        }
        
        ListWithDashboard(
            childType: Packaging.self,
            for: factory,
            predicate: Packaging.factoryPredicate(for: factory)
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
            dashboard()
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
            PackagingList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
