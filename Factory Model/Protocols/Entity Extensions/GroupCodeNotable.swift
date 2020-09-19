//
//  GroupCodeNotable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.08.2020.
//

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

