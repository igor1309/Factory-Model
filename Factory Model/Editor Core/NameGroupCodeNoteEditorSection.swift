//
//  NameGroupCodeNoteEditorSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 16.08.2020.
//

import SwiftUI
import CoreData

protocol GroupCodeNotable: NSManagedObject {
    dynamic var group_: String? { get set }
    dynamic var code_: String? { get set }
    dynamic var note_: String? { get set }
    
    var group: String { get set }
    var groups: [String] { get }
    var code: String { get set }
    var note: String { get set }
}
extension GroupCodeNotable {
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    var code: String {
        get { code_ ?? ""}
        set { code_ = newValue }
    }
    var group: String {
        get { group_ ?? ""}
        set { group_ = newValue }
    }
}

extension Base: GroupCodeNotable {}
extension Product: GroupCodeNotable {}

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
