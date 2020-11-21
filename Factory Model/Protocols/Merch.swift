//
//  Merch.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.09.2020.
//

import Foundation

protocol Merch {
    
    /// data per kilo
    func perKilo(in period: Period) -> PriceCostMargin
    /// data for all sold products (revenue, cost, etc.)
    func sold(in period: Period) -> PriceCostMargin
    /// data for all produced products (market value, cos, etc.)
    func produced(in period: Period) -> PriceCostMargin
    
    
    
    //  MARK: Output Coefficients
    //  MARK: - FINISH THIS compare to equipment capacity
    func outputTonnePerHour(in period: Period) -> Double
    func productionCostExVATPerHour(in period: Period) -> Double
    func productionCostExVATPerKilo(in period: Period) -> Double
    
}

extension Merch {
    
    //  MARK: Output Coefficients
    
    func outputTonnePerHour(in period: Period) -> Double {
        produced(in: period).weightNettoTons / period.hours
    }
    func productionCostExVATPerHour(in period: Period) -> Double {
        produced(in: period).cost.fullCost / period.hours
    }
    func productionCostExVATPerKilo(in period: Period) -> Double {
        let netto = produced(in: period).weightNetto
        return netto > 0 ? produced(in: period).cost.fullCost / netto / 1_000 : 0
    }
}

extension Merch where Self: Warable {
    
    /// data per kilo
    func perKilo(in period: Period) -> PriceCostMargin {
        unit(in: period)
            .multiplying(by: 1_000 / weightNetto, formatWithDecimal: true)
            .updatingCost(title: "Cost per Kilo", header: "Cost per Kilo")
    }
    ////// data for all sold products (revenue, cost, etc .)
    func sold(in period: Period) -> PriceCostMargin {
        unit(in: period)
            .multiplying(by: salesQty(in: period), formatWithDecimal: false)
            .updatingCost(title: "COGS", header: "Cost of Goods Sold")
    }
    /// data for all produced products (market value, cos, etc.)
    func produced(in period: Period) -> PriceCostMargin {
        unit(in: period)
            .multiplying(by: productionQty(in: period), formatWithDecimal: false)
            .updatingCost(title: "Market Value", header: "Production Market Value")
    }
}

extension Base: Merch {}
extension Product: Merch {}

extension Factory: Merch {
    
    /// data per kilo
    func perKilo(in period: Period) -> PriceCostMargin {
        //  MARK: - FINISH THIS
        PriceCostMargin.productionZero(title: "Cost Per Kilo", header: "Cost Per Kilo")
    }
    /// data for all sold products (revenue, cost, etc.)
    func sold(in period: Period) -> PriceCostMargin {
        let header = "Sales Cost Structure"
        let title = "Sales Cost"
        let pcm = products
            .reduce(PriceCostMargin.productionZero(title: title, header: header)) { $0 + $1.sold(in: period) }
            .multiplying(by: 1, formatWithDecimal: false)
        
        return pcm
    }
    /// data for all produced products (market value, cos, etc.)
    func produced(in period: Period) -> PriceCostMargin {
        let header = "Production Cost Structure"
        let title = "Production Cost"
        let pcm = bases
            .reduce(PriceCostMargin.productionZero(title: title, header: header)) { $0 + $1.produced(in: period) }
            .multiplying(by: 1, formatWithDecimal: false)
        
        return pcm
    }
    
}
