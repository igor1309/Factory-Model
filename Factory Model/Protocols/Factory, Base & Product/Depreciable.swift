//
//  Depreciable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Depreciable: Costable {
    //  MARK: - Depreciation
    //  MARK: FINISH THIS
    
    func depreciationWithTax(in period: Period) -> Double
    
    func salesDepreciationWithTax(in period: Period) -> Double
    
    func productionDepreciationWithTax(in period: Period) -> Double
    
}

extension Base: Depreciable {
    //  MARK: - FINISH THIS
    func depreciationWithTax(in period: Period) -> Double { 0.5 }

    func salesDepreciationWithTax(in period: Period) -> Double { 0.5 }

    func productionDepreciationWithTax(in period: Period) -> Double { 0.5 }
    

}
extension Product: Depreciable {
    func depreciationWithTax(in period: Period) -> Double {
        (base?.depreciationWithTax(in: period) ?? 0) * baseQtyInBaseUnit
    }
    
    //  MARK: - FINISH THIS
    func salesDepreciationWithTax(in period: Period) -> Double { 0.5 }
    
    func productionDepreciationWithTax(in period: Period) -> Double { 0.5 }

}
