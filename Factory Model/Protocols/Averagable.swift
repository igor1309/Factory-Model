//
//  Averagable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.09.2020.
//

import Foundation

protocol Averagable {
    
    //  MARK: Averages
    
    func avgPerKiloExVAT(in period: Period) -> PriceCostMargin
    
    func avgPricePerKiloExVAT(in period: Period) -> Double
    func avgCostPerKiloExVAT(in period: Period) -> Double
    func avgMarginPerKiloExVAT(in period: Period) -> Double
    
}

extension Averagable where Self: Costable & HaveRevenue & Tradable {// & WeightNettable {
    
    func avgPerKiloExVAT(in period: Period) -> PriceCostMargin {
        // salesWeightNettoTons(in: period)
        let salesWeight = sold(in: period).weightNetto
        let avgPricePerKiloExVAT = salesWeight == 0 ? 0 : revenueExVAT(in: period) / salesWeight / 1_000
        
        // productionWeightNettoTons(in: period)
        let productionWeight = produced(in: period).weightNetto
        let avgCostPerKiloExVAT = productionWeight == 0 ? 0 : productionCost(in: period).costExVAT / productionWeight / 1_000
        
        return PriceCostMargin(price: avgPricePerKiloExVAT, cost: avgCostPerKiloExVAT)
    }
    
    
    func avgPricePerKiloExVAT(in period: Period) -> Double {
        // salesWeightNettoTons(in: period)
        let weight = sold(in: period).weightNetto
        return weight == 0 ? 0 : revenueExVAT(in: period) / weight / 1_000
    }
    func avgCostPerKiloExVAT(in period: Period) -> Double {
        // productionWeightNettoTons(in: period)
        let weight = produced(in: period).weightNetto
        return weight == 0 ? 0 : productionCost(in: period).costExVAT / weight / 1_000
    }
    func avgMarginPerKiloExVAT(in period: Period) -> Double {
        avgPricePerKiloExVAT(in: period) - avgCostPerKiloExVAT(in: period)
    }
    
}

//extension Product: Averagable {}
extension Product {
    func avgPerKiloExVAT(in period: Period) -> PriceCostMargin {
        // salesWeightNettoTons(in: period)
        let salesWeight = sold(in: period).weightNetto
        let avgPricePerKiloExVAT = salesWeight == 0 ? 0 : revenueExVAT(in: period) / salesWeight / 1_000
        
        // productionWeightNettoTons(in: period)
        let productionWeight = produced(in: period).weightNetto
        let avgCostPerKiloExVAT = productionWeight == 0 ? 0 : productionCost(in: period).costExVAT / productionWeight / 1_000
        
        return PriceCostMargin(price: avgPricePerKiloExVAT, cost: avgCostPerKiloExVAT)
    }
}

extension Factory: Averagable {
        
    func avgPerKiloExVAT(in period: Period) -> PriceCostMargin {
        // salesWeightNettoTons(in: period)
        let salesWeight = sold(in: period).weightNetto
        let avgPricePerKiloExVAT = salesWeight == 0 ? 0 : revenueExVAT(in: period) / salesWeight / 1_000
        
        // productionWeightNettoTons(in: period)
        let productionWeight = produced(in: period).weightNetto
        let avgCostPerKiloExVAT = productionWeight == 0 ? 0 : productionCost(in: period).costExVAT / productionWeight / 1_000
        
        return PriceCostMargin(price: avgPricePerKiloExVAT, cost: avgCostPerKiloExVAT)
    }
    
    func avgPricePerKiloExVAT(in period: Period) -> Double {
        // salesWeightNettoTons(in: period)
        let weight = sold(in: period).weightNetto
        return weight == 0 ? 0 : revenueExVAT(in: period) / weight / 1_000
    }
    func avgCostPerKiloExVAT(in period: Period) -> Double {
        // productionWeightNettoTons(in: period)
        let weight = produced(in: period).weightNetto
        return weight == 0 ? 0 : productionCost(in: period).costExVAT / weight / 1_000
    }
    func avgMarginPerKiloExVAT(in period: Period) -> Double {
        avgPricePerKiloExVAT(in: period) - avgCostPerKiloExVAT(in: period)
    }
    
}
