//
//  Factories Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import CoreData

extension Factory {
    
    static var example: Factory {
        let preview = PersistenceManager.previewContext
        let request = NSFetchRequest<Factory>(entityName: "Factory")
        request.predicate = NSPredicate(format: "name_ == %@", "Сыроварня")
        let factories = try? preview.fetch(request)
        if let factory = factories?.first {
            return factory
        } else {
            return Factory.createFactory1(in: preview)
        }
    }
    
    static func createFactory1(in context: NSManagedObjectContext) -> Factory {
        
        //  MARK: - Factory 1
        
        let factory1 = Factory(context: context)
        factory1.name = "Сыроварня"
        factory1.note = "Тестовый проект"
        factory1.profitTaxRate = 20/100
        factory1.salaryBurdenRate = 30.2/100
        
        
        //  MARK: - Base Products
        
        let bases = Base.createFactory1Bases(in: context)
        for base in bases {
            base.factory = factory1
        }
        
        
        //  MARK: - Product 1_1
        
        let product1_1 = Product(context: context)
        product1_1.code = "У001"
        product1_1.name = "Ведёрко 1 кг"
        product1_1.note = "..."
        product1_1.baseQty = 1
        product1_1.base = bases[0]//base1_1
        product1_1.group = "Ведёрко"
        product1_1.vat = 10/100
        product1_1.productionQty = 3_000
        
        product1_1.packaging = Packaging(context: context)
        product1_1.packaging?.name = "P1"
        product1_1.packaging?.type = "p01"
        
        
        //  MARK: Buyer 1_1
        
        let buyer1_1 = Buyer(context: context)
        buyer1_1.name_ = "Speelo Group"
        
        
        //  MARK: Sales 1_1
        
        let sales1_1 = Sales(context: context)
        sales1_1.priceExVAT = 300
        sales1_1.qty = 1_000
        sales1_1.product = product1_1
        sales1_1.buyer = buyer1_1
        
        
        //  MARK: - Product 1_2
        
        let product1_2 = Product(context: context)
        product1_2.code = "У002"
        product1_2.name = "Вакуум"
        product1_2.note = "..."
        product1_2.baseQty = 750
        product1_2.base = bases[0]//base1_1
        product1_2.coefficientToParentUnit = 1/1_000
        product1_2.group = "Вакуум"
        product1_2.vat = 10/100
        
        product1_2.packaging = Packaging(context: context)
        product1_2.packaging?.name = "P2"
        product1_2.packaging?.type = "p02"
        
        
        //  MARK: - Employees
        
        let divisions = Division.createSampleDivisions(in: context)
        for division in divisions {
            factory1.addToDivisions_(division)
        }
        
        
        //  MARK: - Expenses
        
        factory1.expenses = Expenses.createExpenses1(in: context)
        
        
        //  MARK: - Equipment
        
        let equipment = Equipment.createSampleEquipment(in: context)
        equipment.factory = factory1
        
        
        context.saveContext()
        
        return factory1
    }
    
    
    static func createFactory2(in context: NSManagedObjectContext) -> Factory {
        let factory2 = Factory(context: context)
        factory2.name = "Полуфабрикаты"
        factory2.note = "Фабрика Полуфабрикатов: заморозка и прочее"
        factory2.profitTaxRate = 20/100
        factory2.salaryBurdenRate = 30.2/100
        
        let base2_1 = Base.createBaseKhinkali(in: context)
        base2_1.factory = factory2
        
        let metro = Buyer(context: context)
        metro.name_ = "METRO"
        
        let metroSales = Sales(context: context)
        metroSales.buyer = metro
        metroSales.qty = 1_000
        metroSales.priceExVAT = 230
        
        let product2_1 = Product.createProduct2_1(in: context)
        product2_1.sales = [metroSales]
        product2_1.base = base2_1
        
        context.saveContext()
        
        return factory2
    }
}
