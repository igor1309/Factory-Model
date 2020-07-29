//
//  QtyPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct QtyPicker: View {
    
    enum Scale: String, CaseIterable {
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
    var navigationTitle: String
    var scale: Scale = .large
    @Binding var qty: Double
    
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
                //                Spacer()
                Text("\(qty, specifier: "%.f")")
            }
        }
        .sheet(isPresented: $showTable) {
            QtyPickerTable(qty: $qty, scale: scale, navigationTitle: navigationTitle)
        }
    }
}

fileprivate struct QtyPickerTable: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var qty: Double
    var navigationTitle: String
    
    @State private var scale: QtyPicker.Scale
    
    init(qty: Binding<Double>, scale: QtyPicker.Scale, navigationTitle: String) {
        _qty = qty
        self.navigationTitle = navigationTitle == "" ? "Select Qty" : navigationTitle
        _scale = State(initialValue: scale)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 12) {
                    Stepper(
                        value: $qty,
                        in: scale.range,
                        step: scale.step
                    ) {
                        Text(qty.formattedGrouped)
                            .foregroundColor(.systemOrange)
                    }
                    
                    HStack {
                        Text("Scale")
                            .font(.subheadline)
                            .padding(.trailing)
                        
                        Picker("Scale", selection: $scale) {
                            ForEach(QtyPicker.Scale.allCases, id: \.self) { scale in
                                Text(scale.rawValue.capitalized).tag(scale)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Slider(
                        value: $qty,
                        in: scale.range,
                        minimumValueLabel: Text(scale.range.lowerBound.formattedGrouped).font(.caption2),
                        maximumValueLabel: Text(scale.range.upperBound.formattedGrouped).font(.caption)
                    ) { Text("\(qty)") }
                }
                .padding([.horizontal, .top])
                
                List {
                    Section(
                        header: Text("")
                    ) {
                        ForEach(scale.values, id: \.self) { value in
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
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct QtyPicker_Previews: PreviewProvider {
    @State static var qty = 3000.0
    
    static var previews: some View {
        Group {
            VStack(spacing: 32) {
                QtyPicker(systemName: "scalemass", title: "mass", navigationTitle: "", scale: .small, qty: $qty)
                QtyPicker(title: "mass", navigationTitle: "", scale: .medium, qty: $qty)
                QtyPicker(navigationTitle: "", scale: .large, qty: $qty)
            }
            .padding()
            .preferredColorScheme(.dark)
            
            QtyPickerTable(qty: $qty, scale: QtyPicker.Scale.medium, navigationTitle: "Weight")
                .preferredColorScheme(.dark)
        }
    }
}
