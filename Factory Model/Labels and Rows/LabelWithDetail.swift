//
//  LabelWithDetail.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct LabelWithDetail<T: StringProtocol, U: StringProtocol>: View {
    
    private let systemName: String?
    private let title: T
    private let detail: U
    
    init(
        _ systemName: String,
        _ title: T,
        _ detail: U
    ) {
        self.systemName = systemName
        self.title = title
        self.detail = detail
    }
    
    init(
        _ title: T,
        _ detail: U
    ) {
        self.systemName = nil
        self.title = title
        self.detail = detail
    }
    
    var body: some View {
        if let systemName = systemName {
            Label {
                HStack {
                    Text(title)
                    Spacer()
                    Text(detail)
                }
            } icon: {
                Image(systemName: systemName)
            }
        } else {
            HStack {
                Text(title)
                Spacer()
                Text(detail)
            }
        }
    }
}

struct LabelWithDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    LabelWithDetail("Title goes here", "detail")
                    
                    LabelWithDetail("wand.and.rays", "Title goes here", "detail")
                }
                .navigationBarTitle("LabelWithDetail in Form", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 345.0, height: 250))
            
            NavigationView {
                VStack {
                    LabelWithDetail("Title goes here", "detail")
                    
                    LabelWithDetail("wand.and.rays", "Title goes here", "detail")
                }
                .padding()
                .navigationBarTitle("LabelWithDetail in VStack", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 345.0, height: 250))
        }
        .environment(\.colorScheme, .dark)
    }
}
