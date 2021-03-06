//
//  CreateOrphanButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI
import CoreData

fileprivate struct CreateOrphanButton<Child: Managed & Summarizable & Sketchable>: View {
    
    @Environment(\.managedObjectContext) private var context
    
    let systemName: String
    /// use this init to create orphans (no parent entities)
    /// - Parameter type: type of the Entity to be created
    init(systemName: String? = nil) {
        self.systemName = systemName ?? Child.plusButtonIcon
    }
    
    var body: some View {
        Button {
            let haptics = Haptics()
            haptics.feedback()
            
            withAnimation {
                let child = Child(context: context)
                child.makeSketch()
                
                context.saveContext()
            }
        } label: {
            Image(systemName: systemName)
                .padding([.leading, .vertical])
        }
    }
}


fileprivate struct CreateOrphanButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color
                .blue
                .opacity(0.2)
                .padding()
                .navigationBarTitle("Create Orphan Button", displayMode: .inline)
                .navigationBarItems(
                    trailing: HStack {
                        CreateOrphanButton<Base>()
                        CreateOrphanButton<Base>(systemName: "plus.circle")
                    }
                )
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
