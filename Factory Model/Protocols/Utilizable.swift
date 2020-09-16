//
//  Utilizable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Utilizable {
    
    //  MARK: - having Utility
    
    func utilitiesExVAT(in period: Period) -> Double
    
    func productionUtilitiesExVAT(in period: Period) -> Double
    func productionUtilitiesWithVAT(in period: Period) -> Double
    
    func salesUtilitiesExVAT(in period: Period) -> Double
    
    func utilitiesWithVAT(in period: Period) -> Double
}

extension Base: Utilizable {
    func utilitiesExVAT(in period: Period) -> Double {
        utilities.reduce(0) { $0 + $1.priceExVAT }
    }

    func productionUtilitiesExVAT(in period: Period) -> Double {
        //utilities.reduce(0) { $0 + $1.priceExVAT }
        productionQty(in: period) * utilitiesExVAT(in: period)
    }
    func productionUtilitiesWithVAT(in period: Period) -> Double {
        productionQty(in: period) * utilitiesWithVAT(in: period)
    }
    
    func salesUtilitiesExVAT(in period: Period) -> Double {
        //utilities.reduce(0) { $0 + $1.priceExVAT }
        salesQty(in: period) * utilitiesExVAT(in: period)
    }
    func utilitiesWithVAT(in period: Period) -> Double {
        utilities.reduce(0) { $0 + $1.priceExVAT * (1 + $1.vat) }
    }

}

extension Product: Utilizable {
    func utilitiesExVAT(in period: Period) -> Double {
        (base?.utilitiesExVAT(in: period) ?? 0) * baseQtyInBaseUnit
    }

    func productionUtilitiesExVAT(in period: Period) -> Double {
        productionQty(in: period) * utilitiesExVAT(in: period)
    }
    
    func productionUtilitiesWithVAT(in period: Period) -> Double {
        productionQty(in: period) * utilitiesWithVAT(in: period)
    }

    func salesUtilitiesExVAT(in period: Period) -> Double {
        salesQty(in: period) * utilitiesExVAT(in: period)
    }
    
    func utilitiesWithVAT(in period: Period) -> Double {
        (base?.utilitiesWithVAT(in: period) ?? 0) * baseQtyInBaseUnit
    }
}
