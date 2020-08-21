//
//  Product.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation

extension Product {
    var sales: [Sales] {
        get { (sales_ as? Set<Sales> ?? []).sorted() }
        set { sales_ = Set(newValue) as NSSet }
    }   
    
    var parentUnit: CustomUnit? { base?.customUnit }
    
    var customUnit: CustomUnit? {
        get {
            if let baseUnit = parentUnit {
                let customUnit = CustomUnit.unit(from: baseUnit, with: coefficientToParentUnit)
                return customUnit
            } else {
                return nil
            }
        }
        set {
            if let baseUnit = parentUnit,
               let newValue = newValue,
               let coefficient = newValue.coefficient(to: baseUnit) {
                coefficientToParentUnit = coefficient
            }
        }
    }
    
    var baseName: String {
        base?.name ?? "ERROR: no base"
    }
    
    var baseQtyInBaseUnit: Double {
        baseQty * coefficientToParentUnit
    }
    
    
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    var groups: [String] {
        base?.factory?.productGroups ?? []
    }
}

extension Product: Comparable {
    public static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.code < rhs.code
    }
}
