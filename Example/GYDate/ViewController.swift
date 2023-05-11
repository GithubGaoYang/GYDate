//
//  ViewController.swift
//  GYDate
//
//  Created by 高扬 on 05/09/2023.
//  Copyright (c) 2023 CocoaPods. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Private Property
    
    private lazy var swiftDemoButton = makeSwiftDemoButton()
    private lazy var ocDemoButton = makeOCDemoButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // add subviews
        view.addSubview(swiftDemoButton)
        view.addSubview(ocDemoButton)
        
        // layouts
        swiftDemoButton.translatesAutoresizingMaskIntoConstraints = false
        ocDemoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swiftDemoButton.widthAnchor.constraint(equalToConstant: 120),
            swiftDemoButton.heightAnchor.constraint(equalToConstant: 120),
            swiftDemoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftDemoButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            ocDemoButton.widthAnchor.constraint(equalToConstant: 120),
            ocDemoButton.heightAnchor.constraint(equalToConstant: 120),
            ocDemoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ocDemoButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
        ])
    }
    
    // MARK: Actions
    
    @objc private func swiftDemoButtonAction() {
        let swiftDemoController = SwiftDemoViewController()
        navigationController?.pushViewController(swiftDemoController, animated: true)
    }
    
    @objc private func ocDemoButtonAction() {
        let ocDemoController = OCDemoViewController()
        navigationController?.pushViewController(ocDemoController, animated: true)
    }
}

// MARK: - Lazy Initialization

private extension ViewController {
    func makeSwiftDemoButton() -> UIButton {
        let swiftDemoButton = UIButton()
        swiftDemoButton.backgroundColor = UIColor.red
        swiftDemoButton.setTitle("Swift Demo", for: .normal)
        swiftDemoButton.addTarget(self, action: #selector(swiftDemoButtonAction), for: .touchUpInside)
        return swiftDemoButton
    }
    
    func makeOCDemoButton() -> UIButton {
        let ocDemoButton = UIButton()
        ocDemoButton.backgroundColor = UIColor.red
        ocDemoButton.setTitle("OC Demo", for: .normal)
        ocDemoButton.addTarget(self, action: #selector(ocDemoButtonAction), for: .touchUpInside)
        return ocDemoButton
    }
}
