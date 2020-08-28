//
//  ProductionOutput.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.08.2020.
//

import Foundation

//protocol ProductionOutput: Productable {
protocol ProductionOutput {
    
    //  MARK: - Work Hours
    func productionWorkHours(in period: Period) -> Double
    
    
    //  MARK: - WeightNetto
    
    func productionWeightNetto(in period: Period) -> Double
    
    
    //  MARK: - Costs for all produced Products
    
    func productionCostExVAT(in period: Period) -> Double
    
    
    //  MARK: - Output Coefficients
    //  MARK: compare to equipment capacity
    func outputTonnePerHour(in period: Period) -> Double
    func productionCostExVATPerHour(in period: Period) -> Double
    func productionCostExVATPerKilo(in period: Period) -> Double
}

extension ProductionOutput {
        
    //  MARK: - Output Coefficients
    //  MARK: compare to equipment capacity
    func outputTonnePerHour(in period: Period) -> Double {
        productionWorkHours(in: period) > 0 ? productionWeightNetto(in: period) / productionWorkHours(in: period) : 0
    }
    func productionCostExVATPerHour(in period: Period) -> Double {
        let hours = productionWorkHours(in: period)
        return hours > 0 ? productionCostExVAT(in: period) / hours : 0
    }
    func productionCostExVATPerKilo(in period: Period) -> Double {
        let netto = productionWeightNetto(in: period)
        return netto > 0 ? productionCostExVAT(in: period) / netto / 1_000 : 0
    }
}

extension Factory: ProductionOutput {}
extension Base: ProductionOutput {}
extension Product: ProductionOutput {}
