import Foundation
import XCTest
@testable import SDL1Swift

class SDL1Tests: XCTestCase {

    func testVersion() {

        let linked = SDLVersion.linked
        print("Linked SDL version:", linked)
        XCTAssertEqual(linked.major, 1)
        XCTAssertEqual(SDLVersion.compiled.major, 1)
        XCTAssertEqual(SDLVersion.compiled.minor, 2)
    }

    func testSubSystemFlags() {

        let subsystems: BitMaskOptionSet<SDL.SubSystem> = [.video, .audio]
        XCTAssert(subsystems.contains(.video))
        XCTAssert(subsystems.contains(.audio))
        XCTAssertFalse(subsystems.contains(.joystick))
    }

    func testMouseButton() {

        XCTAssertEqual(SDLMouseButton.left.rawValue, 1)
        XCTAssertEqual(SDLMouseButton.right.rawValue, 3)
    }
}
