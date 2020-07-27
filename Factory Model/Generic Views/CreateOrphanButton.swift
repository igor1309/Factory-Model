//
//  CreateOrphanButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import SwiftUI

struct CreateOrphanButton<T: PickableEntity>: View {
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        Button {
            let entity = T.create(in: context)
            entity.name = " New"
            context.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
