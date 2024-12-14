//
//  ContentView.swift
//  ClipboardMonitor
//
//  Created by Emiel Deboyser on 14/12/2024.
//

import SwiftUI

struct CopieboardView: View {
    @EnvironmentObject var clipboardManager: ClipboardManager

    var body: some View {
        VStack {
            Text("Clipboard History")
                .font(.headline)
                .padding()

            List(clipboardManager.clipboardItems, id: \.self) { item in
                Text(item)
            }

            Button("Clear History") {
                clipboardManager.clipboardItems.removeAll()
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    CopieboardView()
        .environmentObject(ClipboardManager()) // For preview
}

