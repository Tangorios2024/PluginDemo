//
//  DeepThinkingButtonViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Anchorage

/// 深度思考按钮展示页面 - 展示业务方A和B的不同UI风格
final class DeepThinkingButtonViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🤔 深度思考按钮展示"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "展示业务方A和B在聊天功能中深度思考按钮的不同UI风格和逻辑处理"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - 业务方A 客户UI风格按钮
    
    private lazy var businessASectionLabel: UILabel = {
        let label = UILabel()
        label.text = "🏢 业务方A - 客户UI风格"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        return label
    }()
    
    private lazy var businessADescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "• UI风格：客户UI - 友好、直观、易用\n• 按钮样式：圆角、渐变色彩、动画效果\n• 逻辑处理：直接调用AI模型，启用网络访问\n• 响应时间：1.1秒，分析深度：客户友好"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var businessADeepThinkingButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("🤔 让我想想...", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        
        // 客户UI风格：圆角、渐变背景
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        
        // 创建渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.42, blue: 0.21, alpha: 1.0).cgColor, // #FF6B35
            UIColor(red: 0.97, green: 0.58, blue: 0.12, alpha: 1.0).cgColor  // #F7931E
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 20
        btn.layer.insertSublayer(gradientLayer, at: 0)
        
        // 添加阴影效果
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowRadius = 8
        
        // 添加弹跳动画
        btn.addTarget(self, action: #selector(businessAButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: - 业务方B 企业UI风格按钮
    
    private lazy var businessBSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "💻 业务方B - 企业UI风格"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemTeal
        label.textAlignment = .center
        return label
    }()
    
    private lazy var businessBDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "• UI风格：企业UI - 专业、正式、商务\n• 按钮样式：直角、单色、简洁设计\n• 逻辑处理：知识库增强，禁用网络访问\n• 响应时间：1.8秒，分析深度：专业级"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var businessBDeepThinkingButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("⚡ 深度分析中...", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        
        // 企业UI风格：直角、单色背景
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0) // #2C3E50
        
        // 添加边框
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 0.3).cgColor
        
        // 添加淡入淡出动画
        btn.addTarget(self, action: #selector(businessBButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: - 演示按钮
    
    private lazy var demoSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "🎯 功能演示"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemOrange
        label.textAlignment = .center
        return label
    }()
    
    private lazy var startDemoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("🚀 开始完整演示", for: .normal)
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.addTarget(self, action: #selector(startDemoTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var uiComparisonButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("🎨 UI差异对比", for: .normal)
        btn.backgroundColor = .systemPurple
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addTarget(self, action: #selector(uiComparisonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var logicComparisonButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("🔧 逻辑差异对比", for: .normal)
        btn.backgroundColor = .systemTeal
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addTarget(self, action: #selector(logicComparisonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - 结果显示
    
    private lazy var resultTextView: UITextView = {
        let textView = UITextView()
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.text = "🤔 深度思考按钮展示\n\n点击上方按钮体验不同业务方的深度思考功能...\n\n"
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            createSeparatorView(),
            businessASectionLabel,
            businessADescriptionLabel,
            businessADeepThinkingButton,
            createSeparatorView(),
            businessBSectionLabel,
            businessBDescriptionLabel,
            businessBDeepThinkingButton,
            createSeparatorView(),
            demoSectionLabel,
            startDemoButton,
            uiComparisonButton,
            logicComparisonButton,
            createSeparatorView(),
            resultTextView
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Properties
    
    private let manager = AICapabilityManager.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDeepThinkingEnvironment()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新渐变层的大小
        if let gradientLayer = businessADeepThinkingButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = businessADeepThinkingButton.bounds
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "深度思考按钮展示"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Layout
        scrollView.edgeAnchors == view.safeAreaLayoutGuide.edgeAnchors
        contentView.edgeAnchors == scrollView.edgeAnchors
        contentView.widthAnchor == scrollView.widthAnchor
        
        stackView.topAnchor == contentView.topAnchor + 20
        stackView.leadingAnchor == contentView.leadingAnchor + 20
        stackView.trailingAnchor == contentView.trailingAnchor - 20
        stackView.bottomAnchor == contentView.bottomAnchor - 20
        
        // 设置按钮高度
        businessADeepThinkingButton.heightAnchor == 60
        businessBDeepThinkingButton.heightAnchor == 50
        startDemoButton.heightAnchor == 50
        uiComparisonButton.heightAnchor == 44
        logicComparisonButton.heightAnchor == 44
        resultTextView.heightAnchor == 200
    }
    
    private func setupDeepThinkingEnvironment() {
        // 注册深度思考按钮专用插件
        manager.register(plugin: BusinessACustomerDeepThinkingPlugin())
        manager.register(plugin: BusinessBEnterpriseDeepThinkingPlugin())
        
        // 注册业务方配置
        let businessAConfig = BusinessConfiguration(
            businessId: "business_a",
            businessName: "业务方A",
            enabledCapabilities: [.chatDialogue, .deepThinking],
            quotaLimits: [
                .chatDialogue: 1000,
                .deepThinking: 300
            ],
            customParameters: [
                "brand_name": "BusinessA",
                "brand_logo": "🏢",
                "ui_theme": "customer",
                "button_style": "customer_ui",
                "deep_thinking_mode": "direct_model",
                "network_access": true,
                "knowledge_base_access": false,
                "customer_features": ["friendly_ui", "quick_response", "simple_analysis"]
            ]
        )
        manager.register(businessConfiguration: businessAConfig)
        
        let businessBConfig = BusinessConfiguration(
            businessId: "business_b",
            businessName: "业务方B",
            enabledCapabilities: [.chatDialogue, .deepThinking],
            quotaLimits: [
                .chatDialogue: 800,
                .deepThinking: 200
            ],
            customParameters: [
                "brand_name": "BusinessB",
                "brand_logo": "💻",
                "ui_theme": "enterprise",
                "button_style": "enterprise_ui",
                "deep_thinking_mode": "knowledge_base_only",
                "network_access": false,
                "knowledge_base_access": true,
                "enterprise_features": ["professional_ui", "secure_analysis", "knowledge_enhanced"]
            ]
        )
        manager.register(businessConfiguration: businessBConfig)
    }
    
    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor == 1
        return view
    }
    
    private func appendResult(_ text: String) {
        DispatchQueue.main.async {
            self.resultTextView.text += text + "\n"
            let bottom = NSMakeRange(self.resultTextView.text.count - 1, 1)
            self.resultTextView.scrollRangeToVisible(bottom)
        }
    }
    
    // MARK: - Actions
    
    @objc private func businessAButtonTapped() {
        appendResult("🏢 业务方A按钮被点击")
        appendResult("🎨 UI风格: 客户UI - 友好、直观、易用")
        appendResult("🔘 按钮样式: 圆角、渐变色彩、动画效果")
        
        // 添加弹跳动画
        UIView.animate(withDuration: 0.1, animations: {
            self.businessADeepThinkingButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.businessADeepThinkingButton.transform = CGAffineTransform.identity
            }
        }
        
        // 模拟深度思考
        performBusinessADeepThinking()
    }
    
    @objc private func businessBButtonTapped() {
        appendResult("💻 业务方B按钮被点击")
        appendResult("💼 UI风格: 企业UI - 专业、正式、商务")
        appendResult("🔘 按钮样式: 直角、单色、简洁设计")
        
        // 添加淡入淡出动画
        UIView.animate(withDuration: 0.3, animations: {
            self.businessBDeepThinkingButton.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.businessBDeepThinkingButton.alpha = 1.0
            }
        }
        
        // 模拟深度思考
        performBusinessBDeepThinking()
    }
    
    @objc private func startDemoTapped() {
        appendResult("🚀 开始完整演示...")
        Task {
            await DeepThinkingButtonDemo.runDeepThinkingButtonScenarios()
            appendResult("✅ 完整演示完成")
        }
    }
    
    @objc private func uiComparisonTapped() {
        appendResult("🎨 UI差异对比:")
        appendResult("   📱 业务方A 客户UI特色:")
        appendResult("      • 按钮样式：圆角设计 (border-radius: 20px)")
        appendResult("      • 色彩方案：渐变背景 (linear-gradient)")
        appendResult("      • 字体风格：友好字体 (font-family: 'Friendly')")
        appendResult("      • 图标设计：可爱图标 (🤔)")
        appendResult("      • 动画效果：弹跳动画 (bounce animation)")
        appendResult("      • 交互反馈：即时响应 (immediate feedback)")
        appendResult("      • 文案风格：亲切友好 ('让我想想...')")
        appendResult("      • 加载状态：进度条动画 (progress bar)")
        appendResult("")
        appendResult("   💼 业务方B 企业UI特色:")
        appendResult("      • 按钮样式：直角设计 (border-radius: 4px)")
        appendResult("      • 色彩方案：单色背景 (#2C3E50)")
        appendResult("      • 字体风格：商务字体 (font-family: 'Professional')")
        appendResult("      • 图标设计：专业图标 (⚡)")
        appendResult("      • 动画效果：淡入淡出 (fade animation)")
        appendResult("      • 交互反馈：延迟响应 (delayed feedback)")
        appendResult("      • 文案风格：专业正式 ('深度分析中...')")
        appendResult("      • 加载状态：旋转图标 (spinner)")
    }
    
    @objc private func logicComparisonTapped() {
        appendResult("🔧 逻辑差异对比:")
        appendResult("   🏢 业务方A 逻辑特色 (客户UI):")
        appendResult("      • 网络访问：启用 (network_access: true)")
        appendResult("      • 知识库访问：禁用 (knowledge_base_access: false)")
        appendResult("      • 分析模式：直接调用模型 (deep_thinking_mode: 'direct_model')")
        appendResult("      • 响应速度：快速响应 (quick_response)")
        appendResult("      • 分析深度：简洁分析 (simple_analysis)")
        appendResult("      • 数据来源：实时网络 + AI模型")
        appendResult("      • 安全级别：标准安全 (standard_security)")
        appendResult("      • 用户权限：基础权限 (basic_permissions)")
        appendResult("")
        appendResult("   💻 业务方B 逻辑特色 (企业UI):")
        appendResult("      • 网络访问：禁用 (network_access: false)")
        appendResult("      • 知识库访问：启用 (knowledge_base_access: true)")
        appendResult("      • 分析模式：知识库增强 (deep_thinking_mode: 'knowledge_base_only')")
        appendResult("      • 响应速度：深度分析 (deep_analysis)")
        appendResult("      • 分析深度：专业分析 (professional_analysis)")
        appendResult("      • 数据来源：内部知识库 + AI模型")
        appendResult("      • 安全级别：企业级安全 (enterprise_security)")
        appendResult("      • 用户权限：高级权限 (advanced_permissions)")
    }
    
    // MARK: - 深度思考功能
    
    private func performBusinessADeepThinking() {
        appendResult("🧠 开始业务方A深度思考...")
        
        Task {
            do {
                let request = AICapabilityRequest(
                    capabilityType: .deepThinking,
                    input: .text("我想了解如何提高工作效率")
                )
                
                let response = try await manager.execute(request: request, for: "business_a")
                
                if case .text(let result) = response.output {
                    appendResult("✅ 业务方A深度思考完成")
                    appendResult("📝 分析结果: \(result.prefix(200))...")
                    
                    // 显示客户UI特定的元数据
                    if let uiTheme = response.metadata["ui_theme"] as? String {
                        appendResult("🎨 UI主题: \(uiTheme)")
                    }
                    if let buttonStyle = response.metadata["button_style"] as? String {
                        appendResult("🔘 按钮样式: \(buttonStyle)")
                    }
                    if let thinkingMode = response.metadata["thinking_mode"] as? String {
                        appendResult("🧠 思考模式: \(thinkingMode)")
                    }
                    if let networkAccess = response.metadata["network_access"] as? Bool, networkAccess {
                        appendResult("🌐 网络访问: 已启用")
                    }
                    if let responseTime = response.metadata["response_time"] as? String {
                        appendResult("⏱️ 响应时间: \(responseTime)")
                    }
                }
                
            } catch {
                appendResult("❌ 业务方A深度思考失败: \(error.localizedDescription)")
            }
        }
    }
    
    private func performBusinessBDeepThinking() {
        appendResult("🧠 开始业务方B深度思考...")
        
        Task {
            do {
                let request = AICapabilityRequest(
                    capabilityType: .deepThinking,
                    input: .text("如何设计一个高可用的微服务架构")
                )
                
                let response = try await manager.execute(request: request, for: "business_b")
                
                if case .text(let result) = response.output {
                    appendResult("✅ 业务方B深度思考完成")
                    appendResult("📝 分析结果: \(result.prefix(200))...")
                    
                    // 显示企业UI特定的元数据
                    if let uiTheme = response.metadata["ui_theme"] as? String {
                        appendResult("🎨 UI主题: \(uiTheme)")
                    }
                    if let buttonStyle = response.metadata["button_style"] as? String {
                        appendResult("🔘 按钮样式: \(buttonStyle)")
                    }
                    if let thinkingMode = response.metadata["thinking_mode"] as? String {
                        appendResult("🧠 思考模式: \(thinkingMode)")
                    }
                    if let networkAccess = response.metadata["network_access"] as? Bool, !networkAccess {
                        appendResult("🚫 网络访问: 已禁用")
                    }
                    if let knowledgeBaseAccess = response.metadata["knowledge_base_access"] as? Bool, knowledgeBaseAccess {
                        appendResult("📚 知识库访问: 已启用")
                    }
                    if let responseTime = response.metadata["response_time"] as? String {
                        appendResult("⏱️ 响应时间: \(responseTime)")
                    }
                }
                
            } catch {
                appendResult("❌ 业务方B深度思考失败: \(error.localizedDescription)")
            }
        }
    }
} 