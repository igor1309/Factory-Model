//
//  QtyPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AmountPicker: View {
    
    enum Scale: String, CaseIterable {
        case percent
        case extraSmall
        case small
        case medium
        case large
        case extraLarge
        case extraExtraLarge
        
        var range: ClosedRange<Double> {
            switch self {
                case .percent:         return 0.0...200
                case .extraSmall:      return 0.0...10
                case .small:           return 10.0...100
                case .medium:          return 100.0...1_000
                case .large:           return 1_000.0...10_000
                case .extraLarge:      return 10_000.0...100_000
                case .extraExtraLarge: return 100_000.0...10_000_000
            }
        }
        
        var majorStep: Double {
            switch self {
                case .percent:         return 1
                case .extraSmall:      return 1
                case .small:           return 5
                case .medium:          return 10
                case .large:           return 100
                case .extraLarge:      return 500
                case .extraExtraLarge: return 50_000
            }
        }
        
        var minorStep: Double {
            switch self {
                case .percent:         return 0.5
                case .extraSmall:      return 1
                case .small:           return 1
                case .medium:          return 5
                case .large:           return 10
                case .extraLarge:      return 50
                case .extraExtraLarge: return 5_000
            }
        }
        
        var code: String {
            switch self {
                case .percent:         return "%%"
                case .extraSmall:      return "XS"
                case .small:           return "S"
                case .medium:          return "M"
                case .large:           return "L"
                case .extraLarge:      return "XL"
                case .extraExtraLarge: return "XXL"
            }
        }
        
        var values: [Double] {
            Array(stride(from: self.range.lowerBound, to: self.range.upperBound, by: self.majorStep))
        }
    }
    
    var systemName: String = ""
    var title: String = ""
    var navigationTitle: String
    var scale: Scale = .large
    
    @Binding var amount: Double
    
    @State private var showSheet = false
    
    var body: some View {
        Button {
            showSheet = true
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
                if scale == .percent {
                    Text(amount.formattedPercentageWith1Decimal)
                        .padding(.leading)
                } else {
                    Text("\(amount, specifier: "%.f")")
                        .padding(.leading)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            AmountPickerSheet(qty: $amount, scale: scale, navigationTitle: navigationTitle)
        }
    }
}

fileprivate struct AmountPickerSheet: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var qty: Double
    var navigationTitle: String
    
    @State private var scale: AmountPicker.Scale
    
    init(
        qty: Binding<Double>,
        scale: AmountPicker.Scale,
        navigationTitle: String
    ) {
        _qty = qty
        self.navigationTitle = navigationTitle == "" ? "Select Qty" : navigationTitle
        _scale = State(initialValue: scale)
    }
    
    var columnsCount: Int {
        switch scale {
            case .percent:         return 6
            case .extraSmall:      return 9
            case .small:           return 8
            case .medium:          return 6
            case .large:           return 5
            case .extraLarge:      return 4
            case .extraExtraLarge: return 3
        }
    }
    
    var body: some View {
        let selection = Binding<Double>(
            get: {
                qty * (scale == .percent ? 100 : 1)
            },
            set: {
                qty = $0 / (scale == .percent ? 100 : 1)
            }
        )
        
        return NavigationView {
            VStack {
                VStack(spacing: 12) {
                    Stepper(
                        value: selection,
                        in: scale.range,
                        step: scale.minorStep
                    ) {
                        if scale == .percent {
                            Text(qty.formattedPercentageWith1Decimal)
                                .foregroundColor(.systemOrange)
                        } else {
                            Text(qty.formattedGrouped)
                                .foregroundColor(.systemOrange)
                        }
                    }
                    
                    Picker("Scale", selection: $scale) {
                        ForEach(AmountPicker.Scale.allCases, id: \.self) { scale in
                            Text(scale.code).tag(scale)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Slider(
                        value: selection,
                        in: scale.range,
                        step: scale.majorStep,
                        minimumValueLabel: Text(scale.range.lowerBound.formattedGrouped).font(.caption2),
                        maximumValueLabel: Text(scale.range.upperBound.formattedGrouped).font(.caption)
                    ) { Text("\(qty)") }
                }
                .padding([.horizontal, .top])
                
                //  https://swiftui-lab.com/impossible-grids/
                ScrollView(.vertical) { // .vertical is the default, so it can be omitted
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columnsCount)
                    ) {
                        ForEach(scale.values, id: \.self) { value in
                            Button {
                                qty = value / (scale == .percent ? 100 : 1)
                                presentation.wrappedValue.dismiss()
                            } label: {
                                ZStack {
                                    Text("\(scale.values.last ?? 0, specifier: "%.f")")
                                        .lineLimit(1)
                                        .fixedSize()
                                        .hidden()
                                    Text("\(value, specifier: "%.f")")
                                    .lineLimit(1)
                                    .fixedSize()
                                }
                                .font(.subheadline)
//                                        .padding(3)
                                .simpleCardify()
                            }
                        }
                    }
                    .padding()
                }
                
//                List {
//                    Section(
//                        header: Text("")
//                    ) {
//                        ForEach(scale.values, id: \.self) { value in
//                            Button {
//                                qty = value
//                                presentation.wrappedValue.dismiss()
//                            } label: {
//                                HStack {
//                                    Spacer()
//                                    Text(("\(value, specifier: "%.f")"))
//                                }
//                            }
//                        }
//                    }
//                }
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
                AmountPicker(systemName: "scalemass", title: "mass", navigationTitle: "", scale: .small, amount: $qty)
                AmountPicker(title: "mass", navigationTitle: "", scale: .medium, amount: $qty)
                AmountPicker(navigationTitle: "", scale: .large, amount: $qty)
            }
            .padding()
            .preferredColorScheme(.dark)
            
            AmountPickerSheet(qty: $qty, scale: AmountPicker.Scale.medium, navigationTitle: "Weight")
                .preferredColorScheme(.dark)
        }
    }
}
