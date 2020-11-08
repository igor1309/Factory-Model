//
//  Product Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.10.2020.
//

import CoreData

extension Product {
    
    static var example: Product {
        let preview = PersistenceManager.previewContext
        let request = NSFetchRequest<Product>(entityName: "Product")
        request.predicate = NSPredicate(format: "name_ == %@", "Ведёрко 1 кг")
        let products = try? preview.fetch(request)
        if let product = products?.first {
            return product
        } else {
            return Product.createProduct2_1(in: preview)
        }
    }
    
    static func createProduct2_1(in context: NSManagedObjectContext) -> Product {
        let product2_1 = Product(context: context)
        product2_1.name = "Настоящие"
        product2_1.code = "2001"
        product2_1.baseQty = 12
        product2_1.group = "Контейнер"
        product2_1.vat = 10/100
        
        product2_1.packaging = Packaging(context: context)
        product2_1.packaging?.name = "P3"
        product2_1.packaging?.type = "p03"
        
        context.saveContext()
        
        return product2_1
    }
}
