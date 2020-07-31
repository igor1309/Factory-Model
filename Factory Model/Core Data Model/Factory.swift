//
//  Factory.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation
import CoreData

extension Factory {
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    var buyers: [Buyer] {
        get { (buyers_ as? Set<Buyer> ?? []).sorted() }
        set { buyers_ = Set(newValue) as NSSet }
    }
    var workers: [Worker] {
        divisions.flatMap { $0.departments }.flatMap { $0.workers }
    }
    var equipments: [Equipment] {
        get { (equipments_ as? Set<Equipment> ?? []).sorted() }
        set { equipments_ = Set(newValue) as NSSet }
    }
    var bases: [Base] {
        get { (bases_ as? Set<Base> ?? []).sorted() }
        set { bases_ = Set(newValue) as NSSet }
    }
    var packagings: [Packaging] {
        bases.flatMap { $0.products }.compactMap { $0.packaging }
    }
    var expenses: [Expenses] {
        get { (expenses_ as? Set<Expenses> ?? []).sorted() }
        set { expenses_ = Set(newValue) as NSSet }
    }
    var buyerNames: [String] {
        bases
            .flatMap { $0.products }
            .flatMap { $0.sales }
            .compactMap { $0.buyerName }
            .removingDuplicates()
    }
    var divisions: [Division] {
        get { (divisions_ as? Set<Division> ?? []).sorted() }
        set { divisions_ = Set(newValue) as NSSet }
    }
    var divisionNames: String {
        divisions
            .map { $0.name }
            .joined(separator: ", ")
    }
    
    var workerByDivision: [String: [Division]] {
        Dictionary(grouping: divisions) { $0.name }
    }
    var departments: [String] {
        divisions
            .flatMap { $0.departments }
            .map { $0.name }
            .removingDuplicates()
            .sorted()
    }
    func headcount(for division: Division) -> Int {
        divisions
            .filter { $0 == division }
            .flatMap { $0.departments }
            .flatMap { $0.workers }
            .count
    }
    func departmentNames(for division: Division) -> String {
        divisions
            .filter { $0 == division }
            .flatMap { $0.departments }
            .map { $0.name }
            .removingDuplicates()
            .joined(separator: ", ")
    }
    
    var totalSalary: Double {
        divisions
            .flatMap { $0.departments }
            .flatMap { $0.workers }
            .map { $0.salary }
            .reduce(0, +)
    }
    var totalSalaryWithTax: Double {
        divisions
            .flatMap { $0.departments }
            .flatMap { $0.workers }
            .map { $0.salaryWithTax }
            .reduce(0, +)
    }
    func totalSalary(for division: Division) -> Double {
        divisions
            .filter { $0 == division }
            .flatMap { $0.departments }
            .flatMap { $0.workers }
            .map { $0.salary }
            .reduce(0, +)
    }
    func totalSalaryWithTax(for division: Division) -> Double {
        divisions
            .filter { $0 == division }
            .flatMap { $0.departments }
            .flatMap { $0.workers }
            .map { $0.salaryWithTax }
            .reduce(0, +)
    }
    
    var equipmentTotal: Double {
        equipments
            .map { $0.price }
            .reduce(0, +)
    }
    //  MARK: more clever depreciation?
    var depreciationMonthly: Double {
        equipments
            .map { $0.depreciationMonthly }
            .reduce(0, +)
    }
    
    var expensesTotal: Double {
        expenses
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var revenueExVAT: Double {
        bases
            .flatMap { $0.products }
            .map { $0.revenueExVAT }
            .reduce(0, +)
    }
    
    func revenueExVAT(for group: String) -> Double {
        bases
            .flatMap { $0.products }
            .compactMap { $0.base }
            .filter { $0.group == group }
            .map { $0.revenueExVAT }
            .reduce(0, +)
    }

    var totalCostExVAT: Double {
        bases
            .flatMap { $0.products }
            .compactMap { $0.base }
            .map { $0.totalCostExVAT }
            .reduce(0, +)
    }
    
    var baseGroupsAsRows: [Something] {
        Dictionary(grouping: bases) { $0.group }
            .mapValues { $0.map { $0.name }.joined(separator: ", ") }
            .map {
                Something(
                    id: UUID(),
                    title: $0,
                    qty: 0,
                    cost: 0,
                    detail: $1//,
                    //icon: "bag"
                )
            }
            .sorted()
    }
    
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    var baseGroups: [String] {
        bases
            .flatMap { $0.products }
            .compactMap { $0.base }
            .map { $0.group }
            .removingDuplicates()
            .sorted()
    }
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    func basesForGroup(_ group: String) -> [Base] {
        bases
            .flatMap { $0.products }
            .compactMap { $0.base }
            .filter { $0.group == group }
            .sorted()
    }
    
    //  MARK: FIX THIS: неоптимально — мне нужно с помощью FetchRequest вытащить список имеющихся групп продуктов для выбранной фабрики
    var packagingTypes: [String] {
        bases
            .flatMap { $0.products }
            .compactMap { $0.packaging }
            .map { $0.type }
            .removingDuplicates()
            .sorted()
    }
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    func packagingsForType(_ type: String) -> [Packaging] {
        bases
            .flatMap { $0.products }
            .compactMap { $0.packaging }
            .filter { $0.type == type }
            .sorted()
    }

    
    //  MARK: FIX THIS: неоптимально — мне нужно с помощью FetchRequest вытащить список имеющихся групп продуктов для выбранной фабрики
    var productGroups: [String] {
        bases
            .flatMap { $0.products }
            .map { $0.group }
            .removingDuplicates()
            .sorted()
    }
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    func productForType(_ group: String) -> [Product] {
        bases
            .flatMap { $0.products }
            .filter { $0.group == group }
            .sorted()
    }
    
    var sales: [Sales] {
        buyers
            .flatMap { $0.sales }
    }
    var feedstocks: [Feedstock] {
        bases
            .flatMap { $0.products }
            .compactMap { $0.base }
            .flatMap { $0.ingredients }
            .filter { $0.qty > 0 }
            .compactMap { $0.feedstock }
    }
    var totalFeedstockCostExVAT: Double {
        bases
            .flatMap { $0.products }
            .compactMap { $0.base }
            .reduce(0) { $0 + $1.totalCostExVAT }
    }
    
    //  as in Stanford CS193p Lecture #12
    static func withName(_ name: String, context: NSManagedObjectContext) -> Factory? {
        // look up in Core Data
        let request = fetchRequest(
            NSPredicate(format: "name_ = %@", name)
        )
        let factories = (try? context.fetch(request)) ?? []
        return factories.first
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Factory> {
        let request = NSFetchRequest<Factory>(entityName: "Factory")
        request.sortDescriptors = Factory.defaultSortDescriptors
        request.predicate = predicate
        return request
    }
    

    
//    func feedstocksByGroups() -> [Something] {
//        
//        let feedstocksByGroups = Dictionary(grouping: feedstocks) { $0.name }
//        
//        let somethings = feedstocksByGroups
//            .mapValues { feedstocks -> (qty: Double, cost: Double, bases: [String]) in
//                
//                let qty = feedstocks.reduce(0, { $0 + $1.qty * $1.baseQty })
//                let costExVAT = feedstocks.reduce(0, { $0 + $1.costExVAT * $1.baseQty })
//                
//                let bases = feedstocks.reduce([String]()) { $0 + [$1.baseName]  }
//                
//                return (qty: qty, cost: costExVAT, bases: bases)
//            }
//            .map {
//                Something(
//                    id: UUID(),
//                    title: $0.key,
//                    qty: $0.value.qty,
//                    cost: $0.value.cost,
//                    detail: $0.value.bases.joined(separator: ", ")
//                )
//            }
//            .filter { $0.qty > 0 }
//            .sorted()
//        
//        return somethings
//    }
}
 





extension Factory {
    
    //  MARK: NOT WORKING IDEALLY
    //  HOW TO FILTER ON FACTORY???
    ///https://www.alfianlosari.com/posts/building-expense-tracker-ios-app-with-core-data-and-swiftui/
//    static func fetchFeedstocksTotalsGrouped(
//        context: NSManagedObjectContext,
//        completion: @escaping ([Something]) -> ()
//    ) {
//        let keypathQty = NSExpression(forKeyPath: \Feedstock.ingredients_.qty)
//        let expression = NSExpression(forFunction: "sum:", arguments: [keypathQty])
//        
//        let sumDesc = NSExpressionDescription()
//        sumDesc.expression = expression
//        sumDesc.name = "sum"
//        sumDesc.expressionResultType = .decimalAttributeType
//        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Feedstock.entity().name ?? "Feedstock")
//        request.predicate = NSPredicate(format: "qty > 0")
//        request.returnsObjectsAsFaults = false
//        request.propertiesToGroupBy = ["name_"]
//        request.propertiesToFetch = [sumDesc, "name_"]
//        request.resultType = .dictionaryResultType
//        
//        context.perform {
//            do {
//                let results = try request.execute()
//                let data = results.map { result -> Something? in
//                    guard
//                        let resultDict = result as? [String: Any],
//                        let qty = resultDict["sum"] as? Double,
//                        let name = resultDict["name_"] as? String else
//                    { return nil }
//                    
//                    return Something(id: UUID(), title: name, qty: qty, cost: 0, detail: nil)
//                }
//                .compactMap { $0 }
//                
//                completion(data)
//                
//            } catch let error as NSError {
//                print((error.localizedDescription))
//                completion([])
//            }
//        }
//    }
}
