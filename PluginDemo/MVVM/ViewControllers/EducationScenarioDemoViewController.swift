//
//  EducationScenarioDemoViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Anchorage

/// 智慧教育场景演示页面
final class EducationScenarioDemoViewController: UIViewController {
    
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
        label.text = "🎓 智慧教育场景演示"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "展示AI能力在教育场景中的创新应用，通过插件式架构实现复杂的教育业务流程"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var scenario1Button: UIButton = {
        let btn = createScenarioButton(
            title: "📚 场景1：智能学习助手",
            subtitle: "智能出题 → 拍照识别 → 解答分析 → 错题收集 → 学习周报 → 一对一讲解",
            backgroundColor: .systemBlue
        )
        return btn
    }()
    
    private lazy var scenario2Button: UIButton = {
        let btn = createScenarioButton(
            title: "📖 场景2：互动故事推荐",
            subtitle: "用户画像 → 故事推荐 → 个性化生成 → 语音合成 → 智能交互",
            backgroundColor: .systemGreen
        )
        return btn
    }()
    
    private lazy var userProfilingButton: UIButton = {
        let btn = createCapabilityButton(
            title: "👤 用户画像分析",
            backgroundColor: .systemOrange
        )
        return btn
    }()
    
    private lazy var contentRecommendationButton: UIButton = {
        let btn = createCapabilityButton(
            title: "🎯 智能内容推荐",
            backgroundColor: .systemPurple
        )
        return btn
    }()
    
    private lazy var storyGenerationButton: UIButton = {
        let btn = createCapabilityButton(
            title: "✍️ 个性化故事生成",
            backgroundColor: .systemTeal
        )
        return btn
    }()
    
    private lazy var ttsButton: UIButton = {
        let btn = createCapabilityButton(
            title: "🎵 高级语音合成",
            backgroundColor: .systemIndigo
        )
        return btn
    }()
    
    private lazy var dataAnalysisButton: UIButton = {
        let btn = createCapabilityButton(
            title: "📊 学习数据分析",
            backgroundColor: .systemRed
        )
        return btn
    }()
    
    private lazy var fullEducationDemoButton: UIButton = {
        let btn = createScenarioButton(
            title: "🚀 完整教育场景演示",
            subtitle: "运行所有教育场景和能力组合",
            backgroundColor: .systemBrown
        )
        return btn
    }()
    
    private lazy var resultTextView: UITextView = {
        let textView = UITextView()
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.text = "🎓 欢迎使用智慧教育场景演示！\n点击上方按钮体验不同的教育AI能力...\n\n"
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            scenario1Button,
            scenario2Button,
            createSeparatorView(),
            createSectionLabel("🔧 单项能力演示"),
            userProfilingButton,
            contentRecommendationButton,
            storyGenerationButton,
            ttsButton,
            dataAnalysisButton,
            createSeparatorView(),
            fullEducationDemoButton,
            resultTextView
        ])
        stack.axis = .vertical
        stack.spacing = 12
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
        setupEducationCapabilities()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "智慧教育演示"
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
        
        resultTextView.heightAnchor == 250
    }
    
    private func setupActions() {
        scenario1Button.addTarget(self, action: #selector(scenario1Tapped), for: .touchUpInside)
        scenario2Button.addTarget(self, action: #selector(scenario2Tapped), for: .touchUpInside)
        userProfilingButton.addTarget(self, action: #selector(userProfilingTapped), for: .touchUpInside)
        contentRecommendationButton.addTarget(self, action: #selector(contentRecommendationTapped), for: .touchUpInside)
        storyGenerationButton.addTarget(self, action: #selector(storyGenerationTapped), for: .touchUpInside)
        ttsButton.addTarget(self, action: #selector(ttsTapped), for: .touchUpInside)
        dataAnalysisButton.addTarget(self, action: #selector(dataAnalysisTapped), for: .touchUpInside)
        fullEducationDemoButton.addTarget(self, action: #selector(fullEducationDemoTapped), for: .touchUpInside)
    }
    
    private func setupEducationCapabilities() {
        // 注册教育专用插件
        manager.register(plugin: MathCapabilityPlugin())
        manager.register(plugin: ContentCapabilityPlugin())
        manager.register(plugin: NetworkCapabilityPlugin())
        manager.register(plugin: EducationCapabilityPlugin())
        manager.register(plugin: ContentRecommendationPlugin())
        manager.register(plugin: InteractionCapabilityPlugin())
        manager.register(plugin: AdvancedTTSPlugin())
        
        // 注册智慧教育业务配置
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "education_demo_001",
            businessName: "智慧教育演示平台",
            enabledCapabilities: [
                .mathProblemGeneration, .mathProblemSolving, .ocr, .dataAnalysis, .textSummary, .videoCall,
                .userProfiling, .contentRecommendation, .storyGeneration, .tts, .dialogueInteraction
            ],
            quotaLimits: [:],
            customParameters: [
                "education_level": "primary_school",
                "demo_mode": true,
                "safety_level": "high"
            ]
        ))
    }
    
    private func createScenarioButton(title: String, subtitle: String, backgroundColor: UIColor) -> UIButton {
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
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.white.withAlphaComponent(0.9)
            ]
        ))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.heightAnchor == 80
        
        return button
    }
    
    private func createCapabilityButton(title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 8
        button.heightAnchor == 44
        
        return button
    }
    
    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor == 1
        return view
    }
    
    private func createSectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }
    
    private func appendResult(_ text: String) {
        DispatchQueue.main.async {
            self.resultTextView.text += text + "\n"
            let bottom = NSMakeRange(self.resultTextView.text.count - 1, 1)
            self.resultTextView.scrollRangeToVisible(bottom)
        }
    }

    // MARK: - Actions

    @objc private func scenario1Tapped() {
        appendResult("📚 开始场景1：智能学习助手演示...")

        Task {
            await demonstrateSmartLearningAssistant()
        }
    }

    @objc private func scenario2Tapped() {
        appendResult("📖 开始场景2：互动故事推荐演示...")

        Task {
            await demonstrateInteractiveStoryTelling()
        }
    }

    @objc private func userProfilingTapped() {
        appendResult("👤 开始用户画像分析...")

        Task {
            await demonstrateUserProfiling()
        }
    }

    @objc private func contentRecommendationTapped() {
        appendResult("🎯 开始智能内容推荐...")

        Task {
            await demonstrateContentRecommendation()
        }
    }

    @objc private func storyGenerationTapped() {
        appendResult("✍️ 开始个性化故事生成...")

        Task {
            await demonstrateStoryGeneration()
        }
    }

    @objc private func ttsTapped() {
        appendResult("🎵 开始高级语音合成...")

        Task {
            await demonstrateTTS()
        }
    }

    @objc private func dataAnalysisTapped() {
        appendResult("📊 开始学习数据分析...")

        Task {
            await demonstrateDataAnalysis()
        }
    }

    @objc private func fullEducationDemoTapped() {
        appendResult("🚀 开始完整教育场景演示...")

        Task {
            await EducationScenarioDemo.runEducationScenarios()
            appendResult("✅ 完整教育场景演示完成！")
        }
    }

    // MARK: - Demo Methods

    private func demonstrateSmartLearningAssistant() async {
        appendResult("🔄 执行智能学习助手完整流程...")

        do {
            // 步骤1：智能出题
            appendResult("  📝 步骤1：智能出题")
            let mathGenRequest = AICapabilityRequest(
                capabilityType: .mathProblemGeneration,
                input: .text("小学四年级数学 - 分数运算"),
                parameters: ["difficulty": "medium", "count": 3]
            )
            let genResponse = try await manager.execute(request: mathGenRequest, for: "education_demo_001")
            appendResult("    ✅ 数学出题完成 (耗时: \(String(format: "%.3f", genResponse.processingTime))秒)")

            // 步骤2：拍照识别
            appendResult("  📷 步骤2：拍照识别题目")
            let ocrRequest = AICapabilityRequest(
                capabilityType: .ocr,
                input: .image(Data()),
                parameters: ["image_type": "math_problem"]
            )
            let ocrResponse = try await manager.execute(request: ocrRequest, for: "education_demo_001")
            appendResult("    ✅ OCR识别完成 (耗时: \(String(format: "%.3f", ocrResponse.processingTime))秒)")

            // 步骤3：智能解答
            appendResult("  🔍 步骤3：智能解答")
            let solveRequest = AICapabilityRequest(
                capabilityType: .mathProblemSolving,
                input: .text("计算：3/4 + 1/2 = ?")
            )
            let solveResponse = try await manager.execute(request: solveRequest, for: "education_demo_001")
            appendResult("    ✅ 数学解题完成 (耗时: \(String(format: "%.3f", solveResponse.processingTime))秒)")

            // 步骤4：学习数据分析
            appendResult("  📊 步骤4：学习数据分析")
            let analysisRequest = AICapabilityRequest(
                capabilityType: .dataAnalysis,
                input: .structured([
                    "analysis_type": "learning_progress",
                    "student_id": "student_001",
                    "wrong_answers": [
                        ["question": "3/4 + 1/2", "student_answer": "4/6", "correct_answer": "5/4"]
                    ]
                ])
            )
            let analysisResponse = try await manager.execute(request: analysisRequest, for: "education_demo_001")
            appendResult("    ✅ 数据分析完成 (耗时: \(String(format: "%.3f", analysisResponse.processingTime))秒)")

            // 步骤5：生成学习周报
            appendResult("  📋 步骤5：生成学习周报")
            let summaryRequest = AICapabilityRequest(
                capabilityType: .textSummary,
                input: .text("本周学习数据：完成练习45道，正确率78%，主要错误在分数运算...")
            )
            let summaryResponse = try await manager.execute(request: summaryRequest, for: "education_demo_001")
            appendResult("    ✅ 学习周报完成 (耗时: \(String(format: "%.3f", summaryResponse.processingTime))秒)")

            // 步骤6：一对一视频讲解
            appendResult("  🎥 步骤6：一对一视频讲解")
            let callRequest = AICapabilityRequest(
                capabilityType: .videoCall,
                input: .structured([
                    "target_user": "teacher_001",
                    "call_type": "video",
                    "session_type": "tutoring"
                ])
            )
            let callResponse = try await manager.execute(request: callRequest, for: "education_demo_001")
            appendResult("    ✅ 视频通话建立 (耗时: \(String(format: "%.3f", callResponse.processingTime))秒)")

            let totalTime = genResponse.processingTime + ocrResponse.processingTime +
                           solveResponse.processingTime + analysisResponse.processingTime +
                           summaryResponse.processingTime + callResponse.processingTime
            appendResult("🎉 智能学习助手演示完成！总耗时: \(String(format: "%.3f", totalTime))秒")

        } catch {
            appendResult("❌ 智能学习助手演示失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateInteractiveStoryTelling() async {
        appendResult("🔄 执行互动故事推荐完整流程...")

        do {
            // 步骤1：构建用户画像
            appendResult("  👤 步骤1：构建用户画像")
            let profilingRequest = AICapabilityRequest(
                capabilityType: .userProfiling,
                input: .structured([
                    "age": 8,
                    "reading_level": "intermediate",
                    "interests": ["太空", "动物", "科学"],
                    "vocabulary_level": 2500
                ])
            )
            let profilingResponse = try await manager.execute(request: profilingRequest, for: "education_demo_001")
            appendResult("    ✅ 用户画像完成 (耗时: \(String(format: "%.3f", profilingResponse.processingTime))秒)")

            // 步骤2：个性化内容推荐
            appendResult("  🎯 步骤2：个性化内容推荐")
            let recommendationRequest = AICapabilityRequest(
                capabilityType: .contentRecommendation,
                input: .structured([
                    "age": 8,
                    "interests": ["太空", "动物", "科学"],
                    "reading_level": "intermediate"
                ])
            )
            let recommendationResponse = try await manager.execute(request: recommendationRequest, for: "education_demo_001")
            appendResult("    ✅ 内容推荐完成 (耗时: \(String(format: "%.3f", recommendationResponse.processingTime))秒)")

            // 步骤3：生成个性化故事
            appendResult("  ✍️ 步骤3：生成个性化故事")
            let storyRequest = AICapabilityRequest(
                capabilityType: .storyGeneration,
                input: .structured([
                    "theme": "太空探险",
                    "character_name": "小星",
                    "educational_elements": ["天文知识", "友谊", "勇气"]
                ])
            )
            let storyResponse = try await manager.execute(request: storyRequest, for: "education_demo_001")
            appendResult("    ✅ 故事生成完成 (耗时: \(String(format: "%.3f", storyResponse.processingTime))秒)")

            // 步骤4：语音合成
            appendResult("  🎵 步骤4：语音合成")
            let ttsRequest = AICapabilityRequest(
                capabilityType: .tts,
                input: .text("小星是一个对宇宙充满好奇心的小朋友...")
            )
            let ttsResponse = try await manager.execute(request: ttsRequest, for: "education_demo_001")
            appendResult("    ✅ 语音合成完成 (耗时: \(String(format: "%.3f", ttsResponse.processingTime))秒)")

            // 步骤5：智能交互对话
            appendResult("  💬 步骤5：智能交互对话")
            let dialogueRequest = AICapabilityRequest(
                capabilityType: .dialogueInteraction,
                input: .structured([
                    "user_input": "我想知道小星会遇到什么外星朋友",
                    "context": "story_telling",
                    "story_progress": "middle"
                ])
            )
            let dialogueResponse = try await manager.execute(request: dialogueRequest, for: "education_demo_001")
            appendResult("    ✅ 智能交互完成 (耗时: \(String(format: "%.3f", dialogueResponse.processingTime))秒)")

            let totalTime = profilingResponse.processingTime + recommendationResponse.processingTime +
                           storyResponse.processingTime + ttsResponse.processingTime + dialogueResponse.processingTime
            appendResult("🎉 互动故事推荐演示完成！总耗时: \(String(format: "%.3f", totalTime))秒")

        } catch {
            appendResult("❌ 互动故事推荐演示失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateUserProfiling() async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .userProfiling,
                input: .structured([
                    "age": 10,
                    "reading_level": "advanced",
                    "interests": ["科学", "历史", "艺术"],
                    "learning_history": ["completed_stories": 25, "favorite_genres": ["adventure", "mystery"]]
                ])
            )

            let response = try await manager.execute(request: request, for: "education_demo_001")
            appendResult("✅ 用户画像分析完成 (耗时: \(String(format: "%.3f", response.processingTime))秒)")

            if let dimensions = response.metadata["profile_dimensions"] as? Int {
                appendResult("📊 分析维度: \(dimensions)个")
            }

        } catch {
            appendResult("❌ 用户画像分析失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateContentRecommendation() async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .contentRecommendation,
                input: .structured([
                    "age": 9,
                    "interests": ["动物", "自然", "探险"],
                    "reading_level": "intermediate",
                    "session_time": "evening"
                ])
            )

            let response = try await manager.execute(request: request, for: "education_demo_001")
            appendResult("✅ 智能内容推荐完成 (耗时: \(String(format: "%.3f", response.processingTime))秒)")

            if let count = response.metadata["recommendation_count"] as? Int {
                appendResult("📚 推荐故事数量: \(count)个")
            }

        } catch {
            appendResult("❌ 智能内容推荐失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateStoryGeneration() async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .storyGeneration,
                input: .structured([
                    "theme": "海底探险",
                    "character_name": "小鱼",
                    "story_length": "medium",
                    "educational_elements": ["海洋生物", "环保", "友谊"]
                ])
            )

            let response = try await manager.execute(request: request, for: "education_demo_001")
            appendResult("✅ 个性化故事生成完成 (耗时: \(String(format: "%.3f", response.processingTime))秒)")

            if let length = response.metadata["story_length"] as? Int {
                appendResult("📖 故事长度: \(length)字")
            }

        } catch {
            appendResult("❌ 个性化故事生成失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateTTS() async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .tts,
                input: .text("在遥远的海底世界里，住着一只聪明可爱的小鱼，它的名字叫小鱼。小鱼对海洋世界充满了好奇心..."),
                parameters: [
                    "voice_settings": [
                        "voice_type": "child_friendly",
                        "emotion": "cheerful",
                        "background_music": "gentle"
                    ]
                ]
            )

            let response = try await manager.execute(request: request, for: "education_demo_001")
            appendResult("✅ 高级语音合成完成 (耗时: \(String(format: "%.3f", response.processingTime))秒)")

            if let quality = response.metadata["quality_level"] as? String {
                appendResult("🎵 音质等级: \(quality)")
            }

        } catch {
            appendResult("❌ 高级语音合成失败: \(error.localizedDescription)")
        }
    }

    private func demonstrateDataAnalysis() async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .dataAnalysis,
                input: .structured([
                    "analysis_type": "learning_progress",
                    "student_id": "student_demo_001",
                    "time_period": "last_month",
                    "subjects": ["math", "reading"],
                    "performance_data": [
                        "total_exercises": 120,
                        "correct_rate": 0.85,
                        "learning_time": 1800 // 30小时
                    ]
                ])
            )

            let response = try await manager.execute(request: request, for: "education_demo_001")
            appendResult("✅ 学习数据分析完成 (耗时: \(String(format: "%.3f", response.processingTime))秒)")

            if let dataPoints = response.metadata["data_points"] as? Int {
                appendResult("📊 分析数据点: \(dataPoints)个")
            }

        } catch {
            appendResult("❌ 学习数据分析失败: \(error.localizedDescription)")
        }
    }
}
