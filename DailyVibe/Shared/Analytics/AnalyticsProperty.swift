import Foundation

enum AnalyticsProperty: Equatable, Sendable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)

    var anyValue: Any {
        switch self {
        case .string(let v): return v
        case .int(let v): return v
        case .double(let v): return v
        case .bool(let v): return v
        }
    }
}
