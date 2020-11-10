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
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(Product.packaging), packaging)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        List {
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
            
            GenericListSection(header: "Used in Products", type: Product.self, predicate: predicate)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(packaging.name, displayMode: .inline)
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
    }
}
