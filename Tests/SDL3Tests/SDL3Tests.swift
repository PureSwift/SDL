import Foundation
import XCTest
@testable import SDL3Swift

class SDL3Tests: XCTestCase {

    func testDrivers() {

        print("Available Render Drivers:")
        let renderDrivers = SDLRenderer.Driver.all
        XCTAssert(renderDrivers.count > 0)
        if renderDrivers.isEmpty == false {
            print("=======")
            for driver in renderDrivers {
                print("Driver:", driver.rawValue)
            }
            print("=======")
        }
    }
}
