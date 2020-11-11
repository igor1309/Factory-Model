//
//  PackagingView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingView: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var packaging: Packaging
    
    init(_ packaging: Packaging) {
        self.packaging = packaging
        self.predicate = NSPredicate(format: "%K == %@", #keyPath(Product.packaging), packaging)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            childType: Product.self,
            title: packaging.name,
            predicate: predicate,
            plusButton: plusButton,
            dashboard: dashboard
        )
    }
    
    private func plusButton() -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        Section(
            header: Text("Packaging Detail")
        ) {
            NavigationLink(
                destination: PackagingEditor(packaging)
            ) {
                ListRow(packaging, period: settings.period)
            }
        }
        
        ErrorMessage(packaging)
    }
}

struct PackagingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PackagingView(Packaging.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 560))
    }
}
