//
//  Department.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.07.2020.
//

import Foundation

extension Department: Comparable {
    var name: String {
        get { name_ ?? "Unknown" }
        set { name_ = newValue }
    }
    var division: String {
        get { division_ ?? "No Division" }
        set { division_ = newValue }
    }
    
    var staffs: [Staff] {
        get { (staffs_ as? Set<Staff> ?? []).sorted() }
        set { staffs_ = Set(newValue) as NSSet }
    }

    
    enum DepartmentType: String, CaseIterable {
        case production, sales, procurement, management
    }
    var type: DepartmentType {
        get { DepartmentType(rawValue: type_ ?? DepartmentType.production.rawValue) ?? .production }
        set { type_ = newValue.rawValue }
    }
    
    public static func < (lhs: Department, rhs: Department) -> Bool {
        lhs.name < rhs.name
    }
}
