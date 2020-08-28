//
//  Employee.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Employee {
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    
    var position: String {
        get { position_ ?? ""}
        set { position_ = newValue }
    }
    
    var salaryWithTax: Double {
        salary * 1.302
    }
    
    var period: Period {
        get {
            Period(periodStr_ ?? "month", days: Int(days), hoursPerDay: hoursPerDay) ?? .month()
        }
        set {
            periodStr_ = newValue.periodStr
            days = Int16(newValue.days)
            hoursPerDay = newValue.hoursPerDay
        }
    }
    
    func salaryExTax(in period: Period) -> Double {
        salary / self.period.hours * period.hours
    }
    
    func salaryWithTax(in period: Period) -> Double {
        salaryWithTax / self.period.hours * period.hours
    }
    
    func workHours(in period: Period) -> Double {
        workHours / self.period.hours * period.hours
    }
}

extension Employee: Comparable {
    public static func < (lhs: Employee, rhs: Employee) -> Bool {
        lhs.position < rhs.position
            && lhs.name < rhs.name
    }
}
