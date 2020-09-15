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
    var equipments: [Equipment] {
        get { (equipments_ as? Set<Equipment> ?? []).sorted() }
        set { equipments_ = Set(newValue) as NSSet }
    }
    var bases: [Base] {
        get { (bases_ as? Set<Base> ?? []).sorted() }
        set { bases_ = Set(newValue) as NSSet }
    }
    var expenses: [Expenses] {
        get { (expenses_ as? Set<Expenses> ?? []).sorted() }
        set { expenses_ = Set(newValue) as NSSet }
    }
    
    
    func basesDetail(in period: Period) -> String {
        let produced = bases
            .filter { $0.productionQty(in: period) > 0 }
            .map {
                "\($0.name) (\($0.productionQty(in: period).formattedGrouped) \($0.customUnitString))"
            }
            .joined(separator: ", ")
        
        let notProduced = bases
            .filter { $0.productionQty(in: period) == 0 }
            .map(\.name)
            .joined(separator: ", ")
        
        return [produced, notProduced].joined(separator: "\n")
    }
    
    func productsDetail(in period: Period) -> String {
        let products = bases.flatMap { $0.products }

        let sold = products
            .filter { $0.salesQty(in: period) > 0 }
            .map {
                "\($0.title(in: period)) (sales \($0.salesQty(in: period).formattedGrouped) of \($0.productionQty(in: period).formattedGrouped) production)"
            }
            .joined(separator: ", ")
        
        let unsold = products
            .filter { $0.salesQty(in: period) == 0 }
            .map { "\($0.title(in: period))" }
            .joined(separator: ", ")
        
        return [sold, unsold].joined(separator: "\n")
    }
    
    
    var buyerNames: [String] {
        bases
            .flatMap(\.products)
            .flatMap(\.sales)
            .compactMap { $0.buyerName }
            .removingDuplicates()
    }

    var packagings: [Packaging] {
        bases
            .flatMap(\.products)
            .compactMap(\.packaging)
    }
    var packagingDetail: String {
        "\(packagings.count.formattedGrouped) kinds: \(packagingNames)"
    }
    var packagingNames: String {
        packagings.map { $0.name }.joined(separator: ", ")
    }
    
    
    //  MARK: - Weight Netto
    
    func salesWeightNetto(in period: Period) -> Double {
        bases.reduce(0) { $0 + $1.salesWeightNetto(in: period) }
    }
    func productionWeightNetto(in period: Period) -> Double {
        bases.reduce(0) { $0 + $1.productionWeightNetto(in: period) }
    }
    
    
    //  MARK: - Equipment
    
    var equipmentTotal: Double {
        equipments
            .map(\.price)
            .reduce(0, +)
    }
    //  MARK: more clever depreciation?
    var depreciationMonthly: Double {
        equipments
            .map(\.depreciationMonthly)
            .reduce(0, +)
    }
    func depreciationMonthlyPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? depreciationMonthly / revenue : nil
    }

    
    //  MARK: - Expenses
    
    func expensesExVAT(in period: Period) -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    func expensesExVATPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? expensesExVAT(in: period) / revenue : nil
    }
    
    
    //  MARK: - Averages
    
    func avgPricePerKiloExVAT(in period: Period) -> Double {
        let weight = salesWeightNetto(in: period)
        return weight == 0 ? 0 : revenueExVAT(in: period) / weight / 1_000
    }
    func avgCostPerKiloExVAT(in period: Period) -> Double {
        let weight = productionWeightNetto(in: period)
        return weight == 0 ? 0 : productionCostExVAT(in: period) / weight / 1_000
    }
    func avgMarginPerKiloExVAT(in period: Period) -> Double {
        avgPricePerKiloExVAT(in: period) - avgCostPerKiloExVAT(in: period)
    }


    var baseGroupsAsRows: [Something] {
        Dictionary(grouping: bases) { $0.group }
            .mapValues {
                $0.map(\.name).joined(separator: ", ")
            }
            .map {
                Something(
                    id: UUID(),
                    title: $0,
                    detail: $1,
                    qty: 0,
                    cost: 0//,
                    //icon: "bag"
                )
            }
            .sorted()
    }
    
    
    
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    var baseGroups: [String] {
        bases
            .flatMap(\.products)
            .compactMap(\.base)
            .map(\.group)
            .removingDuplicates()
            .sorted()
    }
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    func basesForGroup(_ group: String) -> [Base] {
        bases
            .flatMap(\.products)
            .compactMap(\.base)
            .filter { $0.group == group }
            .sorted()
    }
    
    //  MARK: FIX THIS: неоптимально — мне нужно с помощью FetchRequest вытащить список имеющихся групп продуктов для выбранной фабрики
    var packagingTypes: [String] {
        bases
            .flatMap(\.products)
            .compactMap(\.packaging)
            .map(\.type)
            .removingDuplicates()
            .sorted()
    }
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    func packagingsForType(_ type: String) -> [Packaging] {
        bases
            .flatMap(\.products)
            .compactMap(\.packaging)
            .filter { $0.type == type }
            .sorted()
    }

    
    //  MARK: FIX THIS: неоптимально — мне нужно с помощью FetchRequest вытащить список имеющихся групп продуктов для выбранной фабрики
    var productGroups: [String] {
        bases
            .flatMap(\.products)
            .map(\.group)
            .removingDuplicates()
            .sorted()
    }
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    func productForType(_ group: String) -> [Product] {
        bases
            .flatMap(\.products)
            .filter { $0.group == group }
            .sorted()
    }
    
    var sales: [Sales] { buyers.flatMap(\.sales) }
    
    var ingredients: [Ingredient] {
        bases
            .flatMap(\.products)
            .compactMap(\.base)
            .flatMap(\.recipes)
            .filter { $0.qty > 0 }
            .compactMap(\.ingredient)
    }
    func ingredientsDetail(in period: Period) -> String {
        "Total Cost ex VAT of \(ingredients.count) Ingredients used in Production \(productionIngredientCostExVAT(in: period).formattedGrouped)"
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
    

    
//    func ingredientsByGroups() -> [Something] {
//        
//        let ingredientsByGroups = Dictionary(grouping: ingredients) { $0.name }
//        
//        let somethings = ingredientsByGroups
//            .mapValues { ingredients -> (qty: Double, cost: Double, bases: [String]) in
//                
//                let qty = ingredients.reduce(0, { $0 + $1.qty * $1.baseQty })
//                let costExVAT = ingredients.reduce(0, { $0 + $1.costExVAT * $1.baseQty })
//                
//                let bases = ingredients.reduce([String]()) { $0 + [$1.baseName]  }
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
//    static func fetchIngredientsTotalsGrouped(
//        context: NSManagedObjectContext,
//        completion: @escaping ([Something]) -> ()
//    ) {
//        let keypathQty = NSExpression(forKeyPath: \Ingredient.recipes_.qty)
//        let expression = NSExpression(forFunction: "sum:", arguments: [keypathQty])
//        
//        let sumDesc = NSExpressionDescription()
//        sumDesc.expression = expression
//        sumDesc.name = "sum"
//        sumDesc.expressionResultType = .decimalAttributeType
//        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Ingredient.entity().name ?? "Ingredient")
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


