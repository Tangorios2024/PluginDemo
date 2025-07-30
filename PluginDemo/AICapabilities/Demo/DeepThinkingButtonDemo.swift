//
//  DeepThinkingButtonDemo.swift
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

/// 深度思考按钮场景演示 - 展示业务方A和B在聊天功能中深度思考按钮的不同定制化实现
final class DeepThinkingButtonDemo {
    
    private let manager = AICapabilityManager.shared
    
    /// 运行深度思考按钮场景演示
    static func runDeepThinkingButtonScenarios() async {
        let demo = DeepThinkingButtonDemo()
        await demo.showScenarioOverview()
        await demo.setupDeepThinkingEnvironment()
        await demo.demonstrateBusinessAButton()
        await demo.demonstrateBusinessBButton()
        await demo.demonstrateUIDifferences()
        await demo.demonstrateLogicDifferences()
        demo.showDeepThinkingButtonSummary()
    }
    
    // MARK: - 场景概览
    
    private func showScenarioOverview() async {
        print("🤔 深度思考按钮场景演示")
        print("=" * 60)
        
        print("\n🎯 场景背景:")
        print("   在聊天功能中，深度思考按钮是一个重要的AI增强功能。")
        print("   不同业务方对深度思考按钮有不同的UI展示需求和逻辑处理要求。")
        print("   通过插件化架构，我们可以为每个业务方提供定制化的深度思考体验。")
        
        print("\n🏢 业务方需求分析:")
        print("   🏢 业务方A (BusinessA):")
        print("      • UI风格：客户UI - 友好、直观、易用")
        print("      • 按钮样式：圆角、渐变色彩、动画效果")
        print("      • 逻辑处理：直接调用AI模型进行深度思考")
        print("      • 功能特色：快速响应、简洁分析、用户友好")
        
        print("\n   💻 业务方B (BusinessB):")
        print("      • UI风格：企业UI - 专业、正式、商务")
        print("      • 按钮样式：直角、单色、简洁设计")
        print("      • 逻辑处理：关闭网络搜索，仅使用内部知识库")
        print("      • 功能特色：知识库增强、专业分析、数据安全")
        
        print("\n🔧 技术特色:")
        print("   • UI组件的业务方定制")
        print("   • 按钮样式的差异化实现")
        print("   • 逻辑处理的业务方特定配置")
        print("   • 网络访问控制的安全机制")
        
        print("\n💡 业务价值:")
        print("   • 提供符合业务方品牌形象的UI体验")
        print("   • 满足不同业务方的功能需求")
        print("   • 确保数据安全和隐私保护")
        print("   • 提升用户满意度和使用体验")
    }
    
    // MARK: - 环境设置
    
    private func setupDeepThinkingEnvironment() async {
        print("\n📦 注册深度思考按钮相关插件...")
        print("-" * 40)
        
        // 注册基础聊天插件
        manager.register(plugin: ChatDialoguePlugin())
        print("   ✅ 注册基础聊天插件 - 支持智能对话")
        
        // 注册网络搜索插件
        manager.register(plugin: NetworkCapabilityPlugin())
        print("   ✅ 注册网络搜索插件 - 支持实时信息获取")
        
        // 注册业务方A专用深度思考插件（客户UI风格）
        manager.register(plugin: BusinessACustomerDeepThinkingPlugin())
        print("   ✅ 注册业务方A客户UI深度思考插件 - 直接调用模型")
        
        // 注册业务方B专用深度思考插件（企业UI风格）
        manager.register(plugin: BusinessBEnterpriseDeepThinkingPlugin())
        print("   ✅ 注册业务方B企业UI深度思考插件 - 知识库增强")
        
        // 注册业务方A配置（客户UI风格）
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
        print("   ✅ 注册业务方A配置 - 客户UI风格深度思考")
        
        // 注册业务方B配置（企业UI风格）
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
        print("   ✅ 注册业务方B配置 - 企业UI风格深度思考")
        
        print("\n✅ 深度思考按钮环境设置完成")
        print("   已注册 \(manager.getPluginStatistics()["total_plugins"] ?? 0) 个插件")
        print("   已配置 \(manager.getPluginStatistics()["registered_businesses"] ?? 0) 个业务方")
    }
    
    // MARK: - 业务方A演示（客户UI风格）
    
    private func demonstrateBusinessAButton() async {
        print("\n🏢 业务方A - 客户UI风格深度思考按钮")
        print("=" * 50)
        
        print("\n📋 业务场景描述:")
        print("   业务方A面向普通客户，需要提供友好、直观的深度思考按钮体验。")
        print("   按钮采用客户UI风格，直接调用AI模型进行快速分析。")
        
        let businessId = "business_a"
        
        // 场景1：客户咨询深度分析
        print("\n💬 场景1：客户咨询深度分析")
        print("   场景描述：客户点击深度思考按钮，获得快速、友好的分析")
        print("   业务价值：提供直观易懂的分析结果，提升客户满意度")
        await demonstrateCustomerDeepThinking(
            businessId: businessId,
            topic: "我想了解如何提高工作效率",
            scenario: "客户咨询深度分析"
        )
        
        // 场景2：产品使用建议
        print("\n💡 场景2：产品使用建议")
        print("   场景描述：客户寻求产品使用的最佳实践建议")
        print("   业务价值：提供个性化建议，增强产品粘性")
        await demonstrateCustomerDeepThinking(
            businessId: businessId,
            topic: "如何更好地使用你们的AI产品来提升我的工作效率",
            scenario: "产品使用建议"
        )
    }
    
    // MARK: - 业务方B演示（企业UI风格）
    
    private func demonstrateBusinessBButton() async {
        print("\n💻 业务方B - 企业UI风格深度思考按钮")
        print("=" * 50)
        
        print("\n📋 业务场景描述:")
        print("   业务方B面向企业客户，需要提供专业、安全的深度思考按钮体验。")
        print("   按钮采用企业UI风格，关闭网络搜索，仅使用内部知识库进行分析。")
        
        let businessId = "business_b"
        
        // 场景1：企业技术方案分析
        print("\n🏢 场景1：企业技术方案分析")
        print("   场景描述：企业客户点击深度思考按钮，获得基于知识库的专业分析")
        print("   业务价值：提供安全、专业的分析结果，满足企业级需求")
        await demonstrateEnterpriseDeepThinking(
            businessId: businessId,
            topic: "如何设计一个高可用的微服务架构",
            scenario: "企业技术方案分析"
        )
        
        // 场景2：安全合规建议
        print("\n🔒 场景2：安全合规建议")
        print("   场景描述：企业客户寻求安全合规方面的专业建议")
        print("   业务价值：基于内部知识库提供安全可靠的建议")
        await demonstrateEnterpriseDeepThinking(
            businessId: businessId,
            topic: "如何确保我们的系统符合数据保护法规要求",
            scenario: "安全合规建议"
        )
    }
    
    // MARK: - UI差异演示
    
    private func demonstrateUIDifferences() async {
        print("\n🎨 UI差异演示")
        print("=" * 40)
        
        print("\n📱 业务方A 客户UI特色:")
        print("   • 按钮样式：圆角设计 (border-radius: 20px)")
        print("   • 色彩方案：渐变背景 (linear-gradient)")
        print("   • 字体风格：友好字体 (font-family: 'Friendly')")
        print("   • 图标设计：可爱图标 (🤔)")
        print("   • 动画效果：弹跳动画 (bounce animation)")
        print("   • 交互反馈：即时响应 (immediate feedback)")
        print("   • 文案风格：亲切友好 ('让我想想...')")
        print("   • 加载状态：进度条动画 (progress bar)")
        
        print("\n💼 业务方B 企业UI特色:")
        print("   • 按钮样式：直角设计 (border-radius: 4px)")
        print("   • 色彩方案：单色背景 (#2C3E50)")
        print("   • 字体风格：商务字体 (font-family: 'Professional')")
        print("   • 图标设计：专业图标 (⚡)")
        print("   • 动画效果：淡入淡出 (fade animation)")
        print("   • 交互反馈：延迟响应 (delayed feedback)")
        print("   • 文案风格：专业正式 ('深度分析中...')")
        print("   • 加载状态：旋转图标 (spinner)")
        
        print("\n🔄 相同功能组件的UI差异:")
        print("   🤔 深度思考按钮：")
        print("      • 业务方A：客户UI - 友好、直观、易用")
        print("      • 业务方B：企业UI - 专业、正式、商务")
        
        print("   📊 分析结果展示：")
        print("      • 业务方A：客户UI - 简洁、易懂、图文并茂")
        print("      • 业务方B：企业UI - 详细、专业、数据驱动")
        
        print("   ⚙️ 设置选项：")
        print("      • 业务方A：客户UI - 简单设置、一键操作")
        print("      • 业务方B：企业UI - 高级设置、详细配置")
    }
    
    // MARK: - 逻辑差异演示
    
    private func demonstrateLogicDifferences() async {
        print("\n🔧 逻辑差异演示")
        print("=" * 40)
        
        print("\n🏢 业务方A 逻辑特色 (客户UI):")
        print("   • 网络访问：启用 (network_access: true)")
        print("   • 知识库访问：禁用 (knowledge_base_access: false)")
        print("   • 分析模式：直接调用模型 (deep_thinking_mode: 'direct_model')")
        print("   • 响应速度：快速响应 (quick_response)")
        print("   • 分析深度：简洁分析 (simple_analysis)")
        print("   • 数据来源：实时网络 + AI模型")
        print("   • 安全级别：标准安全 (standard_security)")
        print("   • 用户权限：基础权限 (basic_permissions)")
        
        print("\n💻 业务方B 逻辑特色 (企业UI):")
        print("   • 网络访问：禁用 (network_access: false)")
        print("   • 知识库访问：启用 (knowledge_base_access: true)")
        print("   • 分析模式：知识库增强 (deep_thinking_mode: 'knowledge_base_only')")
        print("   • 响应速度：深度分析 (deep_analysis)")
        print("   • 分析深度：专业分析 (professional_analysis)")
        print("   • 数据来源：内部知识库 + AI模型")
        print("   • 安全级别：企业级安全 (enterprise_security)")
        print("   • 用户权限：高级权限 (advanced_permissions)")
        
        print("\n🔄 相同功能组件的逻辑差异:")
        print("   🔍 数据获取：")
        print("      • 业务方A：开放网络访问，实时获取最新信息")
        print("      • 业务方B：关闭网络访问，仅使用内部知识库")
        
        print("   🧠 分析处理：")
        print("      • 业务方A：直接调用AI模型，快速生成分析")
        print("      • 业务方B：结合知识库数据，深度专业分析")
        
        print("   🔒 安全控制：")
        print("      • 业务方A：标准安全措施，适合普通用户")
        print("      • 业务方B：企业级安全控制，满足合规要求")
    }
    
    // MARK: - 具体功能演示
    
    private func demonstrateCustomerDeepThinking(businessId: String, topic: String, scenario: String) async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .deepThinking,
                input: .text(topic)
            )
            
            let response = try await manager.execute(request: request, for: businessId)
            
            if case .text(let result) = response.output {
                print("   📝 思考主题: \(topic)")
                print("   🎨 UI风格: 客户UI - 友好、直观、易用")
                print("   🧠 分析结果: \(result.prefix(300))...")
                
                // 显示客户UI特定的元数据
                if let uiTheme = response.metadata["ui_theme"] as? String {
                    print("   🎨 UI主题: \(uiTheme)")
                }
                if let buttonStyle = response.metadata["button_style"] as? String {
                    print("   🔘 按钮样式: \(buttonStyle)")
                }
                if let thinkingMode = response.metadata["thinking_mode"] as? String {
                    print("   🧠 思考模式: \(thinkingMode)")
                }
                if let networkAccess = response.metadata["network_access"] as? Bool, networkAccess {
                    print("   🌐 网络访问: 已启用")
                }
                if let knowledgeBaseAccess = response.metadata["knowledge_base_access"] as? Bool, knowledgeBaseAccess {
                    print("   📚 知识库访问: 已启用")
                }
                if let responseTime = response.metadata["response_time"] as? String {
                    print("   ⏱️ 响应时间: \(responseTime)")
                }
                if let customerFeatures = response.metadata["customer_features"] as? [String] {
                    print("   ✨ 客户特色: \(customerFeatures.joined(separator: ", "))")
                }
            }
            
        } catch {
            print("   ❌ 客户UI深度思考失败: \(error.localizedDescription)")
        }
    }
    
    private func demonstrateEnterpriseDeepThinking(businessId: String, topic: String, scenario: String) async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .deepThinking,
                input: .text(topic)
            )
            
            let response = try await manager.execute(request: request, for: businessId)
            
            if case .text(let result) = response.output {
                print("   📝 思考主题: \(topic)")
                print("   💼 UI风格: 企业UI - 专业、正式、商务")
                print("   🧠 分析结果: \(result.prefix(300))...")
                
                // 显示企业UI特定的元数据
                if let uiTheme = response.metadata["ui_theme"] as? String {
                    print("   🎨 UI主题: \(uiTheme)")
                }
                if let buttonStyle = response.metadata["button_style"] as? String {
                    print("   🔘 按钮样式: \(buttonStyle)")
                }
                if let thinkingMode = response.metadata["thinking_mode"] as? String {
                    print("   🧠 思考模式: \(thinkingMode)")
                }
                if let networkAccess = response.metadata["network_access"] as? Bool, !networkAccess {
                    print("   🚫 网络访问: 已禁用")
                }
                if let knowledgeBaseAccess = response.metadata["knowledge_base_access"] as? Bool, knowledgeBaseAccess {
                    print("   📚 知识库访问: 已启用")
                }
                if let responseTime = response.metadata["response_time"] as? String {
                    print("   ⏱️ 响应时间: \(responseTime)")
                }
                if let enterpriseFeatures = response.metadata["enterprise_features"] as? [String] {
                    print("   🏢 企业特色: \(enterpriseFeatures.joined(separator: ", "))")
                }
                if let securityLevel = response.metadata["security_level"] as? String {
                    print("   🔒 安全级别: \(securityLevel)")
                }
            }
            
        } catch {
            print("   ❌ 企业UI深度思考失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 总结
    
    private func showDeepThinkingButtonSummary() {
        print("\n📊 深度思考按钮场景总结")
        print("=" * 40)
        
        let stats = manager.getPluginStatistics()
        print("📈 插件统计:")
        print("   • 总插件数: \(stats["total_plugins"] ?? 0)")
        print("   • 支持能力数: \(stats["supported_capabilities"] ?? 0)")
        print("   • 覆盖率: \(String(format: "%.1f", (stats["coverage_rate"] as? Double ?? 0) * 100))%")
        print("   • 注册业务方: \(stats["registered_businesses"] ?? 0)")
        
        print("\n🎯 业务方功能对比:")
        print("   🏢 业务方A (客户UI风格):")
        print("      • UI特色: 客户UI - 友好、直观、易用")
        print("      • 逻辑特色: 直接调用模型、网络访问启用")
        print("      • 按钮样式: 圆角、渐变、动画效果")
        print("      • 业务价值: 提供用户友好的深度思考体验")
        
        print("\n   💻 业务方B (企业UI风格):")
        print("      • UI特色: 企业UI - 专业、正式、商务")
        print("      • 逻辑特色: 知识库增强、网络访问禁用")
        print("      • 按钮样式: 直角、单色、简洁设计")
        print("      • 业务价值: 提供安全专业的深度思考体验")
        
        print("\n🔧 技术亮点:")
        print("   • UI组件的业务方定制")
        print("   • 按钮样式的差异化实现")
        print("   • 逻辑处理的业务方特定配置")
        print("   • 网络访问控制的安全机制")
        print("   • 知识库集成的专业分析")
        
        print("\n💡 架构优势:")
        print("   • 完全解耦: UI和逻辑的差异化完全独立")
        print("   • 易于扩展: 新增业务方只需实现专用插件")
        print("   • 配置灵活: 支持业务方特定的UI和逻辑配置")
        print("   • 安全可控: 支持网络访问的精确控制")
        
        print("\n✅ 演示完成 - 成功展示了深度思考按钮的差异化实现")
        print("   通过插件化架构，实现了UI定制和逻辑控制的完美结合，")
        print("   为不同业务方提供了符合其需求的深度思考体验。")
    }
} 