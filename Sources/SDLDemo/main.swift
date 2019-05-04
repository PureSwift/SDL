import CSDL2
import SDL

print("All Render Drivers:")
let renderDrivers = SDLRenderer.Driver.all
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

func main() throws {
    
    var isRunning = true
    
    try SDL.initialize(subSystems: [.video])
    
    defer { SDL.quit() }
    
    let windowSize = (width: 600, height: 480)
    
    let window = try SDLWindow(title: "SDLDemo",
                               frame: (x: .centered, y: .centered, width: windowSize.width, height: windowSize.height),
                               options: [.resizable, .shown])
    
    let framesPerSecond = try window.displayMode().refreshRate
    
    print("Running at \(framesPerSecond) FPS")
    
    // renderer
    let renderer = try SDLRenderer(window: window)
    
    var frame = 0
    
    var event = SDL_Event()
    
    var needsDisplay = true
    
    while isRunning {
        
        SDL_PollEvent(&event)
        
        // increment ticker
        frame += 1
        let startTime = SDL_GetTicks()
        let eventType = SDL_EventType(rawValue: event.type)
        
        switch eventType {
        case SDL_QUIT, SDL_APP_TERMINATING:
            isRunning = false
        case SDL_WINDOWEVENT:
            if event.window.event == UInt8(SDL_WINDOWEVENT_SIZE_CHANGED.rawValue) {
                needsDisplay = true
            }
        default:
            break
        }
        
        if needsDisplay {
            
            try renderer.setDrawColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 0xFF)
            try renderer.clear()
            
            let surface = try SDLSurface(rgb: (0, 0, 0, 0), size: (width: 1, height: 1), depth: 32)
            let color = SDLColor(
                format: try SDLPixelFormat(format: .argb8888),
                red: 25, green: 50, blue: .max, alpha: .max / 2
            )
            try surface.fill(color: color)
            let surfaceTexture = try SDLTexture(renderer: renderer, surface: surface)
            try surfaceTexture.setBlendMode([.alpha])
            try renderer.copy(surfaceTexture, destination: SDL_Rect(x: 100, y: 100, w: 200, h: 200))
            
            // render to screen
            renderer.present()
            
            print("Did redraw screen")
            
            needsDisplay = false
        }
        
        // sleep to save energy
        let frameDuration = SDL_GetTicks() - startTime
        if frameDuration < 1000 / UInt32(framesPerSecond) {
            SDL_Delay((1000 / UInt32(framesPerSecond)) - frameDuration)
        }
    }
}

do { try main() }
catch let error as SDLError {
    print("Error: \(error.debugDescription)")
    exit(EXIT_FAILURE)
}
catch {
    print("Error: \(error)")
    exit(EXIT_FAILURE)
}
