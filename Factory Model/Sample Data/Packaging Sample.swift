//
//  Packaging Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import CoreData

extension Packaging {
    static var example: Packaging {
        let preview = PersistenceManager.previewContext
        let packaging = Packaging(context: preview)
        packaging.name = "Packaging #1"
        packaging.type = "P.Type 1"
        
        return packaging
    }
}
