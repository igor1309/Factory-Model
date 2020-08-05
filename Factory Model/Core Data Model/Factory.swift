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
    
    var headcount: Int { divisions.reduce(0, { $0 + $1.headcount }) }
    
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
    var ingredients: [Ingredient] {
        bases
            .flatMap { $0.products }
            .compactMap { $0.base }
            .flatMap { $0.recipes }
            .filter { $0.qty > 0 }
            .compactMap { $0.ingredient }
    }
    var totalIngredientCostExVAT: Double {
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


extension Factory {
    
    static func createFactory1(in context: NSManagedObjectContext) -> Factory {
        //  MARK: - Factory 1
        
        let factory1 = Factory(context: context)
        factory1.name = "Сыроварня"
        factory1.note = "Тестовый проект"
        
        //  MARK: - Ingredients @ Factory 1
        
        let milk = Ingredient(context: context)
        milk.name = "Молоко натуральное"
        milk.priceExVAT = 30.0
        milk.vat = 10/100
        
        let dryMilk = Ingredient(context: context)
        dryMilk.name = "Сухое молоко"
        dryMilk.priceExVAT = 70
        dryMilk.vat = 10/100
        
        let calciumChloride = Ingredient(context: context)
        calciumChloride.name = "Хлористый кальций"
        calciumChloride.vat = 10/100
        
        let bacterialRefueling = Ingredient(context: context)
        bacterialRefueling.name = "Бактериальная заправка"
        bacterialRefueling.vat = 10/100
        
        let rennetFilling = Ingredient(context: context)
        rennetFilling.name = "Сычужная заправка (?)"
        rennetFilling.priceExVAT = 8000
        rennetFilling.vat = 10/100
        
        let pepsin = Ingredient(context: context)
        pepsin.name = "Пепсин"
        pepsin.vat = 10/100
        
        let salt = Ingredient(context: context)
        salt.name = "Соль"
        salt.priceExVAT = 20
        salt.vat = 10/100
        
        let water = Ingredient(context: context)
        water.name = "Вода"
        water.priceExVAT = 1
        water.vat = 10/100
        
        //            factory1.addToIngredients_(milk)
        //            factory1.addToIngredients_(dryMilk)
        //            factory1.addToIngredients_(calciumChloride)
        //            factory1.addToIngredients_(bacterialRefueling)
        //            factory1.addToIngredients_(rennetFilling)
        //            factory1.addToIngredients_(pepsin)
        //            factory1.addToIngredients_(salt)
        //            factory1.addToIngredients_(water)
        
        //  MARK: - Recipes for Base Product 1
        
        let recipe1 = Recipe(context: context)
        recipe1.qty = 1
        recipe1.ingredient = milk
        
        let recipe2 = Recipe(context: context)
        recipe2.qty = 1
        recipe2.ingredient = dryMilk
        
        let recipe5 = Recipe(context: context)
        recipe5.qty = 0.5 / 1000
        recipe5.ingredient = rennetFilling
        
        let recipe7 = Recipe(context: context)
        recipe7.qty = 1.5
        recipe7.ingredient = salt
        
        let recipe8 = Recipe(context: context)
        recipe8.qty = 1
        recipe8.ingredient = water
        
        //  MARK: - Base Product 1_1
        
        let base1_1 = Base(context: context)
        base1_1.name = "Сулугуни"
        base1_1.note = "Первый продукт"
        base1_1.code = "1001"
        base1_1.group = "Сыры"
        base1_1.customUnit = .weight
        base1_1.weightNetto = 1_000
        base1_1.recipes = [recipe1, recipe2, recipe5, recipe7, recipe8]
        base1_1.factory = factory1
        
        //  MARK: - Product 1_1
        
        let product1_1 = Product(context: context)
        product1_1.code = "У001"
        product1_1.name = "Ведёрко 1 кг"
        product1_1.note = "..."
        product1_1.baseQty = 1_000
        product1_1.base = base1_1
        product1_1.group = "Ведёрко"
        product1_1.vat = 10/100
        product1_1.productionQty = 3_000
        
        //  MARK: - Buyer 1_1
        let buyer1_1 = Buyer(context: context)
        buyer1_1.name_ = "Speelo Group"
        
        //  MARK: - Sales 1_1
        
        let sales1_1 = Sales(context: context)
        sales1_1.priceExVAT = 300
        sales1_1.qty = 1_000
        sales1_1.product = product1_1
        sales1_1.buyer = buyer1_1
        
        //  MARK: - Utility
        
        let utility1 = Utility(context: context)
        utility1.name = "Электроэнергия"
        utility1.priceExVAT = 10
        
        base1_1.utilities = [utility1]
        
        //  MARK: - Product 1_2
        
        let product1_2 = Product(context: context)
        product1_2.code = "У002"
        product1_2.name = "Вакуум"
        product1_2.note = "..."
        product1_2.baseQty = 750
        product1_2.base = base1_1
        product1_2.group = "Вакуум"
        product1_2.vat = 10/100
        
        //  MARK: - Base 2
        let recipe21 = Recipe(context: context)
        recipe21.qty = 2
        recipe21.ingredient = water
        
        
        let base2 = Base(context: context)
        base2.name = "Имеретинский"
        base2.code = "1002"
        base2.group = "Сыры"
        base2.addToRecipes_(recipe21)
        base2.factory = factory1
        
        let base3 = Base(context: context)
        base3.name = "Творог"
        base3.code = "2001"
        base3.group = "Твороги"
        base3.factory = factory1
        
        let divisions = Division.createDivisions(in: context)
        for division in divisions {
            factory1.addToDivisions_(division)
        }
        
        factory1.expenses = Expenses.createExpenses1(in: context)
        
        let equipment = Equipment(context: context)
        equipment.name = "Сырная линия"
        equipment.note = "Основная производственная линия"
        equipment.price = 7_000_000
        equipment.lifetime = 7
        
        factory1.equipments = [equipment]
        
        return factory1
    }
    
    static func createFactory2(in context: NSManagedObjectContext) -> Factory {
        let factory2 = Factory(context: context)
        factory2.name = "Полуфабрикаты"
        factory2.note = "Фабрика Полуфабрикатов: заморозка и прочее"
        
        let base2_1 = Base.createBase2_1(in: context)
        base2_1.factory = factory2
        
        let metro = Buyer(context: context)
        metro.name_ = "METRO"
        
        let metroSales = Sales(context: context)
        metroSales.buyer = metro
        metroSales.qty = 1_000
        metroSales.priceExVAT = 230
        
        let product2_1 = Product(context: context)
        product2_1.name = "Настоящие"
        product2_1.baseQty = 12
        product2_1.group = "Контейнер"
        product2_1.vat = 10/100
        
        product2_1.sales = [metroSales]
        product2_1.base = base2_1

        return factory2
    }
}
