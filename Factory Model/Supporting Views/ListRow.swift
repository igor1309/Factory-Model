//
//  ListRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct ListRow: View {
    
    var title: String
    var subtitle: String? = nil
    var detail: String? = nil
    var icon: String
    var useSmallerFont: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        detail: String? = nil,
        icon: String,
        useSmallerFont: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.icon = icon
        self.useSmallerFont = useSmallerFont
    }
    
    init<T: Summarable & ObservableObject>(
        _ object: T,
        useSmallerFont: Bool = true
    ) {
        self.title = object.title
        self.subtitle = object.subtitle
        self.detail = object.detail
        self.icon = object.icon
        self.useSmallerFont = useSmallerFont
        
    }

    init(_ row: Summarable, useSmallerFont: Bool = true) {
        self.title = row.title
        self.subtitle = row.subtitle
        self.detail = row.detail
        self.icon = row.icon
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(useSmallerFont ? .subheadline : .headline)
                
                if subtitle != nil, !subtitle!.isEmpty {
                    Text(subtitle!)
                        .foregroundColor(subtitle!.hasPrefix("ERROR") ? .systemRed : .secondary)
                        .font(useSmallerFont ? .footnote : .subheadline)
                }
                
                if detail != nil, !detail!.isEmpty {
                    Text(detail!)
                        .foregroundColor(detail!.hasPrefix("ERROR") ? .systemRed : .secondary)
                        .font(.caption2)
                }
            }
            .padding(.vertical, 3)
        } icon: {
            Image(systemName: icon)
        }
    }
}
