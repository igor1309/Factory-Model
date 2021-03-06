//
//  Period.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.08.2020.
//

enum Period: Hashable {
    case hour
    case shift(hours: Double = 8)
    case day(hours: Double = 8)
    case week(days: Int = 5, hoursPerDay: Double = 8)
    case month(days: Int = 21, hoursPerDay: Double = 8)
    /// В РФ за последние 5 лет в среднем 247 рабочих дней https://allcalc.ru/node/1122
    case year(days: Int = 247, hoursPerDay: Double = 8)
    
    var hours: Double {
        switch self {
            case .hour:
                return 1
            case .shift(let hours),
                 .day(let hours):
                return hours
            case let .week(days, hoursPerDay),
                 let .month(days, hoursPerDay),
                 let .year(days, hoursPerDay):
                return Double(days) * hoursPerDay
        }
    }
    
    var summary: String {
        let summary: String
        switch self {
            case .hour:
                return "1 hour."
            case .shift(let hours):
                return "Shift: \(String(format: "%g", hours)) hours."
            case .day(let hours):
                return "Day: \(String(format: "%g", hours)) hours."
            case let .week(days, hoursPerDay):
                summary = "Week: \(days) days, \(String(format: "%g", hoursPerDay)) hours per day."
            case let .month(days, hoursPerDay):
                summary = "Month: \(days) days, \(String(format: "%g", hoursPerDay)) hours per day."
            case let .year(days, hoursPerDay):
                summary = "Year: \(days) days, \(String(format: "%g", hoursPerDay)) hours per day."
        }
        
        return "\(summary) Total \(String(format: "%g", self.hours)) hours."
    }
    
    var short: String {
        switch self {
            case .hour:
                return "1 hour"
            case .shift(let hours):
                return "Shift: \(String(format: "%g", hours))h"
            case .day(let hours):
                return "Day: \(String(format: "%g", hours))h"
            case let .week(days, hoursPerDay):
                return "Week: \(days)d x \(String(format: "%g", hoursPerDay))h"
            case let .month(days, hoursPerDay):
                return "Month: \(days)d x \(String(format: "%g", hoursPerDay))h"
            case let .year(days, hoursPerDay):
                return "Year: \(days)d x \(String(format: "%g", hoursPerDay))h"
        }
    }
    
    var brief: String {
        switch self {
            case .hour:
                return "hourly"
            case .shift(let hours):
                return "shiftly /\(String(format: "%g", hours))h"
            case .day(let hours):
                return "daily /\(String(format: "%g", hours))h"
            case let .week(days, hoursPerDay):
                return "weekly /\(days)d x \(String(format: "%g", hoursPerDay))h"
            case let .month(days, hoursPerDay):
                return "monthly /\(days)d x \(String(format: "%g", hoursPerDay))h"
            case let .year(days, hoursPerDay):
                return "yearly /\(days)d x \(String(format: "%g", hoursPerDay))h"
        }
    }
    
    var periodStr: String {
        switch self {
            case .hour:        return "hour"
            case .shift(_):    return "shift"
            case .day(_):      return "day"
            case .week(_, _):  return "week"
            case .month(_, _): return "month"
            case .year(_, _):  return "year"
        }
    }
    
    var days: Int {
        switch self {
            case .hour,
                 .shift(_),
                 .day(_):               return 0
            case let .week(days, _),
                 let .month(days, _),
                 let .year(days, _):   return days
        }
    }
    
    var hoursPerDay: Double {
        switch self {
            case .hour:                         return 1
            case .shift(let hours),
                 .day(let hours):               return hours
            case let .week(_, hoursPerDay),
                 let .month(_, hoursPerDay),
                 let .year(_, hoursPerDay):     return hoursPerDay
        }
    }

    static let allCases: [String] = ["hour", "shift", "day", "week", "month", "year"]
    static let allCasesShort: [String] = ["H", "S", "D", "W", "M", "Y"]

    ///  failable initializer
    init?(_ period: String, days: Int = 0, hoursPerDay: Double = 8) {
        guard 1...24 ~= hoursPerDay else { return nil }
        
        switch period {
            case "hour":  self = .hour
            case "shift": self = .shift(hours: hoursPerDay)
            case "day":   self = .day(hours: hoursPerDay)
                
            case "week":
                guard 1...7 ~= days else { return nil }
                self = .week(days: days, hoursPerDay: hoursPerDay)
            case "month":
                guard 1...31 ~= days else { return nil }
                self = .month(days: days, hoursPerDay: hoursPerDay)
            case "year":
                guard 200...360 ~= days else { return nil }
                self = .year(days: days, hoursPerDay: hoursPerDay)
                
            default: return nil
        }
    }

    /// non-failable initializer init: default is `month`
    private init(period: String, days: Int = 0, hoursPerDay: Double = 8) {
        guard 1...24 ~= hoursPerDay else {
            self = .month()
            return
        }
        
        switch period {
            case "hour":  self = .hour
            case "shift": self = .shift(hours: hoursPerDay)
            case "day":   self = .day(hours: hoursPerDay)
                
            case "week":
                guard 1...7 ~= days else {
                    self = .month()
                    return
                }
                self = .week(days: days, hoursPerDay: hoursPerDay)
            case "month":
                guard 1...31 ~= days else {
                    self = .month()
                    return
                }
                self = .month(days: days, hoursPerDay: hoursPerDay)
            case "year":
                guard 200...360 ~= days else {
                    self = .month()
                    return
                }
                self = .year(days: days, hoursPerDay: hoursPerDay)
                
            default: self = .month()
        }
    }

    static let hoursPerDayOptions: [Double] = [4.0, 6, 8, 10, 12, 16, 20, 24]

    static func dayOptions(for periodStr: String) -> [Int] {
        switch periodStr {
            case "week":    return [3, 4, 5, 6, 7]
            case "month":   return [14, 21, 24, 30]
            case "year":    return [247, 300, 360]
            default:        return []
        }
    }
}
