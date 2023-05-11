//
//  SwiftDemoViewController.swift
//  GYDate_Example
//
//  Created by 高扬 on 2023/5/11.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import GYDate

class SwiftDemoViewController: UIViewController {
    // MARK: - Private Property
    
    private lazy var systemTimeTagLabel = makeSystemTimeTagLabel()
    private lazy var systemTimeLabel = makeSystemTimeLabel()
    private lazy var serverTimeTagLabel = makeServerTimeTagLabel()
    private lazy var serverTimeLabel = makeServerTimeLabel()
    private lazy var syncButton = makeSyncButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // 定时器 - 每秒钟执行一次
        GYTimer().start { [weak self] in
            guard let self = self else {
                return
            }
            
            self.systemTimeLabel.text = Date().description
            self.serverTimeLabel.text = GYDate.date?.description ?? "nil"
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        // add subviews
        view.addSubview(systemTimeTagLabel)
        view.addSubview(systemTimeLabel)
        view.addSubview(serverTimeTagLabel)
        view.addSubview(serverTimeLabel)
        view.addSubview(syncButton)
        
        // layouts
        systemTimeTagLabel.translatesAutoresizingMaskIntoConstraints = false
        systemTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        serverTimeTagLabel.translatesAutoresizingMaskIntoConstraints = false
        serverTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        syncButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            systemTimeTagLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            systemTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            systemTimeLabel.topAnchor.constraint(equalTo: systemTimeTagLabel.bottomAnchor, constant: 8),
            
            serverTimeTagLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            serverTimeTagLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            serverTimeTagLabel.topAnchor.constraint(equalTo: systemTimeLabel.bottomAnchor, constant: 16),
            
            serverTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            serverTimeLabel.topAnchor.constraint(equalTo: serverTimeTagLabel.bottomAnchor, constant: 8),
            
            syncButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            syncButton.topAnchor.constraint(equalTo: serverTimeLabel.bottomAnchor, constant: 16),
        ])
    }
    
    // MARK: Actions
    
    @objc private func syncButtonAction() {
        syncButton.setTitle("正在同步", for: [])
        
        GYDate.syncServerDate { [weak self] date in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.syncButton.setTitle("重新同步", for: [])
            }
            
        } failure: { [weak self] error in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.syncButton.setTitle("同步失败", for: [])
            }
        }
    }
}

// MARK: - Lazy Initialization

private extension SwiftDemoViewController {
    func makeSystemTimeTagLabel() -> UILabel {
        let systemTimeTagLabel = UILabel()
        systemTimeTagLabel.numberOfLines = 0
        systemTimeTagLabel.textAlignment = .center
        systemTimeTagLabel.text = "系统时间："
        return systemTimeTagLabel
    }
    
    func makeSystemTimeLabel() -> UILabel {
        let systemTimeLabel = UILabel()
        systemTimeLabel.numberOfLines = 0
        systemTimeLabel.textAlignment = .center
        systemTimeLabel.text = Date().description
        return systemTimeLabel
    }
    
    func makeServerTimeTagLabel() -> UILabel {
        let serverTimeTagLabel = UILabel()
        serverTimeTagLabel.numberOfLines = 0
        serverTimeTagLabel.textAlignment = .center
        serverTimeTagLabel.text = "服务器时间"
        return serverTimeTagLabel
    }
    
    func makeServerTimeLabel() -> UILabel {
        let serverTimeLabel = UILabel()
        serverTimeLabel.numberOfLines = 0
        serverTimeLabel.textAlignment = .center
        serverTimeLabel.text = GYDate.date?.description
        return serverTimeLabel
    }
    
    func makeSyncButton() -> UIButton {
        let syncButton = UIButton()
        syncButton.backgroundColor = UIColor.red
        syncButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        switch GYDate.syncState {
        case .unsynced:
            syncButton.setTitle("点击同步", for: .normal)
            
        case .syncing:
            syncButton.setTitle("正在同步", for: .normal)
            
        case .failed:
            syncButton.setTitle("同步失败", for: .normal)
            
        case .synced:
            syncButton.setTitle("重新同步", for: .normal)
        }
        syncButton.addTarget(self, action: #selector(syncButtonAction), for: .touchUpInside)
        return syncButton
    }
}
