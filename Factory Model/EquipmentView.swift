//
//  EquipmentView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    var equipment: Equipment
    var factory: Factory
    
    @State private var draft: Equipment
    
    init(equipment: Equipment, for factory: Factory) {
        self.equipment = equipment
        self.factory = factory
        _draft = State(initialValue: equipment)
    }
    
    var body: some View {
        List {
            Section(header: Text("Equipment")) {
                Group {
                    TextField("Name", text: $draft.name)
                    TextField("Name", text: $draft.note)
                    Text("TBD: lifetime: \(draft.lifetime, specifier: "%.f")")
                    Text("TBD: price: \(draft.price, specifier: "%.f")")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
    }
}

//struct EquipmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EquipmentView()
//    }
//}
