//
//  Expenses Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import CoreData

extension Expenses {
    static var example: Expenses {
        let preview = PersistenceManager.previewContext
        return Expenses.createExpenses1(in: preview)[0]
    }
}
