//
//  FeedbackScenarioDemo.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

// MARK: - String Extension for Demo

private extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

/// 反馈收集场景演示 - 展示业务方A和B使用相同功能组件的细微差别
final class FeedbackScenarioDemo {
    
    private let manager = AICapabilityManager.shared
    
    /// 运行反馈收集场景演示
    static func runFeedbackScenarios() async {
        let demo = FeedbackScenarioDemo()
        await demo.showScenarioOverview()
        await demo.setupFeedbackEnvironment()
        await demo.demonstrateBusinessA()
        await demo.demonstrateBusinessB()
        await demo.demonstrateUIDifferences()
        await demo.demonstrateLogicDifferences()
        demo.showFeedbackSummary()
    }
    
    // MARK: - 场景概览
    
    private func showScenarioOverview() async {
        print("📝 反馈收集场景演示")
        print("=" * 60)
        
        print("\n🎯 场景背景:")
        print("   在实际开发中，不同业务方可能需要使用相同的功能组件，")
        print("   但在UI展示和逻辑处理上存在细微差别。通过插件化架构，")
        print("   我们可以为每个业务方提供定制化的实现，同时保持代码复用。")
        
        print("\n🏢 业务方介绍:")
        print("   🏢 业务方A (BusinessA):")
        print("      • 面向企业客户的反馈收集系统")
        print("      • UI主题：企业级专业风格")
        print("      • 逻辑特色：CRM集成、优先级升级、专业回复")
        
        print("\n   💻 业务方B (BusinessB):")
        print("      • 面向技术团队的反馈收集系统")
        print("      • UI主题：开发者友好风格")
        print("      • 逻辑特色：GitHub集成、技术标签、知识库关联")
        
        print("\n🔧 技术特色:")
        print("   • 相同功能组件的差异化实现")
        print("   • UI主题和样式的业务方定制")
        print("   • 逻辑处理的业务方特定优化")
        print("   • 元数据驱动的差异化展示")
        
        print("\n💡 业务价值:")
        print("   • 提高代码复用率")
        print("   • 降低维护成本")
        print("   • 支持业务方特定需求")
        print("   • 保持功能一致性")
    }
    
    // MARK: - 环境设置
    
    func setupFeedbackEnvironment() async {
        print("\n📦 注册反馈收集相关插件...")
        print("-" * 40)
        
        // 注册反馈收集相关插件
        manager.register(plugin: FeedbackCollectionPlugin())
        print("   ✅ 注册通用反馈收集插件 - 支持基础反馈收集")
        
        manager.register(plugin: BusinessAFeedbackPlugin())
        print("   ✅ 注册业务方A专用反馈插件 - 企业级反馈收集")
        
        manager.register(plugin: BusinessBFeedbackPlugin())
        print("   ✅ 注册业务方B专用反馈插件 - 技术团队反馈收集")
        
        // 注册业务方A配置
        let businessAConfig = BusinessConfiguration(
            businessId: "business_a",
            businessName: "业务方A",
            enabledCapabilities: [.feedbackCollection],
            quotaLimits: [
                .feedbackCollection: 500
            ],
            customParameters: [
                "brand_name": "BusinessA",
                "brand_logo": "🏢",
                "ui_theme": "enterprise",
                "customer_type": "enterprise",
                "feedback_features": ["crm_integration", "priority_escalation", "professional_reply"]
            ]
        )
        manager.register(businessConfiguration: businessAConfig)
        print("   ✅ 注册业务方A配置 - 企业级反馈收集")
        
        // 注册业务方B配置
        let businessBConfig = BusinessConfiguration(
            businessId: "business_b",
            businessName: "业务方B",
            enabledCapabilities: [.feedbackCollection],
            quotaLimits: [
                .feedbackCollection: 300
            ],
            customParameters: [
                "brand_name": "BusinessB",
                "brand_logo": "💻",
                "ui_theme": "developer",
                "customer_type": "technical",
                "feedback_features": ["github_integration", "tech_tags", "knowledge_base_linking"]
            ]
        )
        manager.register(businessConfiguration: businessBConfig)
        print("   ✅ 注册业务方B配置 - 技术团队反馈收集")
        
        print("\n✅ 反馈收集环境设置完成")
        print("   已注册 \(manager.getPluginStatistics()["total_plugins"] ?? 0) 个插件")
        print("   已配置 \(manager.getPluginStatistics()["registered_businesses"] ?? 0) 个业务方")
    }
    
    // MARK: - 业务方A演示
    
    func demonstrateBusinessA() async {
        print("\n🏢 业务方A - 企业级反馈收集系统")
        print("=" * 50)
        
        print("\n📋 业务场景描述:")
        print("   业务方A面向企业客户，需要提供专业、正式的反馈收集体验，")
        print("   包括CRM系统集成、优先级自动升级、专业回复等功能。")
        
        let businessId = "business_a"
        
        // 场景1：企业客户反馈
        print("\n📝 场景1：企业客户产品反馈")
        print("   场景描述：企业客户对产品功能提出改进建议")
        print("   业务价值：提供专业的客户服务体验，增强客户满意度")
        await demonstrateFeedbackCollection(
            businessId: businessId,
            feedback: "希望在产品中增加更多的数据分析功能，这对我们的业务决策很重要",
            scenario: "企业客户产品反馈"
        )
        
        // 场景2：紧急问题反馈
        print("\n🚨 场景2：紧急问题反馈")
        print("   场景描述：客户报告紧急的技术问题")
        print("   业务价值：快速响应紧急问题，提升客户信任度")
        await demonstrateFeedbackCollection(
            businessId: businessId,
            feedback: "系统出现紧急问题，影响我们的日常业务运营，需要立即解决",
            scenario: "紧急问题反馈"
        )
    }
    
    // MARK: - 业务方B演示
    
    func demonstrateBusinessB() async {
        print("\n💻 业务方B - 技术团队反馈收集系统")
        print("=" * 50)
        
        print("\n📋 业务场景描述:")
        print("   业务方B面向技术团队，需要提供开发者友好的反馈收集体验，")
        print("   包括GitHub集成、技术标签、知识库关联等功能。")
        
        let businessId = "business_b"
        
        // 场景1：功能建议反馈
        print("\n💡 场景1：功能建议反馈")
        print("   场景描述：开发者提出新功能建议")
        print("   业务价值：收集技术团队的专业建议，促进产品改进")
        await demonstrateFeedbackCollection(
            businessId: businessId,
            feedback: "建议在API中增加批量操作接口，这样可以提高数据处理效率",
            scenario: "功能建议反馈"
        )
        
        // 场景2：Bug报告反馈
        print("\n🐛 场景2：Bug报告反馈")
        print("   场景描述：开发者报告技术Bug")
        print("   业务价值：快速定位和修复技术问题，提升系统稳定性")
        await demonstrateFeedbackCollection(
            businessId: businessId,
            feedback: "在文档中发现了API调用示例的错误，这会导致开发者使用困难",
            scenario: "Bug报告反馈"
        )
    }
    
    // MARK: - UI差异演示
    
    func demonstrateUIDifferences() async {
        print("\n🎨 UI差异演示")
        print("=" * 40)
        
        print("\n📱 业务方A UI特色 (企业级):")
        print("   • 主题色彩：专业蓝色系")
        print("   • 字体风格：正式商务字体")
        print("   • 布局设计：简洁专业布局")
        print("   • 交互元素：正式按钮样式")
        print("   • 品牌元素：企业Logo和标语")
        print("   • 响应式设计：适配桌面端优先")
        
        print("\n💻 业务方B UI特色 (开发者):")
        print("   • 主题色彩：技术深色系")
        print("   • 字体风格：等宽代码字体")
        print("   • 布局设计：紧凑技术布局")
        print("   • 交互元素：技术风格按钮")
        print("   • 品牌元素：技术Logo和标识")
        print("   • 响应式设计：适配移动端优先")
        
        print("\n🔄 相同功能组件的UI差异:")
        print("   📝 反馈表单：")
        print("      • 业务方A：正式表单布局，企业级验证")
        print("      • 业务方B：技术表单布局，开发者友好验证")
        
        print("   📊 反馈结果：")
        print("      • 业务方A：专业报告格式，企业级展示")
        print("      • 业务方B：技术报告格式，开发者友好展示")
        
        print("   🎯 操作按钮：")
        print("      • 业务方A：正式按钮样式，专业文案")
        print("      • 业务方B：技术按钮样式，开发者文案")
    }
    
    // MARK: - 逻辑差异演示
    
    func demonstrateLogicDifferences() async {
        print("\n🔧 逻辑差异演示")
        print("=" * 40)
        
        print("\n🏢 业务方A 逻辑特色 (企业级):")
        print("   • 反馈分类：产品功能、服务质量、技术支持、价格政策")
        print("   • 优先级评估：基于客户重要性和问题紧急程度")
        print("   • 自动升级：高优先级问题自动升级到高级客服")
        print("   • CRM集成：反馈自动记录到客户关系管理系统")
        print("   • 专业回复：使用正式商务语言回复客户")
        print("   • 满意度评分：5分制评分系统")
        
        print("\n💻 业务方B 逻辑特色 (技术团队):")
        print("   • 反馈分类：功能建议、Bug报告、性能问题、文档改进")
        print("   • 严重程度评估：基于技术影响和用户影响")
        print("   • GitHub集成：自动创建Issue并分配标签")
        print("   • 知识库关联：自动关联相关技术文档")
        print("   • 技术回复：使用技术术语和代码示例回复")
        print("   • 满意度评分：10分制评分系统")
        
        print("\n🔄 相同功能组件的逻辑差异:")
        print("   📝 反馈处理：")
        print("      • 业务方A：企业级处理流程，注重客户关系")
        print("      • 业务方B：技术处理流程，注重问题解决")
        
        print("   📊 数据分析：")
        print("      • 业务方A：客户满意度分析，业务价值评估")
        print("      • 业务方B：技术问题分析，代码质量评估")
        
        print("   🎯 响应机制：")
        print("      • 业务方A：专业客服响应，企业级服务标准")
        print("      • 业务方B：技术团队响应，开发者服务标准")
    }
    
    // MARK: - 具体功能演示
    
    private func demonstrateFeedbackCollection(businessId: String, feedback: String, scenario: String) async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .feedbackCollection,
                input: .text(feedback)
            )
            
            let response = try await manager.execute(request: request, for: businessId)
            
            if case .text(let result) = response.output {
                print("   📝 反馈内容: \(feedback)")
                print("   📊 处理结果: \(result.prefix(200))...")
                
                // 显示业务方特定的元数据
                if let brand = response.metadata["brand"] as? String {
                    print("   🏷️ 品牌标识: \(brand)")
                }
                if let uiTheme = response.metadata["ui_theme"] as? String {
                    print("   🎨 UI主题: \(uiTheme)")
                }
                if let category = response.metadata["feedback_category"] as? String {
                    print("   🏷️ 分类标签: \(category)")
                }
                if let priority = response.metadata["priority_level"] as? String {
                    print("   ⚡ 优先级: \(priority)")
                }
                if let severity = response.metadata["severity_level"] as? String {
                    print("   ⚠️ 严重程度: \(severity)")
                }
                if let enterpriseFeatures = response.metadata["enterprise_features"] as? Bool, enterpriseFeatures {
                    print("   🏢 企业级功能: 已启用")
                }
                if let developerFeatures = response.metadata["developer_features"] as? Bool, developerFeatures {
                    print("   💻 开发者功能: 已启用")
                }
                if let githubIntegration = response.metadata["github_integration"] as? Bool, githubIntegration {
                    print("   🔗 GitHub集成: 已启用")
                }
                if let crmIntegration = response.metadata["crm_integration"] as? Bool, crmIntegration {
                    print("   📊 CRM集成: 已启用")
                }
            }
            
        } catch {
            print("   ❌ 反馈收集失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 总结
    
    private func showFeedbackSummary() {
        print("\n📊 反馈收集场景总结")
        print("=" * 40)
        
        let stats = manager.getPluginStatistics()
        print("📈 插件统计:")
        print("   • 总插件数: \(stats["total_plugins"] ?? 0)")
        print("   • 支持能力数: \(stats["supported_capabilities"] ?? 0)")
        print("   • 覆盖率: \(String(format: "%.1f", (stats["coverage_rate"] as? Double ?? 0) * 100))%")
        print("   • 注册业务方: \(stats["registered_businesses"] ?? 0)")
        
        print("\n🎯 业务方功能对比:")
        print("   🏢 业务方A (企业级反馈收集):")
        print("      • UI特色: 企业级专业风格")
        print("      • 逻辑特色: CRM集成、优先级升级、专业回复")
        print("      • 业务价值: 提供专业客户服务体验")
        
        print("\n   💻 业务方B (技术团队反馈收集):")
        print("      • UI特色: 开发者友好风格")
        print("      • 逻辑特色: GitHub集成、技术标签、知识库关联")
        print("      • 业务价值: 提供技术团队协作体验")
        
        print("\n🔧 技术亮点:")
        print("   • 相同功能组件的差异化实现")
        print("   • UI主题和样式的业务方定制")
        print("   • 逻辑处理的业务方特定优化")
        print("   • 元数据驱动的差异化展示")
        print("   • 插件选择机制的智能应用")
        
        print("\n💡 架构优势:")
        print("   • 代码复用: 相同功能组件在不同业务方间复用")
        print("   • 差异化定制: 支持业务方特定的UI和逻辑需求")
        print("   • 易于维护: 统一的接口，差异化的实现")
        print("   • 灵活扩展: 新增业务方只需实现专用插件")
        
        print("\n✅ 演示完成 - 成功展示了相同功能组件的差异化实现")
        print("   通过插件化架构，实现了代码复用与业务定制的完美平衡。")
    }
} 