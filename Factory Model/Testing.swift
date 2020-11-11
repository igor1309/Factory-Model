//
//  Testing.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI
import CoreData

struct Testing: View {
    @EnvironmentObject var persistence: PersistenceManager
    @EnvironmentObject var settings: Settings
    
    @FetchRequest(entity: Product.entity(), sortDescriptors: [], predicate: NSPredicate(format: "name_ == %@", "Ведёрко 1 кг")) private var products: FetchedResults<Product>
    
    var body: some View {
        List {
            PeriodPicker(period: $settings.period)
            
            Section {
                if let product = products.first {
                    NavigationLink(destination: ProductView(product)) {
                        ListRow(product, period: settings.period)
                    }
                } else {
                    Text("can't fetch product")
                }
            }
            
            Section {
                NavigationLink(destination: FactoryList()) {
                    Text("Factories")
                }
                
                EntityLinkToList<Factory>()
            }
            
            Section(
                header: Text("Main Entities"),
                footer: Text("Using View + Editor (via View).")
                
            ) {
                EntityLinkToList<Division>()
                EntityLinkToList<Department>()
                EntityLinkToList<Buyer>()
                EntityLinkToList<Product>()
                EntityLinkToList<Base>()
            }
            
            Section(
                header: Text("Many-to-many"),
                footer: Text("Subordinate. Not intended for direct use. No Entity View, using just Editor.")
            ) {
                EntityLinkToList<Sales>()
                EntityLinkToList<Recipe>()
            }
            
            Section(
                header: Text("Many parents"),
                footer: Text("Using View + Editor (via View).")
            ) {
                EntityLinkToList<Ingredient>()
                EntityLinkToList<Packaging>()
            }
            
            Section(
                header: Text("One parent"),
                footer: Text("No Entity View, using Editor.")
            ) {
                EntityLinkToList<Utility>()
                EntityLinkToList<Employee>()
                EntityLinkToList<Equipment>()
                EntityLinkToList<Expenses>()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Testing", displayMode: .inline)
        .navigationBarItems(
            leading: settingsButton,
            trailing: CreateEntityPickerButton()
        )
    }
    
    @State private var showSettings = false
    
    private var settingsButton: some View {
        Button {
            showSettings = true
        } label: {
            Image(systemName: "gear")
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(persistence)
                .environmentObject(settings)
        }
    }
}

struct Testing_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Testing()
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(PersistenceManager.preview)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 1250))
    }
}
