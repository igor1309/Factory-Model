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
    var productionWorkHours: Double { get }
    
    
    //  MARK: - WeightNetto
    
    var productionWeightNetto: Double { get }
    
    
    //  MARK: - Costs for all produced Products
    
    var productionCostExVAT: Double { get }
    
    
    //  MARK: - Output Coefficients
    //  MARK: compare to equipment capacity
    var outputTonnePerHour: Double { get }
    var productionCostExVATPerHour: Double { get }
    var productionCostExVATPerKilo: Double { get }
}

extension ProductionOutput {
        
    //  MARK: - Output Coefficients
    //  MARK: compare to equipment capacity
    var outputTonnePerHour: Double {
        productionWorkHours > 0 ? productionWeightNetto / productionWorkHours : 0
    }
    var productionCostExVATPerHour: Double {
        productionWorkHours > 0 ? productionCostExVAT / productionWorkHours : 0
    }
    var productionCostExVATPerKilo: Double {
        productionWeightNetto > 0 ? productionCostExVAT / productionWeightNetto / 1_000 : 0
    }
}

extension Factory: ProductionOutput {}
extension Base: ProductionOutput {}
extension Product: ProductionOutput {}
