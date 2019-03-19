import XCTest
@testable import unilog

final class unilogTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(unilog().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
