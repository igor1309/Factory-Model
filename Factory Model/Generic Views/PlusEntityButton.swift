//
//  PlusEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import SwiftUI
import CoreData

struct PlusEntityButton<T: NSManagedObject & Managed & Samplable>: View {
    @Environment(\.managedObjectContext) var context
    
    var factory: Factory
    
    var body: some View {
        Button {
            let entity = T.create(in: context)
            entity.makeSample()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
