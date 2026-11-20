//
//  Tray.swift
//  SDL3
//

import CSDL3

/// An icon in the system tray (the menu bar's status area on macOS), with
/// a menu.
///
/// Trays are created, changed and destroyed on the main thread, where
/// their entries' actions are also called.
public final class SDLTray {

    // MARK: - Properties

    internal let internalPointer: OpaquePointer

    /// What each entry does, kept alive while the tray is.
    fileprivate var actions: [OpaquePointer: Action] = [:]

    fileprivate final class Action {
        let body: () -> Void
        init(_ body: @escaping () -> Void) { self.body = body }
    }

    // MARK: - Initialization

    deinit {
        SDL_DestroyTray(internalPointer)
    }

    /// Create a tray icon.
    ///
    /// - Parameter icon: The icon, or `nil` for the system's default.
    /// - Parameter tooltip: Text shown when the pointer rests on the icon.
    public init(icon: SDLSurface? = nil, tooltip: String? = nil) throws(SDLError) {
        self.internalPointer = try SDL_CreateTray(icon?.internalPointer, tooltip).sdlThrow(type: "SDLTray")
    }

    // MARK: - Methods

    public func setIcon(_ icon: SDLSurface?) {
        SDL_SetTrayIcon(internalPointer, icon?.internalPointer)
    }

    public func setTooltip(_ tooltip: String?) {
        SDL_SetTrayTooltip(internalPointer, tooltip)
    }

    /// The tray's menu, created the first time it's asked for.
    public func menu() throws(SDLError) -> Menu {
        let pointer = SDL_GetTrayMenu(internalPointer) ?? SDL_CreateTrayMenu(internalPointer)
        return Menu(internalPointer: try pointer.sdlThrow(type: "SDLTray"), tray: self)
    }

    /// Updates the system's tray icons. SDL does this as it pumps events;
    /// an app that doesn't pump events calls it itself.
    public static func update() {
        SDL_UpdateTrays()
    }
}

// MARK: - Menu

public extension SDLTray {

    /// A tray's menu, or the submenu of one of its entries.
    struct Menu {

        internal let internalPointer: OpaquePointer

        internal let tray: SDLTray

        /// The menu's entries, in order.
        public var entries: [Entry] {
            var count: Int32 = 0
            guard let pointers = SDL_GetTrayEntries(internalPointer, &count) else { return [] }
            return (0..<Int(count)).compactMap { index in
                pointers[index].map { Entry(internalPointer: $0, tray: tray) }
            }
        }

        /// Adds an entry.
        ///
        /// - Parameter label: The entry's text, or `nil` for a separator.
        /// - Parameter position: Where to insert it, or `nil` for the end.
        @discardableResult
        public func insert(
            _ label: String?,
            kind: Entry.Kind = .button,
            isEnabled: Bool = true,
            at position: Int? = nil,
            action: (() -> Void)? = nil
        ) throws(SDLError) -> Entry {
            var flags: SDL_TrayEntryFlags
            switch kind {
            case .button: flags = SDL_TRAYENTRY_BUTTON
            case let .checkbox(isChecked): flags = SDL_TRAYENTRY_CHECKBOX | (isChecked ? SDL_TRAYENTRY_CHECKED : 0)
            case .submenu: flags = SDL_TRAYENTRY_SUBMENU
            }
            if !isEnabled {
                flags |= SDL_TRAYENTRY_DISABLED
            }
            let pointer = SDL_InsertTrayEntryAt(internalPointer, Int32(position ?? -1), label, flags)
            let entry = Entry(internalPointer: try pointer.sdlThrow(type: "SDLTray.Menu"), tray: tray)
            if let action {
                entry.setAction(action)
            }
            return entry
        }

        /// Removes every entry.
        public func removeAll() {
            for entry in entries.reversed() {
                entry.remove()
            }
        }
    }
}

// MARK: - Entry

public extension SDLTray {

    /// An entry of a tray's menu.
    struct Entry {

        internal let internalPointer: OpaquePointer

        internal let tray: SDLTray

        /// What an entry is.
        public enum Kind: Equatable, Sendable {
            case button
            case checkbox(isChecked: Bool)
            /// An entry that opens a menu of its own; see `submenu()`.
            case submenu
        }

        /// The entry's text; `nil` for a separator.
        public var label: String? {
            get { SDL_GetTrayEntryLabel(internalPointer).map { String(cString: $0) } }
            nonmutating set { SDL_SetTrayEntryLabel(internalPointer, newValue) }
        }

        public var isEnabled: Bool {
            get { SDL_GetTrayEntryEnabled(internalPointer) }
            nonmutating set { SDL_SetTrayEntryEnabled(internalPointer, newValue) }
        }

        /// Whether a checkbox entry is checked.
        public var isChecked: Bool {
            get { SDL_GetTrayEntryChecked(internalPointer) }
            nonmutating set { SDL_SetTrayEntryChecked(internalPointer, newValue) }
        }

        /// Sets what the entry does when it's chosen, on the main thread.
        public func setAction(_ action: @escaping () -> Void) {
            let box = SDLTray.Action(action)
            tray.actions[internalPointer] = box
            SDL_SetTrayEntryCallback(internalPointer, { userdata, _ in
                guard let userdata else { return }
                Unmanaged<SDLTray.Action>.fromOpaque(userdata).takeUnretainedValue().body()
            }, Unmanaged.passUnretained(box).toOpaque())
        }

        /// The entry's submenu, created the first time it's asked for. The
        /// entry must be of the `submenu` kind.
        public func submenu() throws(SDLError) -> Menu {
            let pointer = SDL_GetTraySubmenu(internalPointer) ?? SDL_CreateTraySubmenu(internalPointer)
            return Menu(internalPointer: try pointer.sdlThrow(type: "SDLTray.Entry"), tray: tray)
        }

        /// Chooses the entry, as if the user had.
        public func click() {
            SDL_ClickTrayEntry(internalPointer)
        }

        /// Removes the entry from its menu.
        public func remove() {
            tray.actions[internalPointer] = nil
            SDL_RemoveTrayEntry(internalPointer)
        }
    }
}
