//
//  WeightNettable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol WeightNettable {
    func salesWeightNettoTons(in period: Period) -> Double
    func productionWeightNettoTons(in period: Period) -> Double
}

extension Factory: WeightNettable {
    func salesWeightNettoTons(in period: Period) -> Double {
        bases.reduce(0) { $0 + $1.salesWeightNettoTons(in: period) }
    }
    func productionWeightNettoTons(in period: Period) -> Double {
        bases.reduce(0) { $0 + $1.productionWeightNettoTons(in: period) }
    }
}

extension Base: WeightNettable {
    func salesWeightNettoTons(in period: Period) -> Double {
        salesQty(in: period) * weightNetto / 1_000 / 1_000
    }
    func productionWeightNettoTons(in period: Period) -> Double {
        productionQty(in: period) * weightNetto / 1_000 / 1_000
    }
    
}

extension Product: WeightNettable {
    private var weightNetto: Double {
        (base?.weightNetto ?? 0) * baseQtyInBaseUnit
    }
    func salesWeightNettoTons(in period: Period) -> Double {
        salesQty(in: period) * weightNetto / 1_000 / 1_000
    }
    func productionWeightNettoTons(in period: Period) -> Double {
        productionQty(in: period) * weightNetto / 1_000 / 1_000
    }
}
