//
//  Utility Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import CoreData

extension Utility {
    static var example: Utility {
        let preview = PersistenceManager.previewContext
        let utility = Utility(context: preview)
        utility.name = "Some Utility"
        utility.priceExVAT = 12
        utility.vat = 20/100
        utility.base = Base.example
        
        return utility
    }
}
