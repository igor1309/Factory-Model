//
//  Sales.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Sales {
    
    var buyerName: String {
        buyer?.name_ ?? ""
    }
    var productName: String {
        product?.title(in: Period.hour) ?? ""
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
    
    func salesQty(in period: Period) -> Double {
        qty / self.period.hours * period.hours
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
