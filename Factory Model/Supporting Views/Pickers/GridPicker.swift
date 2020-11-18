//
//  GridPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.11.2020.
//

import SwiftUI

struct GridPicker<Value: Hashable & Equatable>: View {
    let title: String
    @Binding var selection: Value
    let options: [Value]
    var columnsCount = 5
    let cornerRadius: CGFloat = 8
    
    // used to put elements of option array in equal bounds: ZStack with hidden Text(longest)
    var longest: String {
        let optionsAsStrings = options.map { "\($0)" }
        
        if let max = optionsAsStrings.max(by: {$1.count > $0.count}) {
            return max
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .foregroundColor(.secondary)
                .font(.caption)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columnsCount)
            ) {
                ForEach(options, id: \.self) { item in
                    Button {
                        //  MARK: - FINISH THIS ADD HAPTIC
                        withAnimation {
                            selection = item
                        }
                    } label: {
                        ZStack {
                            Text(longest).hidden()
                            Text("\(item)" as String).tag(item)
                        }
                        .padding(6)
                        .padding(.horizontal, 6)
                        .fixedSize()
                        .foregroundColor(selection == item ? .systemOrange : .accentColor)
                        .background(
                            Color(selection == item ? UIColor.systemBackground : UIColor.secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .strokeBorder(selection == item ? Color.orange : Color.systemGray2, lineWidth: selection == item ? 2: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .simpleCardify()
        }
    }
}

fileprivate struct GridPickerTesting: View {
    @State private var selection = 5
    
    var body: some View {
        VStack {
            GridPicker(title: "days in week", selection: $selection, options: Period.dayOptions(for: "week"))
            Divider()
            
            GridPicker(title: "days in month", selection: $selection, options: Period.dayOptions(for: "month"))
            Divider()
            
            GridPicker(title: "days in year", selection: $selection, options: Period.dayOptions(for: "year"))
            Divider()
            
            GridPicker(title: "some days", selection: $selection, options: [3, 4, 5, 6, 7, 14, 21, 24, 30, 247, 300, 360])
        }
        .padding()
    }
}

struct GridPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GridPickerTesting()
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 345.0, height: 500))
            
            GridPickerTesting()
                .preferredColorScheme(.light)
                .previewLayout(.fixed(width: 345.0, height: 500))
        }
    }
}
