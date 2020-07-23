//
//  Factory.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation
import CoreData

extension Factory {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    var equipments: [Equipment] {
        get { (equipments_ as? Set<Equipment> ?? []).sorted() }
        set { equipments_ = Set(newValue) as NSSet }
    }
    var expenses: [Expenses] {
        get { (expenses_ as? Set<Expenses> ?? []).sorted() }
        set { expenses_ = Set(newValue) as NSSet }
    }
    var products: [Product] {
        get { (products_ as? Set<Product> ?? []).sorted() }
        set { products_ = Set(newValue) as NSSet }
    }
    var buyers: [String] {
        products
            .flatMap { $0.sales }
            .compactMap { $0.buyer }
            .removingDuplicates()
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
        equipments
            .map { $0.price }
            .reduce(0, +)
    }
    var amortizationMonthly: Double {
        equipments
            .map { $0.amortizationMonthly }
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
    
    func revenueExVAT(for group: String) -> Double {
        products
            .filter { $0.group == group }
            .map { $0.revenueExVAT }
            .reduce(0, +)
    }
    
    var totalCost: Double {
        products
            .map { $0.totalCost }
            .reduce(0, +)
    }
    
    var productGroupsAsRows: [Something] {
        Dictionary(grouping: products) { $0.group }
            .mapValues { $0.map { $0.name }.joined(separator: ", ") }
            .map {
                Something(
                    id: UUID(),
                    title: $0,
                    qty: 0,
                    cost: 0,
                    detail: $1,
                    icon: "bag"
                )
            }
            .sorted()
    }
    
    var productGroups: [String] {
        products
            .map { $0.group }
            .removingDuplicates()
            .sorted()
    }

    func productsForGroup(_ group: String) -> [Product] {
        products
            .filter { $0.group == group }
            .sorted()
    }

    var sales: [Sales] {
        products
            .flatMap { $0.sales }
    }
    var feedstocks: [Feedstock] {
        products
            .flatMap { $0.feedstocks }
            .filter { $0.qty > 0 }
    }
    var totalFeedstockCost: Double {
        products
            .reduce(0) { $0 + $1.totalCost }
    }
    
    func feedstocksByGroups() -> [Something] {
        
        let feedstocksByGroups = Dictionary(grouping: feedstocks) { $0.name }
        
        let somethings = feedstocksByGroups
            .mapValues { feedstocks -> (qty: Double, cost: Double, products: [String]) in
                
                let qty = feedstocks.reduce(0, { $0 + $1.qty * $1.productionQty })
                let cost = feedstocks.reduce(0, { $0 + $1.cost * $1.productionQty })
                
                let products = feedstocks.reduce([String]()) { $0 + [$1.productName]  }
                
                return (qty: qty, cost: cost, products: products)
            }
            .map {
                Something(
                    id: UUID(),
                    title: $0.key,
                    qty: $0.value.qty,
                    cost: $0.value.cost,
                    detail: $0.value.products.joined(separator: ", ")
                )
            }
            .filter { $0.qty > 0 }
            .sorted()
        
        return somethings
    }
}
 





extension Factory {
    
    //  MARK: NOT WORKING IDEALLY
    //  HOW TO FILTER ON FACTORY???
    ///https://www.alfianlosari.com/posts/building-expense-tracker-ios-app-with-core-data-and-swiftui/
    static func fetchFeedstocksTotalsGrouped(
        context: NSManagedObjectContext,
        completion: @escaping ([Something]) -> ()
    ) {
        let keypathQty = NSExpression(forKeyPath: \Feedstock.qty)
        let expression = NSExpression(forFunction: "sum:", arguments: [keypathQty])
        
        let sumDesc = NSExpressionDescription()
        sumDesc.expression = expression
        sumDesc.name = "sum"
        sumDesc.expressionResultType = .decimalAttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Feedstock.entity().name ?? "Feedstock")
        request.predicate = NSPredicate(format: "qty > 0")
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["name_"]
        request.propertiesToFetch = [sumDesc, "name_"]
        request.resultType = .dictionaryResultType
        
        context.perform {
            do {
                let results = try request.execute()
                let data = results.map { result -> Something? in
                    guard
                        let resultDict = result as? [String: Any],
                        let qty = resultDict["sum"] as? Double,
                        let name = resultDict["name_"] as? String else
                    { return nil }
                    
                    return Something(id: UUID(), title: name, qty: qty, cost: 0, detail: nil)
                }
                .compactMap { $0 }
                
                completion(data)
                
            } catch let error as NSError {
                print((error.localizedDescription))
                completion([])
            }
        }
    }
}
