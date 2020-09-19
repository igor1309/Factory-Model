//
//  HavingParentUnit.swift
//  Factory Model
//
//  Created by Igor Malyarov on 08.08.2020.
//

import Foundation
import CoreData

protocol HavingParentUnit: NSManagedObject & Managed {
    var parentUnit: CustomUnit? { get }
    var coefficientToParentUnit: Double { get set }
}
extension HavingParentUnit {
    var parentUnitString: String {
        parentUnit?.rawValue ?? "Unit not defined"
    }
}

extension Recipe: HavingParentUnit {}
extension Product: HavingParentUnit {}

