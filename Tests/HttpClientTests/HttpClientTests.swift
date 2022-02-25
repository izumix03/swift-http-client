import XCTest

@testable import HttpClient

final class HttpClientTests: XCTestCase {
  func testExample() throws {
    XCTContext.runActivity(named: "uuid が違う場合") { _ in
      XCTAssertEqual(1 + 1, 2)
    }
  }
}
