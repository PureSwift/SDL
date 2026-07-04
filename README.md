# SDL
Swift library for SDL2 and SDL3

Each capability is its own product, so clients only pull in the dependencies (and system
libraries) they actually need:

- `SDL2Swift` / `SDL3Swift`: Swift wrapper for [SDL2](https://www.libsdl.org/) / [SDL3](https://www.libsdl.org/) core.
- `SDL2Image` / `SDL3Image`: Swift wrapper for image loading via [SDL_image](https://github.com/libsdl-org/SDL_image), depends on `SDL2Swift` / `SDL3Swift`.
- `SDL2Mixer`: Swift wrapper for [SDL_mixer](https://github.com/libsdl-org/SDL_mixer)'s classic `Mix_*` audio API, depends on `SDL2Swift`.
- `SDL3Mixer`: Swift wrapper for `SDL_mixer`'s new `MIX_*` audio API, depends on `SDL3Swift`.
- `CSDL2Image` / `CSDL3Image`: raw C module for `SDL_image`, for direct interop.
- `CSDL2Mixer` / `CSDL3Mixer`: raw C module for `SDL_mixer`, for direct interop.
