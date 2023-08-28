//
//  ProjectRow.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import SwiftUI

struct ProjectRow: View {
    
    let project: Project
    @ObservedObject var manager: BuildXcodeProjectManager
    
    var isOnPreviewCheckbox: Binding<Bool> {
        Binding<Bool>(
            get: {
                project.isOnPreview
            },
            set: { newValue in
                guard let index = manager.builtProjects.firstIndex(where: { $0.id == project.id }) else {
                    return
                }
                manager.builtProjects[index].isOnPreview = newValue                
            }
        )
    }
    
    var body: some View {
        HStack {
            Toggle(isOn: isOnPreviewCheckbox) {
                EmptyView() // Empty view as we don't want to show any label
            }
            .toggleStyle(CheckboxToggleStyle())
            .frame(alignment: .leading)
            
            Text(project.name)
            Text("\(project.timeStampString)")
                .foregroundColor(.secondary)
        }
    }
}

//struct ProjectRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectRow()
//    }
//}
