import CSDL2
import SDL

print("All Render Drivers:")
Renderer.Driver.all.forEach { dump($0) }

extension Optional {
    
    var sdlUnwrap: Wrapped {
        
        guard let value = self
            else { fatalError("SDL error: \(SDL.errorDescription ?? "")") }
        
        return value
    }
}

var isRunning = true

guard SDL.initialize(subSystems: [.video])
    else { fatalError("Could not setup SDL subsystems: \(SDL.errorDescription ?? "")") }

let windowSize = (width: 600, height: 480)

let window = Window(title: "SDLDemo", frame: (x: .centered, y: .centered, width: windowSize.width, height: windowSize.height), options: [.resizable, .shown]).sdlUnwrap

let framesPerSecond = UInt(window.displayMode?.refresh_rate ?? 60)

print("Running at \(framesPerSecond) FPS")

// renderer
let renderer = Renderer(window: window).sdlUnwrap
renderer.drawColor = (0xFF, 0xFF, 0xFF, 0xFF)

var frame = 0

var event = SDL_Event()

var needsDisplay = true

while isRunning {
    
    SDL_PollEvent(&event)
    
    // increment ticker
    frame += 1
    let startTime = SDL_GetTicks()
    
    if event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED.rawValue {
        
        needsDisplay = true
    }
    
    if needsDisplay {
        
        // get data for surface
        let imageSurface = Surface(rgb: windowSize, depth: 32).sdlUnwrap
        
        let texture = Texture(renderer: renderer, surface: imageSurface).sdlUnwrap
        
        // render to screen
        renderer.copy(texture)
        renderer.clear()
        renderer.present()
        
        print("Did redraw screen")
        
        needsDisplay = false
    }
    
    // sleep to save energy
    let frameDuration = SDL_GetTicks() - startTime
    if frameDuration < 1000 / framesPerSecond {
        SDL_Delay((1000 / UInt32(framesPerSecond)) - frameDuration)
    }
}

SDL.quit()
