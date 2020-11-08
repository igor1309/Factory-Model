//
//  LabelWithDetailView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct LabelWithDetailView<T: StringProtocol, U: View>: View {
    
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
                    detail
                }
            } icon: {
                Image(systemName: systemName)
            }
        } else {
            HStack {
                Text(title)
                Spacer()
                detail
            }
        }
    }
}

struct LabelWithDetailView_Previews: PreviewProvider {
    static var detail: some View {
        Capsule()
            .foregroundColor(.purple)
            .frame(maxWidth: 64, maxHeight: 32)
    }
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    LabelWithDetailView("Title goes here", detail)
                    
                    LabelWithDetailView("wand.and.rays", "Title goes here", detail)
                }
                .navigationBarTitle("LabelWithDetailView in Form", displayMode: .inline)
            }
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/345.0/*@END_MENU_TOKEN@*/, height: 250))
            
            NavigationView {
                VStack {
                    LabelWithDetailView("Title goes here", detail)
                    
                    LabelWithDetailView("wand.and.rays", "Title goes here", detail)
                }
                .padding()
                .navigationBarTitle("LabelWithDetailView in VStack", displayMode: .inline)
            }
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/345.0/*@END_MENU_TOKEN@*/, height: 250))
        }
        .environment(\.colorScheme, .dark)
    }
}
