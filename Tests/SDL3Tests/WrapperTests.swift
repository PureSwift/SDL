import Foundation
import XCTest
import CSDL3
@testable import SDL3Swift

/// The wrappers Cacao's host needs, run without a display: SDL's dummy
/// video driver and its software renderer.
final class WrapperTests: XCTestCase {

    override class func setUp() {
        setenv("SDL_VIDEO_DRIVER", "dummy", 1)
        setenv("SDL_RENDER_DRIVER", "software", 1)
    }

    private func withVideo(_ body: () throws -> Void) throws {
        try SDL.initialize(subSystems: [.video, .events])
        defer { SDL.quit() }
        try body()
    }

    // MARK: Version

    func testVersion() {
        let version = SDL.version
        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.description, "\(version.major).\(version.minor).\(version.micro)")
        XCTAssertEqual(SDLVersion(major: 3, minor: 4, micro: 12).rawValue, 3_004_012)
        XCTAssertLessThan(SDLVersion(major: 3, minor: 2, micro: 10), SDLVersion(major: 3, minor: 4, micro: 0))
    }

    // MARK: Events

    func testUserEventsAreQueuedAndPolled() throws {
        try withVideo {
            let type = try XCTUnwrap(SDL.registerEvents(count: 2))
            XCTAssertGreaterThanOrEqual(type, SDL_EVENT_USER.rawValue)
            XCTAssertTrue(SDL.pushUserEvent(type: type + 1, code: 42))
            var found = false
            while let event = SDL.pollEvent() {
                if case let .user(eventType, _, code) = event, eventType == type + 1 {
                    XCTAssertEqual(code, 42)
                    found = true
                }
            }
            XCTAssertTrue(found)
        }
    }

    func testAUserEventWakesAWaitFromAnotherThread() throws {
        try withVideo {
            let type = try XCTUnwrap(SDL.registerEvents())
            while SDL.pollEvent() != nil { }
            Thread.detachNewThread {
                Thread.sleep(forTimeInterval: 0.05)
                SDL.pushUserEvent(type: type, code: 7)
            }
            var woke = false
            let deadline = Date().addingTimeInterval(5)
            while !woke, Date() < deadline {
                if case let .user(eventType, _, code)? = SDL.waitEvent(timeout: 1000), eventType == type {
                    XCTAssertEqual(code, 7)
                    woke = true
                }
            }
            XCTAssertTrue(woke)
        }
    }

    func testEventsAreModeled() {
        func event(_ type: SDL_EventType, _ fill: (inout SDL_Event) -> Void = { _ in }) -> SDLEvent {
            var raw = SDL_Event()
            raw.type = type.rawValue
            fill(&raw)
            return SDLEvent(raw)
        }
        if case let .pinch(windowID, phase, scale) = event(SDL_EVENT_PINCH_UPDATE, { $0.pinch.scale = 1.5; $0.pinch.windowID = 3 }) {
            XCTAssertEqual(windowID, 3)
            XCTAssertEqual(phase, .updated)
            XCTAssertEqual(scale, 1.5)
        } else {
            XCTFail("a pinch isn't modeled")
        }
        "/tmp/file.txt".withCString { path in
            if case let .drop(_, drop) = event(SDL_EVENT_DROP_FILE, { $0.drop.data = path; $0.drop.x = 4; $0.drop.y = 5 }) {
                XCTAssertEqual(drop, .file(path: "/tmp/file.txt", x: 4, y: 5))
            } else {
                XCTFail("a dropped file isn't modeled")
            }
        }
        if case let .drop(_, drop) = event(SDL_EVENT_DROP_COMPLETE, { $0.drop.x = 1; $0.drop.y = 2 }) {
            XCTAssertEqual(drop, .completed(x: 1, y: 2))
        } else {
            XCTFail("a completed drop isn't modeled")
        }
        if case .systemThemeChanged = event(SDL_EVENT_SYSTEM_THEME_CHANGED) { } else {
            XCTFail("a theme change isn't modeled")
        }
        if case let .window(_, window) = event(SDL_EVENT_WINDOW_MOUSE_LEAVE) {
            XCTAssertEqual(window, .mouseLeave)
        } else {
            XCTFail("the pointer leaving isn't modeled")
        }
        if case let .window(_, window) = event(SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED) {
            XCTAssertEqual(window, .displayScaleChanged)
        } else {
            XCTFail("a display scale change isn't modeled")
        }
        // Types SDL doesn't use and the app didn't register stay unknown.
        if case .unknown = event(SDL_EventType(rawValue: 0x7000)) { } else {
            XCTFail("an unknown type was modeled")
        }
    }

    // MARK: Windows

    func testWindowState() throws {
        try withVideo {
            let window = try SDLWindow(title: "Test", width: 320, height: 240)
            XCTAssertNotEqual(window.properties.rawValue, 0)
            XCTAssertFalse(window.properties.has("org.pureswift.absent"))
            XCTAssertNil(window.properties.pointer("org.pureswift.absent"))
            let safe = try window.safeArea()
            XCTAssertEqual(safe.width, 320)
            XCTAssertEqual(safe.height, 240)
            XCTAssertNotEqual(SDL.globalProperties.rawValue, 0)
            // Text input, and where its candidates go.
            XCTAssertFalse(window.isTextInputActive)
            try window.startTextInput()
            XCTAssertTrue(window.isTextInputActive)
            try window.setTextInputArea(SDLRect(x: 10, y: 20, width: 100, height: 24), cursor: 3)
            try window.setTextInputArea(nil)
            try window.stopTextInput()
            XCTAssertFalse(window.isTextInputActive)
        }
    }

    func testPropertiesAreSetAndRead() throws {
        try withVideo {
            let properties = try SDLProperties.create()
            defer { properties.destroy() }
            try properties.setBoolean("org.pureswift.flag", true)
            try properties.setNumber("org.pureswift.count", 42)
            try properties.setString("org.pureswift.name", "Cacao")
            var value = 7
            try withUnsafeMutablePointer(to: &value) { pointer throws(SDLError) in
                try properties.setPointer("org.pureswift.pointer", UnsafeMutableRawPointer(pointer))
                XCTAssertEqual(properties.pointer("org.pureswift.pointer"), UnsafeMutableRawPointer(pointer))
            }
            XCTAssertTrue(properties.boolean("org.pureswift.flag"))
            XCTAssertEqual(properties.number("org.pureswift.count"), 42)
            XCTAssertEqual(properties.string("org.pureswift.name"), "Cacao")
            try properties.setString("org.pureswift.name", nil)
            XCTAssertFalse(properties.has("org.pureswift.name"))
        }
    }

    func testWindowsAreCreatedWithProperties() throws {
        try withVideo {
            let window = try SDLWindow { properties throws(SDLError) in
                try properties.setString(SDL_PROP_WINDOW_CREATE_TITLE_STRING, "Properties")
                try properties.setNumber(SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER, 200)
                try properties.setNumber(SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER, 100)
                try properties.setBoolean(SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN, true)
            }
            XCTAssertEqual(window.title, "Properties")
            XCTAssertEqual(window.size.width, 200)
            XCTAssertEqual(window.size.height, 100)
        }
    }

    func testAppMetadata() throws {
        try SDL.setAppMetadataProperty(SDL_PROP_APP_METADATA_IDENTIFIER_STRING, "org.pureswift.SDLTests")
        XCTAssertEqual(SDL.appMetadataProperty(SDL_PROP_APP_METADATA_IDENTIFIER_STRING), "org.pureswift.SDLTests")
        try SDL.setAppMetadataProperty(SDL_PROP_APP_METADATA_IDENTIFIER_STRING, nil)
        XCTAssertNil(SDL.appMetadataProperty(SDL_PROP_APP_METADATA_IDENTIFIER_STRING))
    }

    func testSystemState() throws {
        try withVideo {
            // Whatever they are, they're read without failing.
            _ = SDL.systemTheme
            _ = SDL.keyboardFocusWindowID
            _ = SDL.hasClipboardText
            XCTAssertEqual(TouchID(rawValue: 0xdead_beef).deviceType, .invalid)
        }
    }

    func testSystemCursors() throws {
        try withVideo {
            for cursor in SDLCursor.System.allCases {
                // A video driver without cursors has none to give.
                guard let created = try? SDLCursor(system: cursor) else { continue }
                SDL.setCursor(created)
            }
            SDL.setCursor(nil)
        }
    }

    // MARK: Drawing

    func testCustomBlendModes() {
        let mode = SDLCustomBlendMode.destinationIn
        let expected = SDL_ComposeCustomBlendMode(
            SDL_BLENDFACTOR_ZERO, SDL_BLENDFACTOR_SRC_ALPHA, SDL_BLENDOPERATION_ADD,
            SDL_BLENDFACTOR_ZERO, SDL_BLENDFACTOR_SRC_ALPHA, SDL_BLENDOPERATION_ADD
        )
        XCTAssertEqual(mode.rawValue, expected)
        XCTAssertNotEqual(mode.rawValue, 0)
        let other = SDLCustomBlendMode(
            sourceColorFactor: .one, destinationColorFactor: .oneMinusSourceAlpha, colorOperation: .subtract,
            sourceAlphaFactor: .one, destinationAlphaFactor: .one, alphaOperation: .maximum
        )
        XCTAssertNotEqual(other, mode)
    }

    func testPixelsAreReadBackAndConverted() throws {
        try withVideo {
            let window = try SDLWindow(title: "Test", width: 64, height: 48)
            let renderer = try SDLRenderer(window: window)
            try renderer.setDrawColor(red: 255, green: 128, blue: 0, alpha: 255)
            try renderer.clear()
            let whole = try renderer.readPixels()
            XCTAssertEqual(whole.width, 64)
            XCTAssertEqual(whole.height, 48)
            let part = try renderer.readPixels(SDLRect(x: 8, y: 8, width: 16, height: 4))
            XCTAssertEqual(part.width, 16)
            XCTAssertEqual(part.height, 4)
            // Bytes in R, G, B, A order.
            let rgba = try part.converted(to: .abgr8888)
            XCTAssertEqual(rgba.width, 16)
            let pixel = try rgba.withUnsafeMutableBytes { pixels in
                let bytes = pixels.assumingMemoryBound(to: UInt8.self)
                return [bytes[0], bytes[1], bytes[2], bytes[3]]
            }
            XCTAssertEqual(pixel, [255, 128, 0, 255])
        }
    }

    func testAMaskKeepsTheDestinationWhereTheSourceIsOpaque() throws {
        try withVideo {
            let window = try SDLWindow(title: "Test", width: 32, height: 32)
            let renderer = try SDLRenderer(window: window)
            let layer = try SDLTexture(renderer: renderer, format: .abgr8888, access: .target, width: 32, height: 32)
            let mask = try SDLTexture(renderer: renderer, format: .abgr8888, access: .target, width: 32, height: 32)
            // A mask opaque on its left half only.
            try renderer.setTarget(mask)
            try renderer.setDrawColor(red: 0, green: 0, blue: 0, alpha: 0)
            try renderer.clear()
            try renderer.setDrawColor(red: 255, green: 255, blue: 255, alpha: 255)
            try renderer.fill(SDLFRect(x: 0, y: 0, width: 16, height: 32))
            // A layer filled with blue, masked.
            try renderer.setTarget(layer)
            try renderer.setDrawColor(red: 0, green: 0, blue: 255, alpha: 255)
            try renderer.clear()
            guard (try? mask.setBlendMode(.destinationIn)) != nil else {
                throw XCTSkip("the renderer doesn't support the custom blend mode")
            }
            try renderer.copy(mask, to: SDLFRect(x: 0, y: 0, width: 32, height: 32))
            let pixels = try renderer.readPixels().converted(to: .abgr8888)
            let (left, right) = try XCTUnwrap(try pixels.withUnsafeMutableBytes { raw -> ([UInt8], [UInt8]) in
                let bytes = raw.assumingMemoryBound(to: UInt8.self)
                let row = 16 * pixels.pitch
                let l = row + 4 * 4, r = row + 28 * 4
                return ([bytes[l], bytes[l + 1], bytes[l + 2], bytes[l + 3]], [bytes[r], bytes[r + 1], bytes[r + 2], bytes[r + 3]])
            })
            XCTAssertEqual(left, [0, 0, 255, 255])
            XCTAssertEqual(right[3], 0)
            try renderer.setTarget(nil)
        }
    }

    // MARK: Tray and dialogs

    func testTrayMenus() throws {
        try withVideo {
            // Not every system has a tray, least of all a headless one.
            guard let tray = try? SDLTray(icon: nil, tooltip: "Test") else {
                throw XCTSkip("there's no system tray here")
            }
            let menu = try tray.menu()
            var chosen = 0
            let first = try menu.insert("First") { chosen += 1 }
            try menu.insert(nil)
            let check = try menu.insert("Check", kind: .checkbox(isChecked: true), isEnabled: false)
            XCTAssertEqual(menu.entries.count, 3)
            XCTAssertEqual(first.label, "First")
            XCTAssertTrue(check.isChecked)
            XCTAssertFalse(check.isEnabled)
            check.isEnabled = true
            XCTAssertTrue(check.isEnabled)
            first.click()
            XCTAssertEqual(chosen, 1)
            first.remove()
            XCTAssertEqual(menu.entries.count, 2)
            menu.removeAll()
            XCTAssertTrue(menu.entries.isEmpty)
        }
    }

    func testDialogFilters() {
        let filter = SDLDialogFileFilter(name: "Images", extensions: ["png", "jpg"])
        XCTAssertEqual(filter.name, "Images")
        XCTAssertEqual(filter, SDLDialogFileFilter(name: "Images", extensions: ["png", "jpg"]))
    }
}
