//
//  AllFeedstockListTESTING.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllFeedstockListTESTING: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var factory: Factory
    
    @State private var feedstocks: [Something]?
    { didSet { print(feedstocks as Any) }}
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            //  MARK: FINISH THIS!!!
            //    MARK: DISAPPEARING BLOCK _ CAN'T FINS ERROR
            if let feedstocks = feedstocks {
                Section(header: Text("Feedstocks")) {
                    ForEach(feedstocks) { feedstock in
                        Text("\(feedstock.title): \(feedstock.qty.formattedGrouped) \(feedstock.cost.formattedGrouped)")
                            .font(.subheadline)
                    }
                }
            }
            
        }
        //    MARK: DISAPPEARING BLOCK _ CAN'T FINS ERROR
        .onAppear(perform: fetchFeedstocks)
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Feedstock")
    }
    
    //  MARK: DISAPPEARING BLOCK _ CAN'T FINS ERROR
    func fetchFeedstocks() {
        //        Factory.fetchFeedstocksTotalsGrouped(context: managedObjectContext) {
        //        factory.fetchFeedstocksTotalsGrouped { results in
        Factory.fetchFeedstocksTotalsGrouped(context: managedObjectContext) { results in
            feedstocks = results
        }
    }
}

//struct AllFeedstockListTESTING_Previews: PreviewProvider {
//    static var previews: some View {
//        AllFeedstockListTESTING()
//    }
//}
