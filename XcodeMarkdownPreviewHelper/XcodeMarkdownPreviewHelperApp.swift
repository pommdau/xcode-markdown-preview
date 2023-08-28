//
//  XcodeMarkdownPreviewHelperApp.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/26.
//

import SwiftUI

@main
struct XcodeMarkdownPreviewHelperApp: App {
    
    let manager = ProjectManager()
    
    var body: some Scene {
        WindowGroup {
            Home(manager: manager)
        }
        
        MenuBarExtra {
//            Home(manager: manager)
        } label: {
            HStack {
                Image(systemName: "doc.richtext.fill")
                Text(".md")
            }
        }
        .menuBarExtraStyle(.window)
    }
}
