//
//  Creatable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 16.11.2020.
//

import SwiftUI

protocol Creatable: Managed {
    associatedtype Editor: View
    
    static func creator(isPresented: Binding<Bool>, factory: Factory?) -> Editor
}

extension Base: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        BaseEditor(isPresented: isPresented, factory: factory)
    }
}
extension Buyer: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        BuyerEditor(isPresented: isPresented, factory: factory)
    }
}
extension Department: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        DepartmentEditor(isPresented: isPresented)
    }
}
extension Division: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        DivisionEditor(isPresented: isPresented, factory: factory)
    }
}
extension Equipment: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        EquipmentEditor(isPresented: isPresented, factory: factory)
    }
}
extension Employee: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        EmployeeEditor(isPresented: isPresented)
    }
}
extension Expenses: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        ExpensesEditor(isPresented: isPresented, factory: factory)
    }
}
extension Factory: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        FactoryEditor(isPresented: isPresented)
    }
}
extension Ingredient: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        IngredientEditor(isPresented: isPresented)
    }
}
extension Packaging: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        PackagingEditor(isPresented: isPresented)
    }
}
extension Product: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        ProductEditor(isPresented: isPresented)
    }
}
extension Recipe: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        RecipeEditor(isPresented: isPresented)
    }
}
extension Sales: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        SalesEditor(isPresented: isPresented)
    }
}
extension Utility: Creatable {
    static func creator(isPresented: Binding<Bool>, factory: Factory? = nil) -> some View {
        UtilityEditor(isPresented: isPresented)
    }
}
