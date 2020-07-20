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
