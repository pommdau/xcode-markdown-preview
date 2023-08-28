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
    
    @ObservedObject private var manager: ProjectManager
    
    // MARK: - View
    
    var body: some View {
        VStack {
            if manager.builtProjects.isEmpty {
                Text("(Waiting for build...)")
            } else {
                VStack {
                    ForEach($manager.builtProjects) { $project in
                        ProjectRow(project: $project, manager: manager)
                    }
                }
            }
            Divider()
            HStack {
                installXCHookButton()
                uninstallXCHookButton()
                Spacer()
                quitButton()
            }
        }
        .padding()
    }
    
    // MARK: - LifeCycle
    
    init(manager: ProjectManager) {
        self.manager = manager
    }
    
    // MARK: - Helpers
    
    @ViewBuilder
    private func installXCHookButton() -> some View {
        Button {
            if let xchook = XCHook() {
                xchook.install()
            } else {
                print("Failed to initialize XCHook; Xcode.plist does not found.")
            }
            showAlertIfXcodeIsRunning()
        } label: {
            Text("Install XCHook")
        }
    }
    
    @ViewBuilder
    private func uninstallXCHookButton() -> some View {
        Button {
            if let xchook = XCHook() {
                xchook.uninstall()
            } else {
                print("Failed to initialize XCHook; Xcode.plist does not found.")
            }
            showAlertIfXcodeIsRunning()
        } label: {
            Text("Uninstall XCHook")
        }
    }
    
    @ViewBuilder
    private func quitButton() -> some View {
        Button("Quit") {
            NSApplication.shared.terminate(self)
        }
        .buttonStyle(.automatic)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func showAlertIfXcodeIsRunning() {
        if NSWorkspace.shared.runningApplications
            .compactMap({ $0.localizedName })
            .contains("Xcode") {
            NSAlert.showMessage(messageText: "Xcodeを再起動してください")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(manager: ProjectManager())
    }
}
