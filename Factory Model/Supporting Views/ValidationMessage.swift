//
//  ValidationMessage.swift
//  Factory Model
//
//  Created by Igor Malyarov on 07.08.2020.
//

import SwiftUI

struct ValidationMessage<T: Validatable>: View {
    var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        if !entity.isValid {
            Text(entity.validationMessage)
                .foregroundColor(.systemRed)
        }
    }
}
