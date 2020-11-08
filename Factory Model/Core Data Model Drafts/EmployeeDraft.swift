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
    var period: Period

    let id = UUID()
}

extension EmployeeDraft {
    static var example: EmployeeDraft {
        EmployeeDraft(name: "Гоги", note: "Хороший парень", position: "Сыровар", salary: 37_000, workHours: 8, period: .day(hours: 8))
    }
}
