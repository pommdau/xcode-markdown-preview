//
//  ProjectRow.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import SwiftUI

struct ProjectRow: View {
    
    @Binding var project: Project
    @ObservedObject var manager: BuildXcodeProjectManager
   
    var body: some View {
        HStack {
            previewToggle()
                        
            Text("\(project.timeStampString)")
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
    
    @ViewBuilder
    private func previewToggle() -> some View {
        Toggle(isOn: $project.isOnPreview) {
            Text(project.name)
                .frame(minWidth: 200, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .truncationMode(.tail)
                .help(project.name)
        }
        .toggleStyle(CheckboxToggleStyle())
        .frame(alignment: .leading)
    }
    
    @ViewBuilder
    private func pinButton() -> some View {
        Button {
            // manager.closeapp
        } label: {
            Image(systemName: "pin")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
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
        }
        .buttonStyle(.borderless)
    }
}

struct ProjectRow_Previews: PreviewProvider {
    
    @State static var manager = BuildXcodeProjectManager()
    
    static var previews: some View {
        ProjectRow(project: $manager.builtProjects[0], manager: manager)
    }
}
