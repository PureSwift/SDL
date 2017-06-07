import XCTest
@testable import SDL

class SDLTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SDL().text, "Hello, World!")
    }


    static var allTests: [(String, (SDLTests) -> () -> Void)] = [
        ("testExample", testExample),
    ]
}
