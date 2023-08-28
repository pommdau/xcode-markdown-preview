//
//  BuildXcodeProjectManager.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import Foundation
import AppKit
import SwiftUI
import os.log
import Combine

import XCHook


class BuildXcodeProjectManager: ObservableObject {
    @Published var builtProjects: [Project] = []
    @Published var appsToClose: [String] = []
    private var timer: Timer?

    @Published var toggleStatus: [String: Bool] = [:] {
        willSet {
            objectWillChange.send()
        }
    }
    @AppStorage("com.MagicQuit.toggleStatus") var toggleStatusData: Data = Data()

    @Published var cancellables = Set<AnyCancellable>()
    
    init() {
        guard let xchook = XCHook() else {
            fatalError("Failed to initialize XCHook; Xcode.plist does not found.")
        }
        // TODO: tryが欲しい
        xchook.install()
        
        XCHookReceiver.shared.xchookPublisher
            .sink { event in
                Swift.print("Project: \(event.project)")
                Swift.print("Project path: \(event.path)")
                Swift.print("Status: \(event.status.rawValue)")
                //                lastBuildProjectFilePath = event.path
                self.addCurrentBuildProject(Project(name: event.project,
                                                    url: URL(string: event.path)!,
                                                    status: event.status.rawValue,
                                                    timeStamp: event.timestamp))
            }
            .store(in: &cancellables)
    }
    
    // Synchronize toggleStatus with toggleStatusData
    private func syncToggleStatus() {
        if let status = try? JSONDecoder().decode([String: Bool].self, from: toggleStatusData) {
            toggleStatus = status
        }
    }
    
    // Save toggleStatus to toggleStatusData
    func saveToggleStatus() {
        if let data = try? JSONEncoder().encode(toggleStatus) {
            toggleStatusData = data
        }
    }
    
    private func addCurrentBuildProject(_ project: Project) {
        if let index = builtProjects.firstIndex(where: { $0.url == project.url }) {
            // 情報を更新
            DispatchQueue.main.async {
                self.builtProjects[index] = project
            }
            return
        }
        
        DispatchQueue.main.async {
            self.builtProjects.append(project)
        }
    }
}
