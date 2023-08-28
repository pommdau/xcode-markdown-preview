//
//  Project.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import Foundation

struct Project: Identifiable {
    let id = UUID().uuidString
    
    let name: String
    let url: URL
    let status: String
    let timeStamp: Double
    var isOnPreview: Bool = false
    
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
