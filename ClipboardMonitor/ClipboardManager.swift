import Cocoa
import SwiftUI

class ClipboardManager: ObservableObject {
    @Published var clipboardItems: [String] = [] // Stores copied items
    private var changeCount = NSPasteboard.general.changeCount

    func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let pasteboard = NSPasteboard.general
            if pasteboard.changeCount != self.changeCount {
                self.changeCount = pasteboard.changeCount
                if let newString = pasteboard.string(forType: .string) {
                    // Add the new copied item to the list
                    DispatchQueue.main.async {
                        if !self.clipboardItems.contains(newString) {
                            self.clipboardItems.insert(newString, at: 0)
                        }
                    }
                }
            }
        }
    }
}
