//
//  ListRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct Row: Identifiable, Hashable, Comparable {
    var title: String
    var subtitle: String
    var detail: String? = nil
    var icon: String
    
    var id: String { title }
    
    static func < (lhs: Row, rhs: Row) -> Bool {
        lhs.title < rhs.title
    }
}


struct ListRow: View {
    
    var title: String
    var subtitle: String? = nil
    var detail: String? = nil
    var icon: String
    var useSmallerFont = false
    
    init(
        title: String,
        subtitle: String? = nil,
        detail: String? = nil,
        icon: String,
        useSmallerFont: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.icon = icon
        self.useSmallerFont = useSmallerFont
    }
    
    init(_ row: Row, useSmallerFont: Bool = false) {
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
                        .foregroundColor(.secondary)
                        .font(useSmallerFont ? .footnote : .subheadline)
                }
                
                if detail != nil {
                    Text(detail!)
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
            }
            .padding(.vertical, 3)
        } icon: {
            Image(systemName: icon)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ListRow(title: "title", icon: "crop")
            ListRow(title: "title2", subtitle: "subtitle", detail: "detail here", icon: "moon")
        }
        .preferredColorScheme(.dark)
    }
}
