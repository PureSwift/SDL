//
//  Surface.swift
//  SDLTests
//
//  Created by Alsey Coleman Miller on 6/6/17.
//

import CSDL2

public final class Surface {
    
    // MARK: - Properties
    
    let internalPointer: UnsafeMutablePointer<SDL_Surface>
    
    // MARK: - Initialization
    
    deinit {
        
        SDL_FreeSurface(internalPointer)
    }
    
    public init(rgb: ) {
        
        guard let internalPointer = SDL_CreateRGBSurface(<#T##flags: Uint32##Uint32#>, <#T##width: Int32##Int32#>, <#T##height: Int32##Int32#>, <#T##depth: Int32##Int32#>, <#T##Rmask: Uint32##Uint32#>, <#T##Gmask: Uint32##Uint32#>, <#T##Bmask: Uint32##Uint32#>, <#T##Amask: Uint32##Uint32#>)
    }
}
