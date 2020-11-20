//
//  SectionAsStackOrGroup.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.11.2020.
//

import SwiftUI

struct SectionAsStackOrGroup<V: View>: View {
    let header: String
    let labelGroup: V
    let asStack: Bool
    
    var body: some View {
        Section(header: Text(header)) {
            if asStack {
                /// no icons
                VStack(spacing: 6) {
                    labelGroup
                }
                .foregroundColor(.secondary)
                .font(.footnote)
                .padding(.vertical, 3)
            } else {
                labelGroup
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
    }
}


struct SectionAsStackOrGroup_Previews: PreviewProvider {
    static func labelGroup(asStack: Bool) -> some View {
        Group {
            LabelWithDetail(
                asStack ? nil : "scalemass",
                "Sales Weight Netto, t",
                "3 t"
            )
            LabelWithDetail(
                asStack ? nil : "scalemass",
                "Sales Weight Netto, t",
                "3 t"
            )
            LabelWithDetail(
                asStack ? nil : "scalemass",
                "Sales Weight Netto, t",
                "3 t"
            )
        }
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    SectionAsStackOrGroup(header: "Test", labelGroup: labelGroup(asStack: true), asStack: true)
                }
            }
            .previewLayout(.fixed(width: 350, height: 300))
            
            NavigationView {
                Form {
                    SectionAsStackOrGroup(header: "Test", labelGroup: labelGroup(asStack: false), asStack: false)
                }
            }
            .previewLayout(.fixed(width: 350, height: 400))
        }
        .preferredColorScheme(.dark)
    }
}
