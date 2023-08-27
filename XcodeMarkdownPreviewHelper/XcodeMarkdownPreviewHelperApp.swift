//
//  XcodeMarkdownPreviewHelperApp.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/26.
//

import SwiftUI

@main
struct XcodeMarkdownPreviewHelperApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            Home()
        }        
        MenuBarExtra {
            Text("Test")
        } label: {
            HStack {
                Image(systemName: "doc.richtext.fill")
                Text("MD")
            }
        }
    }
}
