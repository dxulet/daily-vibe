import Testing
import Foundation
@testable import DailyVibe

struct RepositoryErrorTests {
    @Test("URLError without internet maps to .offline")
    func mapsOfflineFromURLError() {
        let urlErr = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        #expect(urlErr.asRepositoryError == .offline)
    }

    @Test("URLError timeout maps to .timedOut")
    func mapsTimeoutFromURLError() {
        let urlErr = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        #expect(urlErr.asRepositoryError == .timedOut)
    }

    @Test("DecodingError maps to .decoding")
    func mapsDecodingError() {
        let context = DecodingError.Context(codingPath: [], debugDescription: "")
        let err: Error = DecodingError.dataCorrupted(context)
        #expect(err.asRepositoryError == .decoding)
    }

    @Test("Already-typed RepositoryError passes through")
    func passesThroughTypedError() {
        let err: Error = RepositoryError.server(statusCode: 500)
        #expect(err.asRepositoryError == .server(statusCode: 500))
    }
}
