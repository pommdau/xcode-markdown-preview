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
                ForEach(Array(manager.builtProjects)
                    .sorted(by: { project1, project2 in
                        project1.timeStamp < project2.timeStamp
                    })) { project in
//                    .sorted(by: { $0.0.localizedName! < $1.0.localizedName! }), id: \.0) { project in
//                    AppRow(app: app, manager: manager)
                        Text(project.url.path)
                }
            }
        }
        .onAppear {
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
