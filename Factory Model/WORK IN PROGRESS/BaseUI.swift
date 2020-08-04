//
//  BaseUI.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

extension Base {
    enum PriceType: String, CaseIterable { case perUnit, perPackage }
}

struct BaseUI: View {
    
    @State private var priceType: Base.PriceType = .perUnit
    
    var body: some View {
        VStack {
            List {
                Text("ЗАКОНЧИТЬ с PriceType!!")
                    .foregroundColor(.orange)
                    .font(.headline)
                Picker("Price type", selection: $priceType) {
                    ForEach(Base.PriceType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            
                Picker("Base Unit", selection: $unit) {
                    ForEach(Base.CustomUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
//                switch unit {
//                    case .weight:
//                        weightView
//                    case .piece:
//                        pieceView
//                    case .undefined:
//                        Text(unit.rawValue)
//                }
                weightView
                pieceView
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    @State private var unit: Base.CustomUnit = .piece
    @State private var unitPrice: Double = 300
    @State private var baseWeight: Double = 450
    
    var basePrice: Double {
        switch unit {
            case .weight:
                return unitPrice * baseWeight / 1000
            case .piece:
                return unitPrice * Double(piecesPerPackage)
        }
    }
    private var weightView: some View {
        Section(
            header: Text("Unit: \(unit.rawValue)")
        ) {
            Slider(
                value: $unitPrice,
                in: 10...1_000,
                step: 10,
                minimumValueLabel: Image(systemName: "bag").imageScale(.small),
                maximumValueLabel: Image(systemName: "bag").imageScale(.large)
            ) {
                Text("Price per 1000 gr")
            }
            
            Stepper(
                value: $unitPrice,
                in: 10...5_000,
                step: 10
            ) {
                LabelWithDetail("Price per 1000 gr", unitPrice.formattedGrouped)
                    .foregroundColor(.secondary)
            }
            
            Slider(
                value: $baseWeight,
                in: 0...1_000,
                step: 10,
                minimumValueLabel: Image(systemName: "scalemass").imageScale(.small),
                maximumValueLabel: Image(systemName: "scalemass").imageScale(.large)
            ) {
                Text("Package weight, gr")
            }
            Stepper(
                value: $baseWeight,
                in: 10...5_000,
                step: 10
            ) {
                LabelWithDetail("Package weight, gr", baseWeight.formattedGrouped)
                    .foregroundColor(.secondary)
            }
            
            LabelWithDetail("Base Price", basePrice.formattedGrouped)
        }
    }
    
    @State private var piecesPerPackage: Int = 1
    
    private var pieceView: some View {
        Section(
            header: Text("Unit: \(unit.rawValue)")
        ) {
            Stepper(
                value: $piecesPerPackage,
                in: 1...30
            ) {
                LabelWithDetail("Pieces per package", piecesPerPackage.formattedGrouped)
            }
            
            Slider(
                value: $unitPrice,
                in: 10...1_000,
                step: 10,
                minimumValueLabel: Image(systemName: "bag").imageScale(.small),
                maximumValueLabel: Image(systemName: "bag").imageScale(.large)
            ) {
                Text("Price per unit")
            }
            
            Stepper(
                value: $unitPrice,
                in: 10...5_000,
                step: 5
            ) {
                LabelWithDetail("Price per unit", unitPrice.formattedGrouped)
                    .foregroundColor(.secondary)
            }
            
            LabelWithDetail("Base Price", basePrice.formattedGrouped)
        }
    }
}

struct BaseUI_Previews: PreviewProvider {
    static var previews: some View {
        BaseUI()
            .preferredColorScheme(.dark)
    }
}
