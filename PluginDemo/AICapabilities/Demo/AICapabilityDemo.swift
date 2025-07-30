//
//  AICapabilityDemo.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// AI 能力组合演示 - 展示插件式架构在 AI 能力组合中的应用
final class AICapabilityDemo {
    
    private let manager = AICapabilityManager.shared
    
    /// 运行完整演示
    static func runCompleteDemo() async {
        let demo = AICapabilityDemo()
        await demo.setupPluginsAndBusinesses()
        await demo.demonstrateBusinessScenarios()

        // 新增：智慧教育专项场景演示
        await EducationScenarioDemo.runEducationScenarios()
        
        // 新增：即时通信场景演示
        await ChatScenarioDemo.runChatScenarios()
        
        // 运行反馈收集场景演示
        await FeedbackScenarioDemo.runFeedbackScenarios()
        
                // 新增：深度思考按钮场景演示
        await DeepThinkingButtonDemo.runDeepThinkingButtonScenarios()
        
        // 新增：Chat模块架构演示
        await ChatModuleDemo.runChatModuleScenarios()
        
        await demo.demonstrateCapabilityCombinations()
        demo.showStatistics()
    }
    
    // MARK: - 初始化设置
    
    private func setupPluginsAndBusinesses() async {
        print("🚀 AI能力组合平台演示")
        print("=" * 50)
        
        // 注册所有AI能力插件
        print("\n📦 注册AI能力插件...")
        manager.register(plugin: MathCapabilityPlugin())
        manager.register(plugin: DeepThinkingPlugin())
        manager.register(plugin: ContentCapabilityPlugin())
        manager.register(plugin: ImageCapabilityPlugin())
        manager.register(plugin: NetworkCapabilityPlugin())
        manager.register(plugin: MultimediaCapabilityPlugin()) // 与NetworkCapabilityPlugin竞争videoCall能力

        // 新增教育专用插件
        manager.register(plugin: EducationCapabilityPlugin())
        manager.register(plugin: ContentRecommendationPlugin())
        manager.register(plugin: InteractionCapabilityPlugin())
        manager.register(plugin: AdvancedTTSPlugin()) // 高优先级TTS插件
        
        // 新增聊天相关插件
        manager.register(plugin: ChatDialoguePlugin())
        manager.register(plugin: BusinessADeepThinkingPlugin()) // 业务方A专用深度思考
        manager.register(plugin: BusinessBDeepThinkingPlugin()) // 业务方B专用深度思考
        manager.register(plugin: DocumentAnalysisPlugin())
        
        // 新增深度思考按钮专用插件
        manager.register(plugin: BusinessACustomerDeepThinkingPlugin()) // 业务方A客户UI深度思考
        manager.register(plugin: BusinessBEnterpriseDeepThinkingPlugin()) // 业务方B企业UI深度思考
        
        // 新增Chat模块相关插件
        manager.register(plugin: GeneralChatPlugin()) // 通用Chat插件
        manager.register(plugin: BusinessACustomerServiceChatPlugin()) // 业务方A智能客服Chat
        manager.register(plugin: BusinessBEnterpriseChatPlugin()) // 业务方B企业级Chat
        
        // 新增反馈收集相关插件
        manager.register(plugin: FeedbackCollectionPlugin())
        manager.register(plugin: BusinessAFeedbackPlugin()) // 业务方A专用反馈收集
        manager.register(plugin: BusinessBFeedbackPlugin()) // 业务方B专用反馈收集
        
        // 注册不同业务方配置
        print("\n🏢 注册业务方配置...")
        
        // 教育机构 - 专注学习相关能力（更新为包含新能力）
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "edu_001",
            businessName: "智慧教育平台",
            enabledCapabilities: [
                .mathProblemGeneration, .mathProblemSolving, .ocr, .textSummary, .translation,
                .dataAnalysis, .userProfiling, .contentRecommendation, .tts, .dialogueInteraction
            ],
            quotaLimits: [.mathProblemGeneration: 100, .mathProblemSolving: 50],
            customParameters: ["education_level": "high_school", "subject_focus": "mathematics"]
        ))
        
        // 内容创作公司 - 专注创意和内容处理
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "content_001",
            businessName: "创意内容工作室",
            enabledCapabilities: [.imageGeneration, .imageWatermark, .deepThinking, .textSummary, .translation, .webSearch],
            quotaLimits: [.imageGeneration: 20, .deepThinking: 30],
            customParameters: ["content_type": "marketing", "style_preference": "modern"]
        ))
        
        // 企业办公 - 全能力套餐
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "enterprise_001",
            businessName: "企业智能办公",
            enabledCapabilities: AICapabilityType.allCases, // 启用所有能力（包括新增的聊天相关能力）
            quotaLimits: [:], // 无限制
            customParameters: ["enterprise_level": "premium", "security_level": "high"]
        ))
        
        // 个人用户 - 基础能力包
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "personal_001",
            businessName: "个人助手",
            enabledCapabilities: [.textSummary, .translation, .webSearch, .ocr],
            quotaLimits: [.textSummary: 10, .translation: 20, .webSearch: 30],
            customParameters: ["user_type": "individual", "subscription": "basic"]
        ))
        
        // 即时通信业务方A - 带品牌logo的深度思考
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "business_a",
            businessName: "业务方A",
            enabledCapabilities: [.chatDialogue, .webSearch, .deepThinking],
            quotaLimits: [
                .chatDialogue: 1000,
                .webSearch: 500,
                .deepThinking: 200
            ],
            customParameters: [
                "brand_name": "BusinessA",
                "brand_logo": "🏢",
                "premium_features": true
            ]
        ))
        
        // 即时通信业务方B - 连接知识库的深度思考
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "business_b",
            businessName: "业务方B",
            enabledCapabilities: [.chatDialogue, .documentAnalysis, .deepThinking],
            quotaLimits: [
                .chatDialogue: 800,
                .documentAnalysis: 300,
                .deepThinking: 150
            ],
            customParameters: [
                "brand_name": "BusinessB",
                "knowledge_base_enabled": true,
                "document_analysis_enabled": true
            ]
        ))
        
        print("\n✅ 插件和业务配置注册完成")
    }
    
    // MARK: - 业务场景演示
    
    private func demonstrateBusinessScenarios() async {
        print("\n" + "=" * 50)
        print("🎯 业务场景演示")
        print("=" * 50)
        
        // 场景1：教育机构 - 数学学习辅助
        await demonstrateEducationScenario()
        
        // 场景2：内容创作 - 创意内容生成
        await demonstrateContentCreationScenario()
        
        // 场景3：企业办公 - 综合办公助手
        await demonstrateEnterpriseScenario()
        
        // 场景4：个人用户 - 日常助手
        await demonstratePersonalScenario()
        
        // 场景5：即时通信业务方A - 带品牌logo的深度思考
        await demonstrateBusinessAScenario()
        
        // 场景6：即时通信业务方B - 连接知识库的深度思考
        await demonstrateBusinessBScenario()
    }
    
    private func demonstrateEducationScenario() async {
        print("\n📚 场景1：智慧教育平台")
        print("-" * 30)
        
        // 数学出题
        let mathGenRequest = AICapabilityRequest(
            capabilityType: .mathProblemGeneration,
            input: .text("二次函数"),
            parameters: ["difficulty": "medium", "count": 3]
        )
        
        do {
            let response = try await manager.execute(request: mathGenRequest, for: "edu_001")
            if case .text(let result) = response.output {
                print("📝 数学出题结果：")
                print(result.prefix(200) + "...")
            }
        } catch {
            print("❌ 数学出题失败: \(error.localizedDescription)")
        }
        
        // OCR + 文本摘要组合
        print("\n🔄 能力组合：OCR识别 + 文本摘要")
        await demonstrateCapabilityCombination(
            businessId: "edu_001",
            capabilities: [.ocr, .textSummary],
            description: "识别课本内容并生成摘要"
        )
    }
    
    private func demonstrateContentCreationScenario() async {
        print("\n🎨 场景2：创意内容工作室")
        print("-" * 30)
        
        // 深度思考 + 图像生成组合
        print("🔄 能力组合：深度思考 + 图像生成")
        await demonstrateCapabilityCombination(
            businessId: "content_001",
            capabilities: [.deepThinking, .imageGeneration],
            description: "创意策划和视觉设计"
        )
    }
    
    private func demonstrateEnterpriseScenario() async {
        print("\n🏢 场景3：企业智能办公")
        print("-" * 30)
        
        // 网络搜索 + 深度思考 + 文本摘要组合
        print("🔄 能力组合：网络搜索 + 深度思考 + 文本摘要")
        await demonstrateCapabilityCombination(
            businessId: "enterprise_001",
            capabilities: [.webSearch, .deepThinking, .textSummary],
            description: "市场调研和分析报告"
        )
    }
    
    private func demonstratePersonalScenario() async {
        print("\n👤 场景4：个人助手")
        print("-" * 30)
        
        // 翻译服务
        let translationRequest = AICapabilityRequest(
            capabilityType: .translation,
            input: .text("人工智能正在改变我们的生活方式"),
            parameters: ["target_language": "en-US"]
        )
        
        do {
            let response = try await manager.execute(request: translationRequest, for: "personal_001")
            if case .text(let result) = response.output {
                print("🌐 翻译结果：")
                print(result.prefix(200) + "...")
            }
        } catch {
            print("❌ 翻译失败: \(error.localizedDescription)")
        }
    }
    
    private func demonstrateBusinessAScenario() async {
        print("\n🏢 场景5：业务方A - 带品牌logo的深度思考")
        print("-" * 30)
        
        // 聊天对话 + 网络搜索 + 深度思考组合
        print("🔄 能力组合：聊天对话 + 网络搜索 + 深度思考")
        await demonstrateCapabilityCombination(
            businessId: "business_a",
            capabilities: [.chatDialogue, .webSearch, .deepThinking],
            description: "智能对话增强分析"
        )
    }
    
    private func demonstrateBusinessBScenario() async {
        print("\n🏢 场景6：业务方B - 连接知识库的深度思考")
        print("-" * 30)
        
        // 聊天对话 + 文档分析 + 深度思考组合
        print("🔄 能力组合：聊天对话 + 文档分析 + 深度思考")
        await demonstrateCapabilityCombination(
            businessId: "business_b",
            capabilities: [.chatDialogue, .documentAnalysis, .deepThinking],
            description: "知识库增强的智能分析"
        )
    }
    
    // MARK: - 能力组合演示
    
    private func demonstrateCapabilityCombinations() async {
        print("\n" + "=" * 50)
        print("🔗 智能能力组合演示")
        print("=" * 50)
        
        let businesses = ["edu_001", "content_001", "enterprise_001", "personal_001", "business_a", "business_b"]
        
        for businessId in businesses {
            if let config = manager.getBusinessConfiguration(for: businessId) {
                print("\n🏢 \(config.businessName) 可用组合：")
                let combinations = manager.getCapabilityCombinations(for: businessId)
                
                for (index, combination) in combinations.enumerated() {
                    let names = combination.map { $0.displayName }.joined(separator: " + ")
                    print("   \(index + 1). \(names)")
                }
                
                if combinations.isEmpty {
                    print("   暂无可用的能力组合")
                }
            }
        }
    }
    
    private func demonstrateCapabilityCombination(businessId: String, capabilities: [AICapabilityType], description: String) async {
        print("📋 组合描述：\(description)")
        print("🔧 涉及能力：\(capabilities.map { $0.displayName }.joined(separator: " → "))")
        
        // 显示业务方信息
        if let config = manager.getBusinessConfiguration(for: businessId) {
            print("🏢 业务方：\(config.businessName)")
        }
        
        for (index, capability) in capabilities.enumerated() {
            let request = AICapabilityRequest(
                capabilityType: capability,
                input: .text("组合演示输入 \(index + 1)"),
                parameters: ["combination_step": index + 1]
            )
            
            do {
                let response = try await manager.execute(request: request, for: businessId)
                print("   ✅ 步骤\(index + 1) (\(capability.displayName)): 执行成功")
                print("      处理时间: \(String(format: "%.3f", response.processingTime))秒")
                
                // 显示业务方特定的元数据
                if let brand = response.metadata["brand"] as? String {
                    print("      🏷️ 品牌标识: \(brand)")
                }
                if let knowledgeBaseConnected = response.metadata["knowledge_base_connected"] as? Bool, knowledgeBaseConnected {
                    print("      📚 知识库已连接")
                }
                if let brandLogoIncluded = response.metadata["brand_logo_included"] as? Bool, brandLogoIncluded {
                    print("      🏢 品牌logo已包含")
                }
            } catch {
                print("   ❌ 步骤\(index + 1) (\(capability.displayName)): \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 统计信息
    
    private func showStatistics() {
        print("\n" + "=" * 50)
        print("📊 平台统计信息")
        print("=" * 50)
        
        let stats = manager.getPluginStatistics()
        
        print("🔌 插件统计：")
        print("   总插件数：\(stats["total_plugins"] ?? 0)")
        print("   总能力数：\(stats["total_capabilities"] ?? 0)")
        print("   已支持能力：\(stats["supported_capabilities"] ?? 0)")
        print("   覆盖率：\(String(format: "%.1f", (stats["coverage_rate"] as? Double ?? 0) * 100))%")
        print("   注册业务方：\(stats["registered_businesses"] ?? 0)")
        
        print("\n🎯 能力分布：")
        let allPlugins = manager.getAllPlugins()
        for plugin in allPlugins {
            let capabilityNames = plugin.supportedCapabilities.map { $0.displayName }.joined(separator: ", ")
            if let businessPlugin = plugin as? BusinessSpecificPlugin {
                print("   \(plugin.displayName) [\(businessPlugin.targetBusinessId)]: \(capabilityNames)")
            } else {
                print("   \(plugin.displayName): \(capabilityNames)")
            }
        }
        
        print("\n🏢 业务方配置：")
        let allBusinesses = ["edu_001", "content_001", "enterprise_001", "personal_001", "business_a", "business_b"]
        for businessId in allBusinesses {
            if let config = manager.getBusinessConfiguration(for: businessId) {
                let capabilityCount = config.enabledCapabilities.count
                let capabilityNames = config.enabledCapabilities.map { $0.displayName }.joined(separator: ", ")
                print("   \(config.businessName): \(capabilityCount) 种能力")
                print("      \(capabilityNames)")
            }
        }
        
        print("\n🎯 即时通信场景特色：")
        print("   • 业务方A: 品牌化深度思考，带logo标识")
        print("   • 业务方B: 知识库增强深度思考，连接专属知识库")
        print("   • 插件竞争: 同一能力支持多个不同实现")
        print("   • 业务隔离: 不同业务方的定制需求完全独立")
        
        print("\n✅ AI能力组合平台演示完成")
        print("=" * 50)
    }
}

// MARK: - String Extension

private extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
