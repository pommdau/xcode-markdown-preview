//
//  ProjectRow.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import SwiftUI

struct ProjectRow: View {
    
    @Binding var project: Project
    @ObservedObject var manager: ProjectManager
   
    var body: some View {
        HStack {
            previewToggle()
                        
            Text("\(lastBuiltText)")
                .frame(minWidth: 140, maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
            /*
            Text(project.url.path)
                .frame(minWidth: 300, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .truncationMode(.head)
                .help(project.url.path)
             */
            pinButton()
                .padding(.trailing, 4)
            showInFinderButton()
                .padding(.trailing, 4)
            removeButton()
        }
    }
    
    var lastBuiltText: String {
        let timeintervalSeconds = Int(manager.referencedDate - Date(timeIntervalSince1970: project.timeStamp))
        if timeintervalSeconds < 60 {
            return "> 1 min before"
        }
        
        let timeintervalMinutes = Int(timeintervalSeconds / 60)
        if timeintervalMinutes < 60 {
            return "\(timeintervalMinutes) mins before"
        }
        
        let timeintervalHours = Int(timeintervalSeconds / 3600)
        if timeintervalHours < 24 {
            return "\(timeintervalHours) hours before"
        }
        
        // 1日以上前は日付を返す
        return project.timeStampString
    }
    
    @ViewBuilder
    private func previewToggle() -> some View {
        Toggle(isOn: $project.isOnPreview) {
            Text(project.name)
                .frame(minWidth: 200, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .truncationMode(.tail)
                .help(project.name)
        }
        .toggleStyle(.checkbox)
        .frame(alignment: .leading)
    }
    
    @ViewBuilder
    private func pinButton() -> some View {
        Button {
            manager.pinButtonTapped(project: project)
        } label: {
            Image(systemName: project.isPinned ? "pin.fill" : "pin")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .help("Pin this project")
        }
        .buttonStyle(.borderless)
    }
    
    @ViewBuilder
    private func showInFinderButton() -> some View {
        Button {
            manager.showInFinderButtonTapped(project: project)
        } label: {
            Image(systemName: "folder")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .help("Show in Finder")
        }
        .buttonStyle(.borderless)
    }
    
    @ViewBuilder
    private func removeButton() -> some View {
        Button {
            manager.removeButtonTapped(project: project)
        } label: {
            Image(systemName: "trash")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .help("Remove from the list")
        }
        .buttonStyle(.borderless)
    }
}

struct ProjectRow_Previews: PreviewProvider {
    
    @State static var manager = ProjectManager()
    
    static var previews: some View {
        ProjectRow(project: $manager.builtProjects[0], manager: manager)
    }
}
