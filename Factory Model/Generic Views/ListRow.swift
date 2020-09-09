//
//  ListRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct EntityRow<T: ObservableObject & Summarizable>: View {
    @ObservedObject var entity: T
    
    let useSmallerFont: Bool
    let period: Period
    
    init(_ entity: T, useSmallerFont: Bool = true, in period: Period) {
        self.entity = entity
        self.useSmallerFont = useSmallerFont
        self.period = period
    }
    
    var body: some View {
        ListRow(
            title: entity.title(in: period),
            subtitle: entity.subtitle(in: period),
            detail: entity.detail(in: period),
            icon: T.icon,
            color: T.color,
            useSmallerFont: useSmallerFont
        )
    }
}

struct ListRow: View {
    
    let title: String
    var subtitle: String
    var detail: String
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
        self.subtitle = subtitle ?? ""
        self.detail = detail ?? ""
        self.icon = icon
        self.color = color
        self.useSmallerFont = useSmallerFont
    }
    
    init<T: Summarizable>(
        _ item: T,
        useSmallerFont: Bool = true,
        period: Period = .month()
    ) {
        self.title = item.title(in: period)
        self.subtitle = item.subtitle(in: period)
        self.detail = item.detail(in: period) ?? ""
        self.icon = T.icon
        self.color = T.color
        self.useSmallerFont = useSmallerFont
    }

    init(
        _ row: Something,
        useSmallerFont: Bool = true,
        period: Period = .month()
    ) {
        self.title = row.title(in: period)
        self.subtitle = row.subtitle(in: period)
        self.detail = row.detail(in: period) ?? ""
        self.icon = type(of: row).icon
        self.color = .primary
        self.useSmallerFont = useSmallerFont
    }
    
    private var hasTitleOnly: Bool {
        subtitle.isEmpty && detail.isEmpty
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
                            .foregroundColor(color)
                    }
                }
                .font(useSmallerFont ? .subheadline : .headline)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundColor(subtitle.hasPrefix("ERROR") ? .systemRed : .secondary)
                        .font(useSmallerFont ? .footnote : .subheadline)
                }
                
                if !detail.isEmpty {
                    Text(detail)
                        .foregroundColor(detail.hasPrefix("ERROR") ? .systemRed : .secondary)
                        .font(.caption2)
                }
            }
            .padding(.vertical, 3)
        } icon: {
            Image(systemName: icon)
                .foregroundColor(color)
                .offset(y: hasTitleOnly ? 0 : 3)
        }
    }
}
