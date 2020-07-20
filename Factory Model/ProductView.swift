//
//  ProductView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct ProductView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation

//    var product: Product
    
    @State private var draft: Product
    
    init(_ product: Product) {
        _draft = State(initialValue: product)
    }
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $draft.name)
                TextField("Note", text: $draft.note)
                TextField("Code", text: $draft.code)
                TextField("Group", text: $draft.group)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            //  MARK: FINISH THIS
            
            save()
            presentation.wrappedValue.dismiss()
        }
    }
    
    private func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(Product())
    }
}
