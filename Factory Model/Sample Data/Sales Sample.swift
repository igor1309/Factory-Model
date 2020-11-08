//
//  Sales Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import CoreData

extension Sales {
    static var example: Sales {
        let preview = PersistenceManager.previewContext
        let sales = Sales(context: preview)
        sales.qty = 123
        sales.priceExVAT = 12
        sales.buyer = Buyer.example
        sales.product = Product.example
        
        return sales
    }
}
