import XCTest
@testable import swift_http_client

final class swift_http_clientTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_http_client().text, "Hello, World!")
    }
}
