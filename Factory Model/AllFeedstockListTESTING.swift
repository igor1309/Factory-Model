//
//  AllFeedstockListTESTING.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllFeedstockListTESTING: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    @State private var feedstocks: [Something]?
    //    { didSet { print(feedstocks as Any) }}
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            //  MARK: FINISH THIS!!!
            if let feedstocks = feedstocks {
                Section(
                    header: Text("Feedstocks")
                ) {
                    ForEach(feedstocks) { feedstock in
                        LabelWithDetail(feedstock.title, "\(feedstock.qty.formattedGrouped) \(feedstock.cost.formattedGrouped)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear(perform: fetchFeedstocks)
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Feedstock")
    }
    
    func fetchFeedstocks() {
        //        Factory.fetchFeedstocksTotalsGrouped(context: context) {
        //        factory.fetchFeedstocksTotalsGrouped { results in
//        Factory.fetchFeedstocksTotalsGrouped(context: moc) { results in
//            feedstocks = results
//        }
    }
}

//struct AllFeedstockListTESTING_Previews: PreviewProvider {
//    static var previews: some View {
//        AllFeedstockListTESTING()
//    }
//}
