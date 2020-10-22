//
//  PriceCostMarginSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.09.2020.
//

import SwiftUI

struct PriceCostMarginSection: View {
    
    let priceCostMargin: PCM
    
    let kind: Kind
    
    enum Kind {
        case revenue, averageExVAT, averageWithVAT, perKiloExVAT, perKiloWithVAT
        
        var priceStr: String {
            switch self {
                case .revenue:
                    return "Revenue"
                case .averageExVAT:
                    return "Average Price, ex VAT"
                case .averageWithVAT:
                    return "Average Price, With VAT"
                case .perKiloExVAT:
                    return "Price per Kilo, ex VAT"
                case .perKiloWithVAT:
                    return "Price per Kilo, with VAT"
            }
        }

        var costStr: String {
            switch self {
                case .revenue:
                    return "Cost"
                case .averageExVAT:
                    return "Average Cost, ex VAT"
                case .averageWithVAT:
                    return "Average Cost, with VAT"
                case .perKiloExVAT:
                    return "Cost per Kilo, ex VAT"
                case .perKiloWithVAT:
                    return "Cost per Kilo, with VAT"
            }
        }
    }
    
    var body: some View {
        Section {
            VStack(spacing: 8) {
                Group {
                    LabelWithDetail(
                        "dollarsign.circle",
                        kind.priceStr,
                        priceCostMargin.priceStr
                    )
                    .foregroundColor(.primary)
                    
                    LabelWithDetail(
                        "dollarsign.circle",
                        kind.costStr,
                        priceCostMargin.costStr
                    )
                    .foregroundColor(.secondary)
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "Margin",
                        priceCostMargin.marginStr
                    )
                    .foregroundColor(priceCostMargin.margin > 0 ? .systemGreen : .systemRed)
                    
                    LabelWithDetail(
                        "percent",
                        "Margin, percentage",
                        priceCostMargin.marginPercentageStr
                    )
                    .foregroundColor(priceCostMargin.margin > 0 ? .systemGreen : .systemRed)
                }
            }
            .font(.subheadline)
            .padding(.vertical, 4)
        }
    }
}


struct PriceCostMarginSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PriceCostMarginSection(
                priceCostMargin: PCM(
                    price: 120_000.2,
                    cost: 99_000.9
                ),
                kind: .revenue
            )
            PriceCostMarginSection(
                priceCostMargin: PCM(
                    price: 120.2,
                    cost: 99.9,
                    formatWithDecimal: true
                ),
                kind: .averageWithVAT
            )
            PriceCostMarginSection(
                priceCostMargin: PCM(
                    price: 120.2,
                    cost: 99.9,
                    formatWithDecimal: true
                ),
                kind: .averageExVAT
            )
            PriceCostMarginSection(
                priceCostMargin: PCM(
                    price: 120.2,
                    cost: 99.9,
                    formatWithDecimal: true
                ),
                kind: .perKiloWithVAT
            )
            PriceCostMarginSection(
                priceCostMargin: PCM(
                    price: 120.2,
                    cost: 99.9,
                    formatWithDecimal: true
                ),
                kind: .perKiloExVAT
            )
        }
        .preferredColorScheme(.dark)
    }
}
