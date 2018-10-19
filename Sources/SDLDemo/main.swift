import CSDL2
import SDL

print("All Render Drivers:")
let renderDrivers = SDLRenderDrivers()
renderDrivers.forEach { dump($0) }

func main() throws {
    
    var isRunning = true
    
    try SDL.initialize(subSystems: [.video])
    
    defer { SDL.quit() }
    
    let windowSize = (width: 600, height: 480)
    
    let window = try SDLWindow(title: "SDLDemo",
                               frame: (x: .centered, y: .centered, width: windowSize.width, height: windowSize.height),
                               options: [.resizable, .shown])
    
    let framesPerSecond = UInt(window.displayMode?.refresh_rate ?? 60)
    
    print("Running at \(framesPerSecond) FPS")
    
    // renderer
    let renderer = try SDLRenderer(window: window)
    try renderer.setDrawColor((0xFF, 0xFF, 0xFF, 0xFF))
    
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
            
            // get data for surface
            let textureSize = (width: 100, height: 100)
            let imageSurface = Surface(rgb: textureSize, depth: 32)!
            
            let texture = SDL.Texture(renderer: renderer, surface: imageSurface).sdlUnwrap
            
            // render to screen
            renderer.clear()
            renderer.copy(texture, destination: SDL_Rect(x: 50, y: 50, w: Int32(textureSize.width), h: Int32(textureSize.height)))
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
catch { fatalError("SDL failed: \(error)") }
