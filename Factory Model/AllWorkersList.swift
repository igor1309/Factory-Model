//
//  AllWorkersList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct AllWorkersList: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            title: "All Workers",
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Worker.department.division.factory), factory
            )
        ) {
            //  MARK: - FINISH THIS FUGURE OUT HOW TO CREATE ENTITY HERE
            EmptyView()
            /*
            CreateChildButton(
                systemName: "cart.badge.plus",
                childType: Worker.self, parent: factory,
                keyPath: \Factory.workers_
            ) */
        } dashboard: {
            
        } editor: { (worker: Worker) in
            WorkerView(worker)
        }
    }
}
