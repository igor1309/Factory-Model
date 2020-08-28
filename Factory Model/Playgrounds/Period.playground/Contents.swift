enum Period {
    case hour
    case shift(hours: Double = 8)
    case day(hours: Double = 8)
    case week(days: Double = 5, hoursPerDay: Double = 8)
    case month(days: Double = 21, hoursPerDay: Double = 8)
    
    var hours: Double {
        switch self {
            case .hour:
                return 1
            case .shift(let hours),
                 .day(let hours):
                return hours
            case let .week(days, hoursPerDay),
                 let .month(days, hoursPerDay):
                return days * hoursPerDay
        }
    }
    
    var allCases: [String] { ["hour", "shift", "day", "week", "month"] }
    
    /// non-failable initializer init: default is `month`
    init(_ period: String, days: Double = 0, hoursPerDay: Double = 8) {
        switch period {
            case "hour":  self = .hour
            case "shift": self = .shift(hours: hoursPerDay)
            case "day":   self = .day(hours: hoursPerDay)
            case "week":  self = .week(days: days, hoursPerDay: hoursPerDay)
            case "month": self = .month(days: days, hoursPerDay: hoursPerDay)
            default:      self = .month()
        }
    }
}

let pm1 = Period.month(days: 30)
let hours1 = pm1.hours
let pm2 = Period.month()
let pm3 = Period("week", days: 5)
let hours3 = pm3.hours
let pm4 = Period("shift")
