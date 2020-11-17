//
//  ListRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct EntityRow<T: ObservableObject & Summarizable>: View {
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var entity: T
    
    let smallFont: Bool
    
    init(_ entity: T, smallFont: Bool = true) {
        self.entity = entity
        self.smallFont = smallFont
    }
    
    var body: some View {
        ListRow(
            title: entity.title(in: settings.period),
            subtitle: entity.subtitle(in: settings.period),
            detail: entity.detail(in: settings.period),
            icon: T.icon,
            color: T.color,
            smallFont: smallFont
        )
    }
}

struct ListRow: View {
    
    let title: String
    var subtitle: String
    var detail: String
    let icon: String
    var color: Color
    let smallFont: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        detail: String? = nil,
        icon: String,
        color: Color = .primary,
        smallFont: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle ?? ""
        self.detail = detail ?? ""
        self.icon = icon
        self.color = color
        self.smallFont = smallFont
    }
    
    init<T: Summarizable>(
        _ item: T,
        smallFont: Bool = true,
        period: Period
    ) {
        self.title = item.title(in: period)
        self.subtitle = item.subtitle(in: period)
        self.detail = item.detail(in: period) ?? ""
        self.icon = T.icon
        self.color = T.color
        self.smallFont = smallFont
    }

    init(
        _ row: Something,
        smallFont: Bool = true,
        period: Period = .month()
    ) {
        self.title = row.title(in: period)
        self.subtitle = row.subtitle(in: period)
        self.detail = row.detail(in: period) ?? ""
        self.icon = type(of: row).icon
        self.color = .primary
        self.smallFont = smallFont
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
                .font(smallFont ? .subheadline : .headline)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundColor(subtitle.hasPrefix("ERROR") ? .systemRed : .secondary)
                        .font(smallFont ? .footnote : .subheadline)
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
        .contentShape(Rectangle())
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EntityRow(Product.example)
                .environmentObject(Settings())
            
            ListRow(Base.example, period: .month())
            
            ListRow(Product.example, smallFont: true, period: .month())
            ListRow(Product.example, smallFont: false, period: .month())
            
            
            ListRow(title: "Title", icon: "bag")
            
            ListRow(title: "Title", subtitle: "Subtitle, could be empty", detail: "Detail, could be empty", icon: "folder.circle", color: .green, smallFont: true)
            ListRow(title: "Title", subtitle: "Subtitle, could be empty", detail: "Detail, could be empty", icon: "folder.circle", color: .green, smallFont: false)

            ListRow(Something(id: UUID(), title: "Title", detail: "Detail, could be empty", qty: 1234, cost: 321))
            ListRow(Something(id: UUID(), title: "Title", detail: "Detail, could be empty", qty: 1234, cost: 321), smallFont: false, period: .month())
        }
        .preferredColorScheme(.dark)
    }
}
