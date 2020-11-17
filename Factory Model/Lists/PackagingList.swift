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
    
    var body: some View {
        ListWithDashboard(
            childType: Packaging.self,
            predicate: Packaging.factoryPredicate(for: factory),
            plusButton: plusButton,
            dashboard: dashboard
        )
        /// observing context saving
        .onReceive(didSave) { _ in
            refreshing.toggle()
        }
    }
    
    private func plusButton() -> some View {
        CreateNewEntityButton<Packaging>()
        
        //  MARK: - FINISH THIS FIGURE OUT HIW TO CREATE PACKAGING FROM HERE
        // EmptyView()
        /* CreateChildButton(
         systemName: "plus.square",
         childType: Packaging.self,
         parent: factory,
         keyPath: \Factory.packagings_
         ) */
    }
    
    private func dashboard() -> some View {
        Section {
            Group {
                /// refreshing UI if context was saved
                LabelWithDetail("squareshape.split.3x3" + (refreshing ? "" : ""), "No of Packagings", factory.packagings.count.formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        //            Text("TBD: dashboard: List of packaging types (??)")
        //                .font(.subheadline)
        //                .foregroundColor(.systemRed)
    }
}

struct PackagingList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PackagingList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
