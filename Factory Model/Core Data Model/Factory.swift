//
//  Factory.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Factory {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? "Unknown"}
        set { note_ = newValue }
    }
    var equipment: [Equipment] {
        get { (equipment_ as? Set<Equipment> ?? []).sorted() }
        set { equipment_ = Set(newValue) as NSSet }
    }
    var expenses: [Expenses] {
        get { (expenses_ as? Set<Expenses> ?? []).sorted() }
        set { expenses_ = Set(newValue) as NSSet }
    }
    var products: [Product] {
        get { (products_ as? Set<Product> ?? []).sorted() }
        set { products_ = Set(newValue) as NSSet }
    }
    var staff: [Staff] {
        get { (staff_ as? Set<Staff> ?? []).sorted {
            $0.division < $1.division
                && $0.department < $1.department
                && $0.position < $1.position
                && $0.name < $1.name
        } }
        set { staff_ = Set(newValue) as NSSet }
    }
    
    //  MARK: FINISH THIS DICTIONARY
    //  THATS A SAMPLE FOR STAFF, ets
    var productGroups: [Row] {
        Dictionary(grouping: products) { $0.group }
            .mapValues { $0.map { $0.name }.joined(separator: ", ") }
            .map { Row(title: $0, subtitle: $1) }
            .sorted()
    }
    var divisions: [Row] {
        Dictionary(grouping: staff) { $0.division }
            .mapValues { $0.map { $0.department }.removingDuplicates().joined(separator: ", ") }
            .map { Row(title: $0, subtitle: $1) }
            .sorted()
    }

}

struct Row: Identifiable, Hashable, Comparable {
    var title: String
    var subtitle: String
    
    var id: String { title }
    
    static func < (lhs: Row, rhs: Row) -> Bool {
        lhs.title < rhs.title
    }
}

