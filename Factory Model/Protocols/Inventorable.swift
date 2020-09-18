//
//  Inventorable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Inventorable: Makable {
    
    //  MARK: Inventory
    
    var initialInventory: Double { get set }
    
    
    //  MARK: Closing Inventory
    
    func closingInventory(in period: Period) -> Double
}

extension Inventorable {
    
    //  MARK: Closing Inventory
    
    func closingInventory(in period: Period) -> Double {
        initialInventory + made(in: period).productionQty - made(in: period).salesQty
    }
    
}

extension Base: Inventorable {}
extension Product: Inventorable {}
