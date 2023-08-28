//
//  XcodeMarkdownPreviewHelperApp.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/26.
//

import SwiftUI

@main
struct XcodeMarkdownPreviewHelperApp: App {
    
    let buildXcodeProjectManager = BuildXcodeProjectManager()
    
    var body: some Scene {
        WindowGroup {
//            XCHookDemoView()
//            ContentView()
            Home(buildXcodeProjectManager: buildXcodeProjectManager)
        }
        MenuBarExtra {
//            Home(buildXcodeProjectManager: buildXcodeProjectManager)
        } label: {
            HStack {
                Image(systemName: "doc.richtext.fill")
                Text("MD")
            }
        }
    }
}
