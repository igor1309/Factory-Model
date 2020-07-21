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
    
    init(
        title: String,
        subtitle: String? = nil,
        detail: String? = nil,
        icon: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.icon = icon
    }
    
    init(_ row: Row) {
        self.title = row.title
        self.subtitle = row.subtitle
        self.detail = row.detail
        self.icon = row.icon
    }
    
    var body: some View {
        //  MARK: - change to Label when it gets fixed alignment
        HStack {
            Image(systemName: icon)
                .padding(.trailing, 6)

            VStack(alignment: .leading, spacing: 3) {
                if detail != nil {
                    Text(detail!)
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
                
                Text(title)
                
                if subtitle != nil, !subtitle!.isEmpty {
                    Text(subtitle!)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }
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
