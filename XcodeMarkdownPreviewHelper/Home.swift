//
//  Home.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/26.
//

import SwiftUI
import XCHook

struct Home: View {
    
    // MARK: - Properties
    
    @ObservedObject private var manager: BuildXcodeProjectManager
    
    // MARK: - View
    
    var body: some View {
        VStack {
            VStack {
                ForEach(manager.builtProjects) { project in
                    ProjectRow(project: project,
                               manager: manager)
                }
            }
        }
        .onAppear() {
            for window in NSApplication.shared.windows {
                window.level = .floating
            }
        }
    }
    
    // MARK: - LifeCycle
    
    init(buildXcodeProjectManager: BuildXcodeProjectManager) {
        self.manager = buildXcodeProjectManager
    }
    
    // MARK: - Helpers
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(buildXcodeProjectManager: BuildXcodeProjectManager())
    }
}
