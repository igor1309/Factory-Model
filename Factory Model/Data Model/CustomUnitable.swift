//
//  CustomUnitable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 08.08.2020.
//

import Foundation
import CoreData

protocol CustomUnitable: NSManagedObject & Managed {
    var customUnit: CustomUnit? { get set }
    var customUnitString: String { get }
}

extension CustomUnitable {
    var customUnitString: String { customUnit?.rawValue ?? "??" }
}

extension Base: CustomUnitable {}
extension Product: CustomUnitable {}
extension Ingredient: CustomUnitable {}
extension Recipe: CustomUnitable {}
