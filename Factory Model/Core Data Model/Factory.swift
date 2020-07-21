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
    
    
    func salaryForDivision(_ division: String) -> Double {
        staff
            .filter { $0.division == division }
            .map { $0.salary }
            .reduce(0, +)
    }
    func salaryForDivisionWithTax(_ division: String) -> Double {
        salaryForDivision(division) * 1.302
    }
    
    var equipmentTotal: Double {
        equipment
            .map { $0.price }
            .reduce(0, +)
    }
    var amortizationMonthly: Double {
        equipment
            .map { $0.price / ($0.lifetime > 0 ? $0.lifetime : 1) / 12 }
            .reduce(0, +)
    }
    
    var expensesTotal: Double {
        expenses
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var revenueExVAT: Double {
        products
            .map { $0.revenueExVAT }
            .reduce(0, +)
    }
    
    
    //  MARK: FINISH THIS DICTIONARY
    //  THATS A SAMPLE FOR STAFF, ets
    var productGroups: [Row] {
        Dictionary(grouping: products) { $0.group }
            .mapValues { $0.map { $0.name }.joined(separator: ", ") }
            .map { Row(title: $0, subtitle: $1, detail: "TBD: Total production & revenue".uppercased(), icon: "bag") }
            .sorted()
    }
    var divisions: [Row] {
        Dictionary(grouping: staff) { $0.division }
            .mapValues { $0.map { $0.department }.removingDuplicates().joined(separator: ", ") }
            .map { Row(title: $0, subtitle: $1 + " TBD: count", detail: "TBD: Total salary".uppercased(), icon: "person.2") }
            .sorted()
    }

}
