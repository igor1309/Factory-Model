//
//  ProductionOutput.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.08.2020.
//

import Foundation

//protocol ProductionOutput: Productable {
protocol ProductionOutput {
    
    //  MARK: - WeightNetto
    
    func productionWeightNetto(in period: Period) -> Double
    
    
    //  MARK: - Costs for all produced Products
    
    //func productionCostExVAT(in period: Period) -> Double
    
    
    //  MARK: - Output Coefficients
    //  MARK: compare to equipment capacity
    func outputTonnePerHour(in period: Period) -> Double
    func productionCostExVATPerHour(in period: Period) -> Double
    func productionCostExVATPerKilo(in period: Period) -> Double
}

extension ProductionOutput where Self: Costable {
        
    //  MARK: - Output Coefficients
    //  MARK: compare to equipment capacity
    func outputTonnePerHour(in period: Period) -> Double {
        productionWeightNetto(in: period) / period.hours
    }
    func productionCostExVATPerHour(in period: Period) -> Double {
        productionCost(in: period).costExVAT / period.hours
    }
    func productionCostExVATPerKilo(in period: Period) -> Double {
        let netto = productionWeightNetto(in: period)
        return netto > 0 ? productionCost(in: period).costExVAT / netto / 1_000 : 0
    }
}

extension Factory: ProductionOutput {}
extension Base: ProductionOutput {}
extension Product: ProductionOutput {}
