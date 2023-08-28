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
        
    @AppStorage("com.BuildXcodeProjectManager.builtProjectsData")
    private var builtProjectsData: Data = Data()
    
    @Published private var cancellables = Set<AnyCancellable>()
    
    @Published var builtProjects: [Project] = [] {
        didSet {
            print("DidSet 🐱")
            saveProjectsStatus()
        }
    }
    
    init() {
        loadProjectsStatus()
        
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
                
                self.registerBuildProject(
                    Project(name: event.project,
                            url: URL(string: event.path)!,
                            status: event.status.rawValue,
                            timeStamp: event.timestamp)
                )
                self.saveProjectsStatus()
            }
            .store(in: &cancellables)
    }
    
    // Synchronize toggleStatus with toggleStatusData
    private func loadProjectsStatus() {
        if let builtProjects = try? JSONDecoder().decode([Project].self, from: builtProjectsData) {
            self.builtProjects = builtProjects
        }
    }
    
    // Save toggleStatus to toggleStatusData
    func saveProjectsStatus() {
        if let builtProjectsData = try? JSONEncoder().encode(builtProjects) {
            self.builtProjectsData = builtProjectsData
        }
    }
    
    // プロジェクトをアプリに登録
    private func registerBuildProject(_ project: Project) {
        if let index = builtProjects.firstIndex(where: { $0.url == project.url }) {
            // 情報を更新
            DispatchQueue.main.async {
                self.builtProjects[index].name = project.name
                self.builtProjects[index].status = project.status
                self.builtProjects[index].timeStamp = project.timeStamp
            }
            return
        }
        
        DispatchQueue.main.async {
            self.builtProjects.append(project)
        }
    }
}
