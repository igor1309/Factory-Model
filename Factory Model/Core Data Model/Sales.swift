//
//  Sales.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Sales {
    
    var period: Period {
        get {
            Period(periodStr_ ?? "month", days: Int(days), hoursPerDay: hoursPerDay) ?? .month()
        }
        set {
            periodStr_ = newValue.periodStr
            days = Int16(newValue.days)
            hoursPerDay = newValue.hoursPerDay
        }
    }
    
    var buyerName: String {
        buyer?.name_ ?? ""
    }
    var productName: String {
        product?.title ?? ""
    }
    
    var priceWithVAT: Double {
        get {
            let vat = (product?.vat ?? 0)
            return priceExVAT * (1 + vat)
        }
        set {
            let vat = (product?.vat ?? 0)
            priceExVAT = newValue / (1 + vat)
        }
    }
    
    func revenueExVAT(in period: Period) -> Double {
        qty * priceExVAT / self.period.hours * period.hours
    }
    func revenueWithVAT(in period: Period) -> Double {
        qty * priceWithVAT / self.period.hours * period.hours
    }
    
    func cogs(in period: Period) -> Double {
        product?.cogs(in: period) ?? 0
    }
}

extension Sales: Comparable {
    public static func < (lhs: Sales, rhs: Sales) -> Bool {
        lhs.qty < rhs.qty
    }
}
