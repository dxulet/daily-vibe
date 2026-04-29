import Foundation

enum RepositoryError: Error, Equatable, Sendable {
    case offline
    case timedOut
    case server(statusCode: Int)
    case decoding
    case unknown

    var userMessage: String {
        switch self {
        case .offline: return "You're offline. Reconnect to refresh."
        case .timedOut: return "Took too long to load. Try again."
        case .server: return "We're having trouble right now."
        case .decoding: return "Couldn't read the response."
        case .unknown: return "Something went wrong."
        }
    }
}

extension Error {
    var asRepositoryError: RepositoryError {
        if let typed = self as? RepositoryError { return typed }
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorDataNotAllowed:
                return .offline
            case NSURLErrorTimedOut:
                return .timedOut
            default:
                return .unknown
            }
        }
        if self is DecodingError { return .decoding }
        return .unknown
    }
}
