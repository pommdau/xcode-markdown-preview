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

struct Project: Identifiable {
    let id = UUID().uuidString
    let name: String
    let url: URL
    let status: String
//    var lastBuildAt: Date?
    var timeStamp: Double
    var isValidMarkdownPreview: Bool = false
    
    var dateFormatter: DateFormatter = {
        /// DateFomatterクラスのインスタンス生成
        let dateFormatter = DateFormatter()
         
        /// カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
                
        /// 自動フォーマットのスタイル指定
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    var timeStampString: String {
        let date = Date(timeIntervalSince1970: timeStamp)
        return dateFormatter.string(from: date)
    }
}
