//
//  ContentView.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/26.
//

import SwiftUI
import XCHook
import Combine

struct ContentView: View {
    
    @AppStorage("last-build-project-file-path") private var lastBuildProjectFilePath = ""
    @State var cancellables = Set<AnyCancellable>()
    
    var lastBuildProjectFileURL: URL {
        URL(filePath: lastBuildProjectFilePath)
    }
        
    var fileForMarkdownPreview = Bundle.main.url(forResource: ".xcodesamplecode", withExtension: "plist")!
    
    var body: some View {
        VStack {
            
            Text("Target Project: \(lastBuildProjectFilePath)")
            
            Button("Preview MD") {
                let output = lastBuildProjectFileURL.appendingPathComponent(".xcodesamplecode.plist")
                try? FileManager.default.copyItem(at: fileForMarkdownPreview,
                                                  to: output)
            }
            
            Button("Delete Preview MD") {
                let output = lastBuildProjectFileURL.appendingPathComponent(".xcodesamplecode.plist")
                try? FileManager.default.removeItem(at: output)
            }
            
            Button("Install XCHook") {
                let openPanel = NSOpenPanel()
                openPanel.allowsMultipleSelection = false // 複数ファイルの選択を許すか
                openPanel.canChooseDirectories = false // ディレクトリを選択できるか
                openPanel.canCreateDirectories = false // ディレクトリを作成できるか
                openPanel.canChooseFiles = true // ファイルを選択できるか
//                openPanel.allowedContentTypes = [.]
//                openPanel.runModal()
//                openPanel.beginWithCompletionHandler { (result) -> Void in
//                    if result == NSFileHandlingPanelOKButton {　// ファイルを選択したか(OKを押したか)
//                        guard let url = openPanel.URL else { return }
//                        log.info(url.absoluteString)
//                        // ここでファイルを読み込む
//                    }
//                }
                
                if let xchook = XCHook() {
                    xchook.install()
                } else {
                    print("Failed to initialize XCHook; Xcode.plist does not found.")
                }
            }
            
            Button("Uninstall XCHook") {
                if let xchook = XCHook() {
                    xchook.uninstall()
                } else {
                    print("Failed to initialize XCHook; Xcode.plist does not found.")
                }
            }
        }
        .onAppear() {
            XCHookReceiver.shared.xchookPublisher
                .sink { event in
                    Swift.print("Project: \(event.project)")
                    Swift.print("Project path: \(event.path)")
                    Swift.print("Status: \(event.status.rawValue)")
                    lastBuildProjectFilePath = event.path
                }
                .store(in: &cancellables)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
