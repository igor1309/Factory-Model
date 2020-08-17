//
//  ListRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct EntityRow<T: ObservableObject & Summarizable>: View {
    @ObservedObject var entity: T
    
    var useSmallerFont: Bool
    
    init(_ entity: T, useSmallerFont: Bool = true) {
        self.entity = entity
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: entity.title,
            subtitle: entity.subtitle,
            detail: entity.detail,
            icon: T.icon,
            color: T.color,
            useSmallerFont: useSmallerFont
        )
    }
}

struct ListRow: View {
    
    let title: String
    var subtitle: String? = nil
    var detail: String? = nil
    let icon: String
    var color: Color
    let useSmallerFont: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        detail: String? = nil,
        icon: String,
        color: Color = .primary,
        useSmallerFont: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.icon = icon
        self.color = color
        self.useSmallerFont = useSmallerFont
    }
    
//    init<T: ObservableObject & Summarizable>(
//        _ object: T,
//        useSmallerFont: Bool = true
//    ) {
//        self.title = object.title
//        self.subtitle = object.subtitle
//        self.detail = object.detail
//        self.icon = T.icon
//        self.useSmallerFont = useSmallerFont
//    }

    init(
        _ row: Something,
        useSmallerFont: Bool = true
    ) {
        self.title = row.title
        self.subtitle = row.subtitle
        self.detail = row.detail
        self.icon = type(of: row).icon
        self.color = .primary
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    if title.hasPrefix("ERROR") {
                        Text(title)
                            .foregroundColor(.systemRed)
                    } else {
                        Text(title)
                    }
                }
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
                .foregroundColor(color)
        }
    }
}
