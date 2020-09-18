//
//  ProductionOutput.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.08.2020.
//

import Foundation

protocol ProductionOutput {
    
    //  MARK: Output Coefficients
    //  MARK: - FINISH THIS compare to equipment capacity
    func outputTonnePerHour(in period: Period) -> Double
    func productionCostExVATPerHour(in period: Period) -> Double
    func productionCostExVATPerKilo(in period: Period) -> Double
}

extension ProductionOutput where Self: Costable & Tradable {
        
    //  MARK: Output Coefficients

    func outputTonnePerHour(in period: Period) -> Double {
        //productionWeightNettoTons(in: period)
        produced(in: period).weightNetto / period.hours
    }
    func productionCostExVATPerHour(in period: Period) -> Double {
        productionCost(in: period).costExVAT / period.hours
    }
    func productionCostExVATPerKilo(in period: Period) -> Double {
        // productionWeightNettoTons(in: period)
        let netto = produced(in: period).weightNetto
        return netto > 0 ? productionCost(in: period).costExVAT / netto / 1_000 : 0
    }
}

extension Factory: ProductionOutput {}
extension Base: ProductionOutput {}
extension Product: ProductionOutput {}
