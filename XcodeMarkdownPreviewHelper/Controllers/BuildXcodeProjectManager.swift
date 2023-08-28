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
            syncFileForPreview()
            saveProjectsStatus()
        }
    }
    
    private var fileForMarkdownPreview = Bundle.main.url(forResource: ".xcodesamplecode", withExtension: "plist")!
    
    init() {
//        builtProjectsData = Data()  // デバッグ
        loadProjectsStatus()
        
        guard let xchook = XCHook() else {
            fatalError("Failed to initialize XCHook; Xcode.plist does not found.")
        }
        // TODO: tryが欲しい
        xchook.install()
        XCHookReceiver.shared.xchookPublisher
            .sink { event in
                
                if event.status != .buildSucceeds {
                    return
                }
                
                Swift.print("Project: \(event.project)")
                Swift.print("Project path: \(event.path)")
                Swift.print("Status: \(event.status.rawValue)")
                
                self.registerBuildProject(
                    Project(name: event.project,
                            url: URL(filePath: event.path),
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
    
    private func syncFileForPreview() {
        builtProjects.forEach { project in
            let existsFile = FileManager.default.fileExists(atPath: project.fileForMarkdownPreview.path)
            
            if project.isOnPreview && !existsFile {
                // Preview ON かつ ファイルが存在しない
                try! FileManager.default.copyItem(at: fileForMarkdownPreview,
                                                  to: project.fileForMarkdownPreview)

            } else if !project.isOnPreview && existsFile {
                // Preview OFF かつ ファイルが存在する
                do {
                    try FileManager.default.removeItem(at: project.fileForMarkdownPreview)
                } catch {
                    print(project.fileForMarkdownPreview.path)
                    fatalError(error.localizedDescription)
                }
            }
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
        
        defer {
            builtProjects.sort { first, second in
                first.timeStamp < second.timeStamp
            }
        }
        
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