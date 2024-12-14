import Foundation
import XCTest
@testable import SDL

class SDLTests: XCTestCase {
    
    func testDrivers() {
        
        print("Available Render Drivers:")
        let renderDrivers = SDLRenderer.Driver.all
        XCTAssert(renderDrivers.count > 0)
        if renderDrivers.isEmpty == false {
            print("=======")
            for driver in renderDrivers {
                
                do {
                    let info = try SDLRenderer.Info(driver: driver)
                    print("Driver:", driver.rawValue)
                    print("Name:", info.name)
                    print("Options:")
                    info.options.forEach { print("  \($0)") }
                    print("Formats:")
                    info.formats.forEach { print("  \($0)") }
                    if info.maximumSize.width > 0 || info.maximumSize.height > 0 {
                        print("Maximum Size:")
                        print("  Width: \(info.maximumSize.width)")
                        print("  Height: \(info.maximumSize.height)")
                    }
                    print("=======")
                } catch {
                    print("Could not get information for driver \(driver.rawValue)")
                }
            }
        }
    }
}
