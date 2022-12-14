//
//  AppSubscripe.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import Foundation

struct AppSubscripe: Codable {
    let appId: String
    let regionName: String
    let subscripeType: Int
    let currentVersion: String
    let newVersion: String?
    let startTimeStamp: TimeInterval
    var endCheckTimeStamp: TimeInterval?
    let isFinished: Bool
    
    var startTime: String {
        let date = Date.init(timeIntervalSince1970: startTimeStamp)
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm"
        return dateformat.string(from: date)
    }

    var finishTime: String {
        if let time = endCheckTimeStamp {
            let date = Date.init(timeIntervalSince1970: time)
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateformat.string(from: date)
        } else {
            return "-"
        }
    }
    
    static func updateModel(app: AppSubscripe, checkTime: TimeInterval, isFinished: Bool, _ newVersion: String?) -> AppSubscripe {
        return AppSubscripe(appId: app.appId, regionName: app.regionName, subscripeType: app.subscripeType, currentVersion: app.currentVersion, newVersion: (newVersion != nil) ? newVersion : app.newVersion, startTimeStamp: app.startTimeStamp, endCheckTimeStamp: checkTime, isFinished: isFinished)
    }
    
}

