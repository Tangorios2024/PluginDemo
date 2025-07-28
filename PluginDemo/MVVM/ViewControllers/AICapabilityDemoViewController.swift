//
//  AICapabilityDemoViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Anchorage

/// AI 能力组合演示页面
final class AICapabilityDemoViewController: UIViewController {
    
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
        label.text = "AI 能力组合平台演示"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "展示插件式架构在AI能力组合中的应用，支持多种业务场景的灵活配置"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mathDemoButton: UIButton = {
        let btn = createDemoButton(
            title: "🧮 数学能力演示",
            subtitle: "智能出题 + 解题分析",
            backgroundColor: .systemBlue
        )
        return btn
    }()
    
    private lazy var contentDemoButton: UIButton = {
        let btn = createDemoButton(
            title: "📄 内容处理演示",
            subtitle: "OCR识别 + 文本摘要 + 翻译",
            backgroundColor: .systemGreen
        )
        return btn
    }()
    
    private lazy var imageDemoButton: UIButton = {
        let btn = createDemoButton(
            title: "🎨 图像处理演示",
            subtitle: "图片生成 + 水印添加",
            backgroundColor: .systemOrange
        )
        return btn
    }()
    
    private lazy var networkDemoButton: UIButton = {
        let btn = createDemoButton(
            title: "🌐 网络服务演示",
            subtitle: "智能搜索 + 音视频通话",
            backgroundColor: .systemPurple
        )
        return btn
    }()
    
    private lazy var combinationDemoButton: UIButton = {
        let btn = createDemoButton(
            title: "🔗 能力组合演示",
            subtitle: "多能力协同工作流程",
            backgroundColor: .systemTeal
        )
        return btn
    }()
    
    private lazy var fullDemoButton: UIButton = {
        let btn = createDemoButton(
            title: "🚀 完整平台演示",
            subtitle: "运行所有业务场景",
            backgroundColor: .systemIndigo
        )
        return btn
    }()
    
    private lazy var resultTextView: UITextView = {
        let textView = UITextView()
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.text = "点击上方按钮查看AI能力演示结果...\n"
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            mathDemoButton,
            contentDemoButton,
            imageDemoButton,
            networkDemoButton,
            combinationDemoButton,
            fullDemoButton,
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
        setupActions()
        setupAICapabilities()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "AI 能力演示"
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
        
        resultTextView.heightAnchor == 200
    }
    
    private func setupActions() {
        mathDemoButton.addTarget(self, action: #selector(mathDemoTapped), for: .touchUpInside)
        contentDemoButton.addTarget(self, action: #selector(contentDemoTapped), for: .touchUpInside)
        imageDemoButton.addTarget(self, action: #selector(imageDemoTapped), for: .touchUpInside)
        networkDemoButton.addTarget(self, action: #selector(networkDemoTapped), for: .touchUpInside)
        combinationDemoButton.addTarget(self, action: #selector(combinationDemoTapped), for: .touchUpInside)
        fullDemoButton.addTarget(self, action: #selector(fullDemoTapped), for: .touchUpInside)
    }
    
    private func setupAICapabilities() {
        // 注册基础插件（如果还没有注册）
        manager.register(plugin: MathCapabilityPlugin())
        manager.register(plugin: ContentCapabilityPlugin())
        manager.register(plugin: ImageCapabilityPlugin())
        manager.register(plugin: NetworkCapabilityPlugin())
        
        // 注册演示业务配置
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "demo_001",
            businessName: "AI能力演示",
            enabledCapabilities: AICapabilityType.allCases,
            quotaLimits: [:],
            customParameters: ["demo_mode": true]
        ))
    }
    
    private func createDemoButton(title: String, subtitle: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 12
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(NSAttributedString(
            string: title + "\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        ))
        attributedTitle.append(NSAttributedString(
            string: subtitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.white.withAlphaComponent(0.9)
            ]
        ))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.heightAnchor == 70
        
        return button
    }
    
    private func appendResult(_ text: String) {
        DispatchQueue.main.async {
            self.resultTextView.text += text + "\n"
            let bottom = NSMakeRange(self.resultTextView.text.count - 1, 1)
            self.resultTextView.scrollRangeToVisible(bottom)
        }
    }
    
    // MARK: - Actions
    
    @objc private func mathDemoTapped() {
        appendResult("🧮 开始数学能力演示...")
        
        Task {
            await demonstrateMathCapability()
        }
    }
    
    @objc private func contentDemoTapped() {
        appendResult("📄 开始内容处理演示...")
        
        Task {
            await demonstrateContentCapability()
        }
    }
    
    @objc private func imageDemoTapped() {
        appendResult("🎨 开始图像处理演示...")
        
        Task {
            await demonstrateImageCapability()
        }
    }
    
    @objc private func networkDemoTapped() {
        appendResult("🌐 开始网络服务演示...")
        
        Task {
            await demonstrateNetworkCapability()
        }
    }
    
    @objc private func combinationDemoTapped() {
        appendResult("🔗 开始能力组合演示...")
        
        Task {
            await demonstrateCapabilityCombination()
        }
    }
    
    @objc private func fullDemoTapped() {
        appendResult("🚀 开始完整平台演示...")

        Task {
            await AICapabilityDemo.runCompleteDemo()
            appendResult("✅ 完整平台演示完成！")
        }
    }

    // MARK: - Demo Methods

    private func demonstrateMathCapability() async {
        do {
            // 数学出题
            let genRequest = AICapabilityRequest(
                capabilityType: .mathProblemGeneration,
                input: .text("二次函数"),
                parameters: ["difficulty": "medium"]
            )

            let genResponse = try await manager.execute(request: genRequest, for: "demo_001")
            appendResult("✅ 数学出题完成 (耗时: \(String(format: "%.3f", genResponse.processingTime))秒)")

            // 数学解题
            let solveRequest = AICapabilityRequest(
                capabilityType: .mathProblemSolving,
                input: .text("求解方程：x² + 2x - 3 = 0")
            )

            let solveResponse = try await manager.execute(request: solveRequest, for: "demo_001")
            appendResult("✅ 数学解题完成 (耗时: \(String(format: "%.3f", solveResponse.processingTime))秒)")

        } catch {
            appendResult("❌ 数学能力演示失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateContentCapability() async {
        do {
            // OCR识别
            let ocrRequest = AICapabilityRequest(
                capabilityType: .ocr,
                input: .image(Data()),
                parameters: ["enhance": true]
            )

            let ocrResponse = try await manager.execute(request: ocrRequest, for: "demo_001")
            appendResult("✅ OCR识别完成 (耗时: \(String(format: "%.3f", ocrResponse.processingTime))秒)")

            // 文本摘要
            let summaryRequest = AICapabilityRequest(
                capabilityType: .textSummary,
                input: .text("人工智能技术正在快速发展，深度学习、自然语言处理等领域取得重大突破...")
            )

            let summaryResponse = try await manager.execute(request: summaryRequest, for: "demo_001")
            appendResult("✅ 文本摘要完成 (耗时: \(String(format: "%.3f", summaryResponse.processingTime))秒)")

        } catch {
            appendResult("❌ 内容处理演示失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateImageCapability() async {
        do {
            // 图片生成
            let genRequest = AICapabilityRequest(
                capabilityType: .imageGeneration,
                input: .text("一只可爱的小猫在花园里玩耍")
            )

            let genResponse = try await manager.execute(request: genRequest, for: "demo_001")
            appendResult("✅ 图片生成完成 (耗时: \(String(format: "%.3f", genResponse.processingTime))秒)")

            // 图片水印
            let watermarkRequest = AICapabilityRequest(
                capabilityType: .imageWatermark,
                input: .image(Data())
            )

            let watermarkResponse = try await manager.execute(request: watermarkRequest, for: "demo_001")
            appendResult("✅ 图片水印完成 (耗时: \(String(format: "%.3f", watermarkResponse.processingTime))秒)")

        } catch {
            appendResult("❌ 图像处理演示失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateNetworkCapability() async {
        do {
            // 网络搜索
            let searchRequest = AICapabilityRequest(
                capabilityType: .webSearch,
                input: .text("人工智能最新发展")
            )

            let searchResponse = try await manager.execute(request: searchRequest, for: "demo_001")
            appendResult("✅ 网络搜索完成 (耗时: \(String(format: "%.3f", searchResponse.processingTime))秒)")

        } catch {
            appendResult("❌ 网络服务演示失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateCapabilityCombination() async {
        appendResult("🔄 执行能力组合：OCR → 文本摘要 → 翻译")

        do {
            // 步骤1：OCR识别
            let ocrRequest = AICapabilityRequest(
                capabilityType: .ocr,
                input: .image(Data())
            )
            let ocrResponse = try await manager.execute(request: ocrRequest, for: "demo_001")
            appendResult("  ✅ 步骤1 OCR识别完成")

            // 步骤2：文本摘要
            let summaryRequest = AICapabilityRequest(
                capabilityType: .textSummary,
                input: .text("OCR识别的文本内容...")
            )
            let summaryResponse = try await manager.execute(request: summaryRequest, for: "demo_001")
            appendResult("  ✅ 步骤2 文本摘要完成")

            // 步骤3：翻译
            let translateRequest = AICapabilityRequest(
                capabilityType: .translation,
                input: .text("摘要后的文本内容...")
            )
            let translateResponse = try await manager.execute(request: translateRequest, for: "demo_001")
            appendResult("  ✅ 步骤3 翻译完成")

            let totalTime = ocrResponse.processingTime + summaryResponse.processingTime + translateResponse.processingTime
            appendResult("🎉 能力组合演示完成！总耗时: \(String(format: "%.3f", totalTime))秒")

        } catch {
            appendResult("❌ 能力组合演示失败: \(error.localizedDescription)")
        }
    }
}
