//
//  Project.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import Foundation

struct Project: Codable {            
    let uuid: UUID
    let name: String
    let url: URL
    let status: String
    let timeStamp: Double
    var isOnPreview: Bool
    
    /// refs: [【Swift】DateFormatterの使い方](https://capibara1969.com/2153/#toc15)
    private static let dateFormatter: DateFormatter = {
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
        return Self.dateFormatter.string(from: date)
    }
    
    init(uuid: UUID = UUID(), name: String, url: URL, status: String, timeStamp: Double, isOnPreview: Bool = false) {
        self.uuid = uuid
        self.name = name
        self.url = url
        self.status = status
        self.timeStamp = timeStamp
        self.isOnPreview = isOnPreview
    }
}

extension Project: Identifiable {
    var id: String { uuid.uuidString }
}
