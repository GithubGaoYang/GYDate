//
//  GYDate.swift
//  GYDate
//
//  Created by 高扬 on 2023/5/9.
//

import UIKit

public class GYDate: NSObject {
    /// 日期同步状态
    @objc public enum DateSyncState: Int {
        /// 尚未同步
        case unsynced
        /// 同步中
        case syncing
        /// 同步失败
        case failed
        /// 已同步
        case synced
    }
    
    // MARK: - Public Property
    
    /// 同步状态
    @objc public dynamic static var syncState: DateSyncState = .unsynced
    
    /// 当前服务器时间
    @objc public static var date: Date? {
        guard let serverLastRebootTimeInterval = serverLastRebootTimeInterval else {
            return nil
        }
        
        // 当前服务器时间
        let timeInterval = TimeInterval(serverLastRebootTimeInterval &+ uptime) / 1000000
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    // MARK: - Public Methods
    
    /// 同步服务器时间
    @objc public class func syncServerDate(serverDate: Date) {
        // 当前服务器时间
        let serverTimeInterval = serverDate.timeIntervalSince1970 * 1000000
        
        // 设备上次启动时的服务端时间
        serverLastRebootTimeInterval = Int(serverTimeInterval) - uptime
        
        print("""
            🎉 sync server date succeeded:
                serverDate: \(serverDate), uptime: \(uptime)
                serverLastRebootTimeInterval: \(serverLastRebootTimeInterval ?? 0)
            """)
    }
    
    /// 同步服务器时间
    /// - Parameters:
    ///   - host: 服务器地址
    ///   - dateFormat: 日期格式
    ///   - success: 成功回调
    ///   - failure: 失败回调
    @objc public class func syncServerDate(
        with host: URL = URL(string: "https://www.baidu.com/")!,
        dateFormat: String = "EEE, dd MMM yyyy HH:mm:ss z",
        success: ((_ serverDate: Date?) -> Void)?,
        failure: ((_ error: Error?) -> Void)?
    ) {
        syncState = .syncing
        
        print("🕒 begin syncing server date")
        
        var request = URLRequest(url: host)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                let serverDateString = response.allHeaderFields["Date"] as? String
            else {
                syncState = .failed
                
                print("""
                    🕒 sync server date failed:
                        error: \(error.debugDescription),
                        response: \(String(describing: response))
                    """)
                failure?(error)
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = dateFormat
            
            guard
                let serverDate = dateFormatter.date(from: serverDateString)
            else {
                syncState = .failed
                print("""
                    🕒 sync server date failed:
                        error: get serverDate failed,
                        response: \(response)
                    """)
                
                failure?(error)
                return
            }
            
            syncState = .synced
            
            syncServerDate(serverDate: serverDate)
            success?(serverDate)
        }.resume()
    }
}

// MARK: - Private Methods

public extension GYDate {
    // MARK: Utils
    
    /// 设备上次启动时的服务端时间
    static var serverLastRebootTimeInterval: Int? {
        get {
            return UserDefaults.standard.object(forKey: "com.gaoyang.date.serverLastRebootTimeInterval") as? Int
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "com.gaoyang.date.serverLastRebootTimeInterval")
        }
    }
    
    /// 设备运行时长 - 指从上次启动至今的时间差（microseconds）
    static var uptime: Int {
        /// 获取当前 Unix Time
        var now = timeval()
        var tz = timezone()
        gettimeofday(&now, &tz)
        
        /// 获取设备上次重启的 Unix Time
        var mid = [CTL_KERN, KERN_BOOTTIME]
        var timeval = timeval()
        var size = MemoryLayout.size(ofValue: timeval)
        
        if sysctl(&mid, 2, &timeval, &size, nil, 0) == -1 {
            return now.tv_sec * 1000000 + Int(now.tv_usec)
        }
        
        // 计算差值（运行时间）
        var uptime = (now.tv_sec - timeval.tv_sec) * 1000000
        uptime = uptime + Int(now.tv_usec - timeval.tv_usec)
        return uptime
    }
}
