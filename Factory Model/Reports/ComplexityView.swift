//
//  ComplexityView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import SwiftUI

struct ComplexityView: View {
    @Binding var complexity: Double
    
    var body: some View {
        VStack {
            LabelWithDetail("wand.and.stars", "Complexity", complexity.formattedPercentage)
            Slider(value: $complexity, in: 0...5, step: 0.1)
        }
    }
}

struct ComplexityView_Previews: PreviewProvider {
    @State static var complexity: Double = 1
    
    static var previews: some View {
        ComplexityView(complexity: $complexity)
            .padding()
            .preferredColorScheme(.dark)
    }
}
