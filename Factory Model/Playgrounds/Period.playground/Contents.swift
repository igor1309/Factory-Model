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
                return "Shift: \(String(repeating: "%g", count: Int(hours))) hours."
            case .day(let hours):
                return "Day: \(String(repeating: "%g", count: Int(hours))) hours."
            case let .week(days, hoursPerDay):
                summary = "Week: \(days) days, \(String(repeating: "%g", count: Int(hoursPerDay))) hours per day."
            case let .month(days, hoursPerDay):
                summary = "Month: \(days) days, \(String(repeating: "%g", count: Int(hoursPerDay))) hours per day."
            case let .year(days, hoursPerDay):
                summary = "Year: \(days) days, \(String(repeating: "%g", count: Int(hoursPerDay))) hours per day."
        }
        
        return "\(summary) Total \(String(repeating: "%g", count: Int(self.hours))) hours."
    }
    
    var short: String {
        switch self {
            case .hour:
                return "1 hour"
            case .shift(let hours):
                return "Shift: \(String(repeating: "%g", count: Int(hours)))h"
            case .day(let hours):
                return "Day: \(String(repeating: "%g", count: Int(hours)))h"
            case let .week(days, hoursPerDay):
                return "Week: \(days)d x \(String(repeating: "%g", count: Int(hoursPerDay)))h"
            case let .month(days, hoursPerDay):
                return "Month: \(days)d x \(String(repeating: "%g", count: Int(hoursPerDay)))h"
            case let .year(days, hoursPerDay):
                return "Year: \(days)d x \(String(repeating: "%g", count: Int(hoursPerDay)))h"
        }
    }
    
    var brief: String {
        switch self {
            case .hour:
                return "hourly"
            case .shift(let hours):
                return "shiftly /\(String(repeating: "%g", count: Int(hours)))h"
            case .day(let hours):
                return "daily /\(String(repeating: "%g", count: Int(hours)))h"
            case let .week(days, hoursPerDay):
                return "weekly /\(days)d x \(String(repeating: "%g", count: Int(hoursPerDay)))h"
            case let .month(days, hoursPerDay):
                return "monthly /\(days)d x \(String(repeating: "%g", count: Int(hoursPerDay)))h"
            case let .year(days, hoursPerDay):
                return "yearly /\(days)d x \(String(repeating: "%g", count: Int(hoursPerDay)))h"
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
    
    static var allCases: [String] { ["hour", "shift", "day", "week", "month", "year"] }
    
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
}


//let pm1 = Period.month(days: 30)
//let hours1 = pm1.hours
//let pm2 = Period.month()
//let pm3 = Period("week", days: 5) ?? .week()
//let pm4 = Period("shift")
let pm5 = Period("year", days: 267)
