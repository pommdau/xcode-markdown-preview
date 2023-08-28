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
    var isPinned: Bool
    var currentDate: Date
    
    /// refs: [【Swift】DateFormatterの使い方](https://capibara1969.com/2153/#toc15)
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = .current
//        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
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
    
    init(name: String,
         url: URL,
         status: String,
         timeStamp: Double,
         isOnPreview: Bool = false,
         isPinned: Bool = false,
         currentDate: Date = Date()
    ) {
        self.name = name
        self.url = url
        self.status = status
        self.timeStamp = timeStamp
        self.isOnPreview = isOnPreview
        self.isPinned = isPinned
        self.currentDate = currentDate
    }
}

extension Project: Identifiable {
    var id: String { url.path }
}

/// refs: [Calculating the difference between two dates in Swift](https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift)
extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
