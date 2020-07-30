//
//  Summarable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

protocol Summarizable {
    var title: String { get }
    var subtitle: String { get }
    var detail: String? { get }
    var icon: String { get }
}
extension Summarizable where Self: Monikerable {
    var title: String { name }
}
extension Summarizable {
    var subtitle: String { "" }
    var detail: String? { "" }
}

extension Base: Summarizable {
    var title: String {
        [name, code, group]
            .filter { !$0.isEmpty }
            .joined(separator: " : ")
    }
    
    var subtitle: String { note }
    
    var detail: String? {
        if closingInventory < 0 {
            return "ERROR: Negative Closing Inventory"
        }
        
        if revenueExVAT > 0 {
            return "\(totalSalesQty.formattedGrouped) of \(productionQty.formattedGrouped) @ \(avgPriceExVAT) = \(revenueExVAT.formattedGrouped)"
        } else {
            return "Production \(productionQty.formattedGrouped)"
        }
    }
    
    var icon: String { "bag" }
}

extension Buyer: Summarizable {
    var subtitle: String { "TBD: объем выручки по покупателю" }
    var detail: String? { "TBD: списк покупаемых продуктов" }
    var icon: String { "cart.fill" }
}

extension Division: Summarizable {
    var title: String {
        "\(name), [\("TBD: headcount")]"
    }
    var subtitle: String { "TBD: Division Budget" }
    var detail: String? { "TBD: list of departnemt names" }
    var icon: String { "person.crop.rectangle" }
}

extension Department: Summarizable {
    var detail: String? { type.rawValue.capitalized }
    var icon: String { "person.2" }
}

extension Equipment: Summarizable {
    var subtitle: String { note }
    
    var detail: String? {
        "\(depreciationMonthly.formattedGrouped) per month for \(lifetime) years = \(price.formattedGrouped)"
    }
    
    var icon: String { "wrench.and.screwdriver" }
}

extension Expenses: Summarizable {
    var subtitle: String { amount.formattedGrouped }
    var detail: String? { note }
    var icon: String { "dollarsign.circle" }
}

extension Factory: Summarizable {
    var subtitle: String { note }
    
    var detail: String? {
        "TBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)"
    }
    var icon: String { "building.2" }
}

extension Feedstock: Summarizable {
    
    var subtitle: String {
        //  MARK: - FINISH THIS
        //        "\(qty.formattedGrouped) @ \(priceExVAT) = \(costExVAT.formattedGrouped)"
        "Price \(priceExVAT), VAT \(vat.formattedPercentage)"
    }
    
    var detail: String? { nil }
    var icon: String { "puzzlepiece" }
}

extension Ingredient: Summarizable {
    var title: String { feedstock?.name ?? "ERROR: feedstock unknown" }
    var subtitle: String {
        qty.formattedGrouped + " @ "
            + (feedstock == nil ? 0: feedstock!.priceExVAT).formattedGrouped
            + " = " + cost.formattedGrouped
    }
    
    var detail: String? {
        qty >= 0 ? "" : "ERROR: negative Qty!"
    }
    
    var icon: String { "puzzlepiece" }
}

extension Packaging: Summarizable {
    var subtitle: String { type }
    
    var detail: String? {
        if products_ == nil || products.isEmpty {
            return "ERROR: not used in products"
        }
        return products.map { $0.title }.joined(separator: ", ")
    }
    
    var icon: String { "shippingbox" }
}

extension Product: Summarizable {
    var summary: String {
        "\(name)/\(code)/\(group)/\(note)"
    }
    var title: String {
//        [baseName, name]
//            .filter { !$0.isEmpty }
//            .joined(separator: ", ")
        base == nil
            ? "\(name)"
            : "\(name) \(baseName), \(baseQty.formattedGrouped) \(base!.unit.idd), \(weightNetto.formattedGrouped)г"
    }
    
    var subtitle: String {
        base == nil
            ? "ERROR: no base for product"
            : [name, group, code]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    var detail: String? {
        if base == nil {
            return "ERROR: no base for product"
        }
        if productionQty == 0 {
            return "ERROR: no production for product"
        }
        if sales.isEmpty {
            return "ERROR: no sales for product"
        }
        return [name, group, code]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    var icon: String { "bag.circle" }
}

extension Sales: Summarizable {
    var title: String {
        buyer?.name ?? "ERROR no Buyer"
    }
    
    var subtitle: String {
        guard qty > 0 else { return "ERROR qty" }
        guard priceExVAT > 0 else { return "ERROR price" }

        return "\(productName)\n\(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped) = \(revenueExVAT.formattedGrouped)"
    }
    
    var detail: String? { nil }
    var icon: String { "creditcard.fill" }
}

extension Utility: Summarizable {
    var subtitle: String { priceExVAT.formattedGroupedWithMax2Decimals }
    var detail: String? { vat.formattedPercentage }
    var icon: String { "lightbulb" }
}

extension Worker: Summarizable {
    var subtitle: String { salary.formattedGrouped }
    
    var detail: String? {
        [department?.name ?? "", position]
            .filter { !$0.isEmpty}
            .joined(separator: ": ")
    }
    
    var icon: String { "person" }
}
