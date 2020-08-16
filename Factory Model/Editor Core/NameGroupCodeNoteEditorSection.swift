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
                
                //  MARK: - FINISH THIS
                //  как вернуть if к жизни????
//                if entity.groups.isEmpty {
                    HStack {
                        Text("Group")
                            .foregroundColor(.tertiary)
                        TextField("Group", text: $entity.group)
                            .foregroundColor(.accentColor)
                    }
//                } else {
//                    PickerWithTextField(selection: $entity.group, name: "Group", values: entity.entityGroups)
//                }
                
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
