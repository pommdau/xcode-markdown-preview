//
//  Project.swift
//  XcodeMarkdownPreviewHelper
//
//  Created by HIROKI IKEUCHI on 2023/08/28.
//

import Foundation

struct Project: Codable {            
    var name: String
    let url: URL
    var status: String
    var timeStamp: Double
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
        dateFormatter.timeStyle = .medium
        
        return dateFormatter
    }()
    
    var timeStampString: String {
        let date = Date(timeIntervalSince1970: timeStamp)
        return Self.dateFormatter.string(from: date)
    }
    
    var fileForMarkdownPreview: URL {
        url.appendingPathComponent(".xcodesamplecode.plist")
    }
    
    init(name: String, url: URL, status: String, timeStamp: Double, isOnPreview: Bool = false) {
        self.name = name
        self.url = url
        self.status = status
        self.timeStamp = timeStamp
        self.isOnPreview = isOnPreview
    }
}

extension Project: Identifiable {
    var id: String { url.path }
}