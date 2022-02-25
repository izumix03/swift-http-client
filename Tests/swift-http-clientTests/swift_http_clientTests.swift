import XCTest
@testable import swift_http_client

final class swift_http_clientTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(swift_http_client().text, "Hello, World!")
    }
}
