//
//  Base.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Base {
    var recipes: [Recipe] {
        get { (recipes_ as? Set<Recipe> ?? []).sorted() }
        set { recipes_ = Set(newValue) as NSSet }
    }
    var products: [Product] {
        get { (products_ as? Set<Product> ?? []).sorted() }
        set { products_ = Set(newValue) as NSSet }
    }
    var utilities: [Utility] {
        get { (utilities_ as? Set<Utility> ?? []).sorted() }
        set { utilities_ = Set(newValue) as NSSet }
    }
    

    
    
    var customUnit: CustomUnit? {
        get { CustomUnit(rawValue: unitString_ ?? "") }
        set { unitString_ = newValue?.rawValue }
    }
    



    //  MARK: FIX THIS: неоптимально —
    //  нужно по FetchRequest вытащить список имеющихся групп базовых продуктов (для этой/выбранной фабрики! — возможно функция с параметром по умолчанию?)
    var groups: [String] {
        factory?.bases.map(\.group).removingDuplicates() ?? []
    }
    var productList: String {
        products.map(\.title).joined(separator: "\n")
    }
    
}

extension Base: Comparable {
    public static func < (lhs: Base, rhs: Base) -> Bool {
        lhs.code < rhs.code
    }
}
