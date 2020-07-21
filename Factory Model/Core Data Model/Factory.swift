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
        get { (staff_ as? Set<Staff> ?? []).sorted() }
        set { staff_ = Set(newValue) as NSSet }
    }
    var staffByDivision: [String: [Staff]] {
        Dictionary(grouping: staff) { $0.division }
    }
    var divisions: [String] {
        staff
            .map { $0.division }
            .removingDuplicates()
            .sorted()
    }
    func totalSalary(for division: String) -> Double {
        staff
            .filter { $0.division == division }
            .map { $0.salary }
            .reduce(0, +)
    }
    func headcount(for division: String) -> Int {
        staff
            .filter { $0.division == division }
            .count
    }
    func departments(for division: String) -> String {
        staff
            .filter { $0.division == division }
            .map { $0.department }
            .removingDuplicates()
            .joined(separator: ", ")
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
    var totalSalary: Double {
        staff
            .map { $0.salary }
            .reduce(0, +)
    }
    var totalSalaryWithTax: Double {
        totalSalary * 1.302
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
    
    var totalCost: Double {
        products
            .map { $0.totalCost }
            .reduce(0, +)
    }
    
    var productGroups: [Row] {
        Dictionary(grouping: products) { $0.group }
            .mapValues { $0.map { $0.name }.joined(separator: ", ") }
            .map { Row(title: $0, subtitle: $1, detail: "TBD: Total production & revenue".uppercased(), icon: "bag") }
            .sorted()
    }
    
    
    var sales: [Sales] {
        products
            .flatMap { $0.sales }
    }
}
