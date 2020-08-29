//
//  NameGroupCodeNoteEditorSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 16.08.2020.
//

import SwiftUI
import CoreData

struct NameGroupCodeNoteEditorSection<T: Managed & Monikerable & GroupCodeNotable>: View {
    
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        Section(
            header: Text(T.entityName)
        ) {
            Group {
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group").hidden()
                        Text("Name")
                    }
                    .foregroundColor(.tertiary)
                    TextField("Name", text: $entity.name)
                }
                
                PickerWithTextField(selection: $entity.group, name: "Group", values: entity.groups)
                
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group").hidden()
                        Text("Code")
                    }
                    .foregroundColor(.tertiary)
                    TextField("Code", text: $entity.code)
                }
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group").hidden()
                        Text("Note")
                    }
                    .foregroundColor(.tertiary)
                    TextField("Note", text: $entity.note)
                }
            }
            .foregroundColor(.accentColor)
            //  .font(.subheadline)
        }
    }
}

struct NameGroupCodeNoteStringEditorSection: View {

    @Binding var name: String
    @Binding var group: String
    @Binding var code: String
    @Binding var note: String
    
    var body: some View {
        Section(
            header: Text("Details")
        ) {
            Group {
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group").hidden()
                        Text("Name")
                    }
                    .foregroundColor(.tertiary)
                    TextField("Name", text: $name)
                }
                
                PickerWithTextField(selection: $group, name: "Group", values: ["TBD"])
                
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group").hidden()
                        Text("Code")
                    }
                    .foregroundColor(.tertiary)
                    TextField("Code", text: $code)
                }
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group").hidden()
                        Text("Note")
                    }
                    .foregroundColor(.tertiary)
                    TextField("Note", text: $note)
                }
            }
            .foregroundColor(.accentColor)
        }
    }
}
