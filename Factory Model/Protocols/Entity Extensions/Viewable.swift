//
//  Viewable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 16.11.2020.
//

import SwiftUI

protocol Viewable: Managed {
    associatedtype Viewer: View
    
    func viewer() -> Viewer
}

extension Base: Viewable {
    func viewer() -> some View { BaseView(self) }
}
extension Buyer: Viewable {
    func viewer() -> some View { BuyerView(self) }
}
extension Department: Viewable {
    func viewer() -> some View { DepartmentView(self) }
}
extension Division: Viewable {
    func viewer() -> some View { DivisionView(self) }
}
extension Equipment: Viewable {
    func viewer() -> some View { EquipmentEditor(self) }
}
extension Employee: Viewable {
    func viewer() -> some View { EmployeeEditor(self) }
}
extension Expenses: Viewable {
    func viewer() -> some View { ExpensesEditor(self) }
}
extension Factory: Viewable {
    func viewer() -> some View { FactoryView(self) }
}
extension Ingredient: Viewable {
    func viewer() -> some View { IngredientView(self) }
}
extension Packaging: Viewable {
    func viewer() -> some View { PackagingView(self) }
}
extension Product: Viewable {
    func viewer() -> some View { ProductView(self) }
}
extension Recipe: Viewable {
    func viewer() -> some View { RecipeEditor(self) }
}
extension Sales: Viewable {
    func viewer() -> some View { SalesEditor(self) }
}
extension Utility: Viewable {
    func viewer() -> some View { UtilityEditor(self) }
}
