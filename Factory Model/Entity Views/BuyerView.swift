//
//  BuyerEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct BuyerView: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var buyer: Buyer
    
    init(_ buyer: Buyer) {
        self.buyer = buyer
        self.predicate = NSPredicate(format: "%K == %@", #keyPath(Sales.buyer), buyer)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            childType: Sales.self,
            title: buyer.name,
            predicate: predicate,
            plusButton: plusButton,
            dashboard: dashboard
        )
    }
    
    private func plusButton() -> some View {
        CreateChildButton(parent: buyer, keyPathToParent: \Sales.buyer)
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        Section(
            header: Text("Buyer Detail")
        ) {
            NavigationLink(
                destination: BuyerEditor(buyer)
            ) {
                ListRow(buyer, period: settings.period)
            }
        }
        
        ErrorMessage(buyer)
        
        Section(
            header: Text("Total Sales")
        ) {
            Text("TBD: Sales volumes and amount for the Buyer, list of Products")
                .foregroundColor(.systemRed)
        }
    }
}

struct BuyerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BuyerView(Buyer.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 560))
    }
}
