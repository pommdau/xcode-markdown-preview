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
            ForEach($manager.builtProjects) { $project in
                ProjectRow(project: $project)
            }
            Divider()
            quitButton()
        }
        .padding()
    }
    
    // MARK: - LifeCycle
    
    init(buildXcodeProjectManager: BuildXcodeProjectManager) {
        self.manager = buildXcodeProjectManager
    }
    
    // MARK: - Helpers
    
    @ViewBuilder
    private func quitButton() -> some View {
        Button("Quit") {
            NSApplication.shared.terminate(self)
        }
        .buttonStyle(.automatic)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(buildXcodeProjectManager: BuildXcodeProjectManager())
    }
}
