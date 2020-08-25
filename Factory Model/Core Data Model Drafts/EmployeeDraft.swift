//
//  EmployeeDraft.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import Foundation

struct EmployeeDraft: Identifiable {
    var name: String
    var note: String
    var position: String
    var salary: Double
    var workHours: Double

    var id = UUID()
}
