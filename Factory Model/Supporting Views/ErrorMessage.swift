//
//  ValidationMessage.swift
//  Factory Model
//
//  Created by Igor Malyarov on 07.08.2020.
//

import SwiftUI
import CoreData

struct ErrorMessage<T: NSManagedObject & Managed & Validatable>: View {
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        if let errorMessage = entity.errorMessage {
            Text(errorMessage)
                .foregroundColor(.systemRed)
                .font(.subheadline)
        }
    }
}
