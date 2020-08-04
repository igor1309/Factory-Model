//
//  CardViewModifier.swift
//  ChartsAndCollectionLibrariesDevelopment
//
//  Created by Igor Malyarov on 02.06.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension View {
    
    /// Wrap View in a `Simple Card` with background and rounded corners
    /// - Parameters:
    ///   - padding: padding of the wrapped view
    ///   - cornerRadius: card cornerRadius
    ///   - background: card background: Color
    /// - Returns: View wrapped in card
    public func simpleCardify(
        padding: CGFloat = 10,
        cornerRadius: CGFloat = 10,
        background: Color = Color(UIColor.secondarySystemBackground)
    ) -> some View {
        
        self
            .modifier(
                SimpleCardViewModifier(
                    padding: padding,
                    cornerRadius: cornerRadius,
                    background: background
                )
        )
    }
}

@available(iOS 13.0, *)
fileprivate struct SimpleCardViewModifier: ViewModifier {
    let padding: CGFloat
    let background: Color
    let cornerRadius: CGFloat
    
    init(
        padding: CGFloat,
        cornerRadius: CGFloat,
        background: Color
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.background = background
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(background)
            .cornerRadius(cornerRadius)
    }
}
