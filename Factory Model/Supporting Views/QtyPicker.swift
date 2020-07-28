//
//  QtyPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct QtyPicker: View {
    
    enum Scale {
        case small
        case medium
        case large
        
        var range: ClosedRange<Double> {
            switch self {
                case .small:
                    return 5.0...100
                case .medium:
                    return 100.0...1_000
                case .large:
                    return 1_000.0...50_000
            }
        }
        
        var step: Double {
            switch self {
                case .small:
                    return 5
                case .medium:
                    return 10
                case .large:
                    return 200
            }
        }
        
        var values: [Double] {
            Array(stride(from: self.range.lowerBound, to: self.range.upperBound, by: self.step))
        }
    }
    
    var systemName: String = ""
    var title: String = ""
    var scale: Scale = .large
    @Binding var qty: Double

//    init(
//        title: String = "",
//        scale: Scale = .large,
//        qty: Binding<Double>
//    ) {
//        self.title = title
//        self.scale = scale
//        self._qty = qty
//    }
    
    
    @State private var showTable = false
    
    var body: some View {
        Button {
            showTable = true
        } label: {
            HStack {
                
                switch (title.isEmpty, systemName.isEmpty) {
                    case (false, false):
                        Label(title, systemImage: systemName)
                        Spacer()
                    case (false, true):
                        Text(title)
                        Spacer()
                    case (true, false):
                        Image(systemName: systemName)
                        Spacer()
                    default:
                        EmptyView()
                }
                
                
//                if !title.isEmpty {
//                    Text(title)
                    Spacer()
//                }
                Text("\(qty, specifier: "%.f")")
            }
        }
        .sheet(isPresented: $showTable) {
            QtyPickerTable(qty: $qty, values: scale.values)
        }
    }
}

fileprivate struct QtyPickerTable: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var qty: Double
    
    let values: [Double]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(values, id: \.self) { value in
                    Button {
                        qty = value
                        presentation.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text(("\(value, specifier: "%.f")"))
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Qty")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct QtyPicker_Previews: PreviewProvider {
    @State static var qty = 3000.0
    
    static var previews: some View {
        VStack(spacing: 32) {
            QtyPicker(systemName: "scalemass", title: "mass", scale: .small, qty: $qty)
            QtyPicker(title: "mass", scale: .medium, qty: $qty)
            QtyPicker(scale: .large, qty: $qty)
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
