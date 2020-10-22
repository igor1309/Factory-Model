//
//  Periodable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.08.2020.
//

import Foundation

protocol Periodable {
    dynamic var periodStr_: String? { get set }
    dynamic var days: Int16 { get set }
    dynamic var hoursPerDay: Double { get set }
    
    var period: Period { get set }
}

extension Periodable {
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
}

extension Employee: Periodable {}
extension Expenses: Periodable {}
extension Product: Periodable {
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
}
extension Sales: Periodable {}
