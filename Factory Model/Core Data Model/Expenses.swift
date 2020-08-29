//
//  Expenses.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation
import CoreData

extension Expenses {
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    
    func amount(in period: Period) -> Double {
        amount / self.period.hours * period.hours
    }
}

extension Expenses: Comparable {
    public static func < (lhs: Expenses, rhs: Expenses) -> Bool {
        lhs.name < rhs.name
    }
    
    static func createExpenses1(in context: NSManagedObjectContext) -> [Expenses] {
        let expenses1 = Expenses(context: context)
        expenses1.name = "Связь"
        expenses1.amount = 15_000
        
        let expenses2 = Expenses(context: context)
        expenses2.name = "Потери, брак"
        expenses2.amount = 50_000
        
        let expenses3 = Expenses(context: context)
        expenses3.name = "СЭС (анализы и др.)"
        expenses3.amount = 5_000
        
        let expenses4 = Expenses(context: context)
        expenses4.name = "Текущий  ремонт и обслуживание основных средств"
        expenses4.amount = 20_000
        
        let expenses5 = Expenses(context: context)
        expenses5.name = "Банковские услуги"
        expenses5.amount = 5_000
        
        let expenses6 = Expenses(context: context)
        expenses6.name = "Офисные и другие расходы"
        expenses6.amount = 10_000
        
        let expenses7 = Expenses(context: context)
        expenses7.name = "Аренда"
        expenses7.amount = 50_000
        
        return [expenses1, expenses2, expenses3, expenses4, expenses5, expenses6, expenses7]
    }
}
