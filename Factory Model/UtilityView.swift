//
//  UtilityView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    var utility: Utility
    
    @State private var draft: Utility
    
    init(_ utility: Utility) {
        self.utility = utility
        _draft = State(initialValue: utility)
    }
    
    var body: some View {
        List {
            Section(header: Text("".uppercased())) {
                TextField("Name", text: $draft.name)
                Text("TBD: Salary: \(draft.price, specifier: "%.f")")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
    }
}

//struct UtilityView_Previews: PreviewProvider {
//    static var previews: some View {
//        UtilityView()
//    }
//}
