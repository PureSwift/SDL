import CSDL2
import SDL

print("Hello world")

var isRunning = true

guard SDL.initialize(subSystems: [.video])
    else { fatalError("Could not setup SDL subsystems: \(SDL.errorDescription ?? "")") }

let windowSize = (width: 600, height: 480)

let window = Window(title: "Demo", frame: (x: .centered, y: .centered, width: windowSize.width, height: windowSize.height), options: [.resizable, .shown, .opengl])!

let framesPerSecond = UInt(window.displayMode?.refresh_rate ?? 60)

print("Running at \(framesPerSecond) FPS")

// offscreen surface (for rendering)
let imageSurface = Surface(rgb: windowSize, depth: 32)!

/// onscreen surface
let windowSurface = Surface(window: window)!


//renderer.drawColor = (0xFF, 0xFF, 0xFF, 0xFF)

var frame = 0

while isRunning {
    
    // increment ticker
    frame += 1
    let startTime = SDL_GetTicks()
    
    // get data for surface
    
    var needsDisplay = true
    
    if needsDisplay {
        
        // render to screen
        imageSurface.blit(to: windowSurface)
        window.updateSurface()
    }
    
    // sleep to save energy
    let frameDuration = SDL_GetTicks() - startTime
    if frameDuration < 1000 / framesPerSecond {
        SDL_Delay((1000 / UInt32(framesPerSecond)) - frameDuration)
    }
}

SDL.quit()
