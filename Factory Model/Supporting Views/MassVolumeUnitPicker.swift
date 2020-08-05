//
//  MassVolumeUnitPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import SwiftUI
import CoreData


protocol Unitable {
    var unitSymbol_: String? { get set }
}

extension Feedstock: Unitable {}
extension Ingredient: Unitable {}


//  MARK: - MassVolumeUnitPicker not working, use MassVolumeUnitSubPicker
struct MassVolumeUnitPicker<T: NSManagedObject & Managed & Unitable>: View {
//    @ObservedObject var entity: T
    
    @Binding var unit: Unit?
    
    var body: some View {
        
        Picker("Unit", selection: $unit) {
            ForEach([UnitMass.grams, UnitMass.kilograms, UnitVolume.liters], id: \.self) { mvUnit in
                Text(mvUnit.symbol).tag(mvUnit as Unit)
            }
        }
        
        HStack {
            Spacer()
            ForEach([UnitMass.grams, UnitMass.kilograms, UnitVolume.liters], id: \.self) { mvUnit in
                Button {
                    unit = mvUnit //as Unit
                } label: {
                    Text(mvUnit.symbol)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .foregroundColor(.accentColor)
            .font(.headline)
        }
        
//        let unitString = Binding(
//            get: { entity.unit_ },
//            set: { entity.unit_ = $0 }
//        )
        
//        Text("Failed to produce diagnostic for expression; please file a bug report")
//        MassVolumeUnitSubPicker(unit_: $entity.unit_)
        
//        Picker("Единица измерения", selection: unitString) {
//            ForEach(MassVolumeUnit.allCases, id: \.self) { mvUnit in
//                Text(mvUnit.rawValue).tag(mvUnit.unit.symbol)
//            }
//        }
    }
}

struct MassVolumeUnitSubPicker: View {
    @Binding var unit_: String?
    
    var body: some View {
        let unitString = Binding<String>(
            get: { unit_ ?? ""},
            set: { unit_ = $0 }
        )
        
        Picker("Единица измерения", selection: unitString) {
            ForEach([UnitMass.grams, UnitMass.kilograms, UnitVolume.liters], id: \.self) { mvUnit in
                Text(mvUnit.symbol).tag(mvUnit.symbol)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
