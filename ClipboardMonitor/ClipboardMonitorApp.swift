//
//  ClipboardMonitorApp.swift
//  ClipboardMonitor
//
//  Created by Emiel Deboyser on 14/12/2024.
//

import SwiftUI

@main
struct ClipboardMonitorApp: App {
    @StateObject private var clipboardManager = ClipboardManager()

    // Create the status bar item
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            CopieboardView()
                .environmentObject(clipboardManager)
                .onAppear {
                    clipboardManager.startMonitoring()
                }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var clipboardManager: ClipboardManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard Manager")
        }

        clipboardManager = ClipboardManager()
        clipboardManager?.startMonitoring()

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateMenu()
        }
    }

    func updateMenu() {
        guard let clipboardManager = clipboardManager else { return }

        let menu = NSMenu()
        for item in clipboardManager.clipboardItems {
            let menuItem = NSMenuItem(title: item, action: #selector(copyToClipboard(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = item // Attach the item for use in the action
            menu.addItem(menuItem)
        }

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc func copyToClipboard(_ sender: NSMenuItem) {
        if let item = sender.representedObject as? String {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(item, forType: .string)
        }
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}


