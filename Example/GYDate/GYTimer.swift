//
//  GYTimer.swift
//  GYDate_Example
//
//  Created by 高扬 on 2023/5/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

class GYTimer: NSObject {
    private var timer: Timer?
    private let queue = DispatchQueue(label: "com.gaoyang.timer.queue", qos: .userInteractive)
    
    @objc func start(_ callback: @escaping () -> Void) {
        // 计算下一个整秒的时间点
        let now = Date()
        let nextSecond = Date(timeIntervalSince1970: Double(Int(now.timeIntervalSince1970) + 1))
        
        // 创建定时器并添加到 RunLoop 中
        timer = Timer(fireAt: nextSecond, interval: 1, target: self, selector: #selector(timerTick(_:)), userInfo: callback, repeats: true)
        RunLoop.current.add(timer!, forMode: .default)
        
        // 在单独线程中运行 RunLoop
        queue.async {
            let runLoop = RunLoop.current
            runLoop.run()
        }
    }
    
    @objc func stop() {
        // 停止定时器并停止 RunLoop
        timer?.invalidate()
        queue.sync {}
    }
    
    @objc private func timerTick(_ timer: Timer) {
        // 在主线程中回调定时器方法
        if let callback = timer.userInfo as? () -> Void {
            DispatchQueue.main.async {
                callback()
            }
        }
    }
}
