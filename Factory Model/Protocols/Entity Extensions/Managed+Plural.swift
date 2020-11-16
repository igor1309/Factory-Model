//
//  Managed+Plural.swift
//  Factory Model
//
//  Created by Igor Malyarov on 16.11.2020.
//

import Foundation

extension Managed {
    //  MARK: - FINISH THIS return plural forms
    /// https://medium.com/@vitaliikuznetsov/plurals-localization-using-stringsdict-in-ios-a910aab8c28c
    /// https://stackoverflow.com/questions/30207436/dynamic-strings-with-placeholders-and-plural-support-in-swift-ios
    /// https://crunchybagel.com/localizing-plurals-in-ios-development/
    
    static var plural: String {
        switch entityName {
            case "Base":
                return "Base Products"
            case "Buyer":
                return "Buyers"
            case "Department":
                return "Departments"
            case "Division":
                return "Divisions"
            case "Equipment":
                return "Equipment"
            case "Expenses":
                return "Expenses"
            case "Factory":
                return "Factories"
            case "Ingredient":
                return "Ingredients"
            case "Packaging":
                return "Packagings"
            case "Product":
                return "Products"
            case "Recipe":
                return "Recipes"
            case "Sales":
                return "Sales"
            case "Utility":
                return "Utilities"
            case "Employee":
                return "Personnel"
            default:
                return entityName
        }
    }
}

