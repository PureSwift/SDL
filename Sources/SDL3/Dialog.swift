//
//  Dialog.swift
//  SDL3
//

import CSDL3

/// A kind of file a file dialog offers.
public struct SDLDialogFileFilter: Equatable, Hashable, Sendable {

    /// The name shown to the user, like "Images".
    public var name: String

    /// The file name extensions that match, without dots; `["*"]` matches
    /// every file.
    public var extensions: [String]

    public init(name: String, extensions: [String]) {
        self.name = name
        self.extensions = extensions
    }
}

/// What a file dialog ended with.
public enum SDLDialogResult: Sendable {

    /// The paths chosen.
    case selected([String])

    /// The user closed the dialog without choosing.
    case cancelled

    case failed(SDLError)
}

public extension SDL {

    /// Shows the system's dialog for opening files.
    ///
    /// The dialog doesn't block: `completion` is called when it closes,
    /// perhaps on another thread. On some platforms it only shows while the
    /// app pumps events.
    ///
    /// - Parameter window: The window the dialog belongs to, if any.
    /// - Parameter defaultLocation: The folder or file the dialog starts at.
    static func showOpenFileDialog(
        window: SDLWindow? = nil,
        filters: [SDLDialogFileFilter] = [],
        defaultLocation: String? = nil,
        allowsMultiple: Bool = false,
        completion: @escaping @Sendable (SDLDialogResult) -> Void
    ) {
        let request = DialogRequest(filters: filters, completion: completion)
        SDL_ShowOpenFileDialog(
            dialogCallback, Unmanaged.passRetained(request).toOpaque(), window?.internalPointer,
            request.filters, Int32(request.count), defaultLocation, allowsMultiple
        )
    }

    /// Shows the system's dialog for choosing where to save a file. See
    /// `showOpenFileDialog`.
    static func showSaveFileDialog(
        window: SDLWindow? = nil,
        filters: [SDLDialogFileFilter] = [],
        defaultLocation: String? = nil,
        completion: @escaping @Sendable (SDLDialogResult) -> Void
    ) {
        let request = DialogRequest(filters: filters, completion: completion)
        SDL_ShowSaveFileDialog(
            dialogCallback, Unmanaged.passRetained(request).toOpaque(), window?.internalPointer,
            request.filters, Int32(request.count), defaultLocation
        )
    }

    /// Shows the system's dialog for choosing folders. See
    /// `showOpenFileDialog`.
    static func showOpenFolderDialog(
        window: SDLWindow? = nil,
        defaultLocation: String? = nil,
        allowsMultiple: Bool = false,
        completion: @escaping @Sendable (SDLDialogResult) -> Void
    ) {
        let request = DialogRequest(filters: [], completion: completion)
        SDL_ShowOpenFolderDialog(
            dialogCallback, Unmanaged.passRetained(request).toOpaque(), window?.internalPointer,
            defaultLocation, allowsMultiple
        )
    }
}

/// A dialog being shown: its filters, which SDL reads until it calls back,
/// and what to do with the result.
private final class DialogRequest: @unchecked Sendable {

    let completion: @Sendable (SDLDialogResult) -> Void

    let filters: UnsafeMutablePointer<SDL_DialogFileFilter>?

    let count: Int

    private var strings: [UnsafeMutablePointer<CChar>] = []

    init(filters: [SDLDialogFileFilter], completion: @escaping @Sendable (SDLDialogResult) -> Void) {
        self.completion = completion
        let named = filters.filter { !$0.extensions.isEmpty }
        count = named.count
        guard !named.isEmpty else {
            self.filters = nil
            return
        }
        let pointer = UnsafeMutablePointer<SDL_DialogFileFilter>.allocate(capacity: named.count)
        for (index, filter) in named.enumerated() {
            // SDL takes a filter's extensions separated by semicolons.
            let name = Self.copy(filter.name), pattern = Self.copy(filter.extensions.joined(separator: ";"))
            strings += [name, pattern]
            pointer[index] = SDL_DialogFileFilter(name: name, pattern: pattern)
        }
        self.filters = pointer
    }

    deinit {
        strings.forEach { $0.deallocate() }
        filters?.deallocate()
    }

    /// A C string that lives until it's deallocated.
    private static func copy(_ string: String) -> UnsafeMutablePointer<CChar> {
        let bytes = Array(string.utf8CString)
        let pointer = UnsafeMutablePointer<CChar>.allocate(capacity: bytes.count)
        pointer.initialize(from: bytes, count: bytes.count)
        return pointer
    }
}

/// Called by SDL when a dialog closes: with no list for an error, and an
/// empty one when the user chose nothing.
private let dialogCallback: SDL_DialogFileCallback = { userdata, list, _ in
    guard let userdata else { return }
    let request = Unmanaged<DialogRequest>.fromOpaque(userdata).takeRetainedValue()
    guard let list else {
        request.completion(.failed(SDLError.current() ?? SDLError(errorMessage: "The dialog failed")))
        return
    }
    var paths: [String] = []
    var index = 0
    while let path = list[index] {
        paths.append(String(cString: path))
        index += 1
    }
    request.completion(paths.isEmpty ? .cancelled : .selected(paths))
}
