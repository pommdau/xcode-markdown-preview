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
            Home(manager: manager)
//            Text("hoge")
        } label: {
            Image(systemName: "doc.richtext.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
