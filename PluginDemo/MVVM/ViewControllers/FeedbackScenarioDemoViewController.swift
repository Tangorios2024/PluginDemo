//
//  FeedbackScenarioDemoViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Anchorage

/// 反馈收集场景演示 ViewController
final class FeedbackScenarioDemoViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "反馈收集场景演示"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "演示业务方A和B使用相同功能组件但在UI和逻辑处理上的细微差别"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var startDemoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("开始演示", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return btn
    }()
    
    private lazy var businessAButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("业务方A - 企业级反馈", for: .normal)
        btn.backgroundColor = .systemIndigo
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    
    private lazy var businessBButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("业务方B - 技术团队反馈", for: .normal)
        btn.backgroundColor = .systemTeal
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    
    private lazy var uiDifferenceButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("UI差异对比", for: .normal)
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    
    private lazy var logicDifferenceButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("逻辑差异对比", for: .normal)
        btn.backgroundColor = .systemPurple
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            startDemoButton,
            businessAButton,
            businessBButton,
            uiDifferenceButton,
            logicDifferenceButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "反馈收集场景"
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        // 设置约束
        stackView.centerXAnchor == view.centerXAnchor
        stackView.centerYAnchor == view.centerYAnchor
        stackView.widthAnchor == 300
        
        // 设置按钮高度
        startDemoButton.heightAnchor == 50
        businessAButton.heightAnchor == 44
        businessBButton.heightAnchor == 44
        uiDifferenceButton.heightAnchor == 44
        logicDifferenceButton.heightAnchor == 44
    }
    
    private func setupActions() {
        startDemoButton.addTarget(self, action: #selector(startDemoAction), for: .touchUpInside)
        businessAButton.addTarget(self, action: #selector(businessAAction), for: .touchUpInside)
        businessBButton.addTarget(self, action: #selector(businessBAction), for: .touchUpInside)
        uiDifferenceButton.addTarget(self, action: #selector(uiDifferenceAction), for: .touchUpInside)
        logicDifferenceButton.addTarget(self, action: #selector(logicDifferenceAction), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func startDemoAction() {
        print("🚀 开始反馈收集场景演示")
        
        // 在后台线程运行演示
        Task {
            await FeedbackScenarioDemo.runFeedbackScenarios()
        }
        
        // 显示提示
        showAlert(title: "演示开始", message: "反馈收集场景演示已在控制台开始运行，请查看Xcode控制台输出。")
    }
    
    @objc private func businessAAction() {
        print("🏢 演示业务方A - 企业级反馈收集")
        
        Task {
            let demo = FeedbackScenarioDemo()
            await demo.setupFeedbackEnvironment()
            await demo.demonstrateBusinessA()
        }
        
        showAlert(title: "业务方A演示", message: "企业级反馈收集演示已在控制台开始运行。")
    }
    
    @objc private func businessBAction() {
        print("💻 演示业务方B - 技术团队反馈收集")
        
        Task {
            let demo = FeedbackScenarioDemo()
            await demo.setupFeedbackEnvironment()
            await demo.demonstrateBusinessB()
        }
        
        showAlert(title: "业务方B演示", message: "技术团队反馈收集演示已在控制台开始运行。")
    }
    
    @objc private func uiDifferenceAction() {
        print("🎨 演示UI差异对比")
        
        Task {
            let demo = FeedbackScenarioDemo()
            await demo.demonstrateUIDifferences()
        }
        
        showAlert(title: "UI差异对比", message: "UI差异对比演示已在控制台开始运行。")
    }
    
    @objc private func logicDifferenceAction() {
        print("🔧 演示逻辑差异对比")
        
        Task {
            let demo = FeedbackScenarioDemo()
            await demo.demonstrateLogicDifferences()
        }
        
        showAlert(title: "逻辑差异对比", message: "逻辑差异对比演示已在控制台开始运行。")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
} 