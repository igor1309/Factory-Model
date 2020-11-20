//
//  HaveRevenue.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.09.2020.
//

import Foundation

protocol HaveRevenue {
    
    //  MARK: Revenue
    
    func revenueExVAT(in period: Period) -> Double
    func revenueWithVAT(in period: Period) -> Double
}

extension Base {//}: HaveRevenue {
    
    //  MARK: Revenue
    
    func revenueExVAT(in period: Period) -> Double {
        products.reduce(0) { $0 + $1.revenueExVAT(in: period) }
    }
    func revenueWithVAT(in period: Period) -> Double {
        products.reduce(0) { $0 + $1.revenueWithVAT(in: period) }
    }
    
}

extension Product {//}: HaveRevenue {
    
    //  MARK: Revenue
    
    func revenueExVAT(in period: Period) -> Double {
        sales.reduce(0) { $0 + $1.revenueExVAT(in: period) }
    }
    func revenueWithVAT(in period: Period) -> Double {
        sales.reduce(0) { $0 + $1.revenueWithVAT(in: period) }
    }
    
}

extension Factory: HaveRevenue {
    
    //  MARK: Revenue
    
    ///  reducing by buyers is not correct - Buyer could not be exclusively linked to factory, reducing via bases is a right way to go
    func revenueExVAT(in period: Period) -> Double {
        bases
            .flatMap(\.products)
            .reduce(0) { $0 + $1.sold(in: period).revenue }
    }
    
    func revenueWithVAT(in period: Period) -> Double {
        bases
            .flatMap(\.products)
            .reduce(0) { $0 + $1.revenueWithVAT(in: period) }
    }
    
}

