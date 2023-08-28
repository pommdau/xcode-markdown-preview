//
//  ProjectRow.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import SwiftUI

struct ProjectRow: View {
    
    @Binding var project: Project
   
    var body: some View {
        HStack {
            Toggle(isOn: $project.isOnPreview) {
                EmptyView() // Empty view as we don't want to show any label
            }
            .toggleStyle(CheckboxToggleStyle())
            .frame(alignment: .leading)
            
            Text(project.name)
                .frame(minWidth: 200, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .truncationMode(.tail)
                .help(project.name)
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
            Button {
                // manager.closeapp
            } label: {
                Image(systemName: "pin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.borderless)
            .padding(.trailing, 4)
            
            Button {
                // manager.closeapp
            } label: {
                Image(systemName: "folder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.borderless)
            .padding(.trailing, 4)
            
            Button {
                // manager.closeapp
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.borderless)
        }
    }
}

struct ProjectRow_Previews: PreviewProvider {
    
    @State static var manager = BuildXcodeProjectManager()
    
    static var previews: some View {
        ProjectRow(project: $manager.builtProjects[0])
    }
}
