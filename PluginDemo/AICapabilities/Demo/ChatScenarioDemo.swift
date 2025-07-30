//
//  ChatScenarioDemo.swift
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

/// 即时通信场景演示 - 展示两个业务方的不同功能组合
final class ChatScenarioDemo {
    
    private let manager = AICapabilityManager.shared
    
    /// 运行即时通信场景演示
    static func runChatScenarios() async {
        let demo = ChatScenarioDemo()
        await demo.showScenarioOverview()
        await demo.setupChatEnvironment()
        await demo.demonstrateBusinessA()
        await demo.demonstrateBusinessB()
        await demo.demonstrateAdvancedScenarios()
        demo.showChatSummary()
    }
    
    // MARK: - 场景概览
    
    private func showScenarioOverview() async {
        print("💬 即时通信场景演示")
        print("=" * 60)
        
        print("\n🎯 场景背景:")
        print("   在即时通信应用中，不同业务方需要定制化的AI对话能力。")
        print("   通过插件化架构，我们可以为每个业务方提供专属的AI能力组合，")
        print("   同时保持基础功能的复用性和系统的可扩展性。")
        
        print("\n🏢 业务方介绍:")
        print("   📱 业务方A (BusinessA):")
        print("      • 面向企业客户的智能客服平台")
        print("      • 需要品牌化展示和实时信息获取")
        print("      • 特色：带品牌logo的深度思考分析")
        
        print("\n   🏢 业务方B (BusinessB):")
        print("      • 面向技术团队的协作平台")
        print("      • 需要文档分析和知识库集成")
        print("      • 特色：知识库增强的深度思考")
        
        print("\n🔧 技术特色:")
        print("   • 业务方专用插件 (BusinessSpecificPlugin)")
        print("   • 智能插件选择机制")
        print("   • 能力复用与定制化并存")
        print("   • 动态配置和参数传递")
        
        print("\n💡 业务价值:")
        print("   • 降低定制化开发成本")
        print("   • 提高功能复用率")
        print("   • 支持快速业务扩展")
        print("   • 保证业务隔离和数据安全")
    }
    
    // MARK: - 环境设置
    
    private func setupChatEnvironment() async {
        print("\n📦 注册聊天相关插件...")
        print("-" * 40)
        
        // 注册聊天相关插件
        manager.register(plugin: ChatDialoguePlugin())
        print("   ✅ 注册基础聊天插件 - 支持智能对话")
        
        manager.register(plugin: NetworkCapabilityPlugin()) // webSearch
        print("   ✅ 注册网络搜索插件 - 支持实时信息获取")
        
        manager.register(plugin: DeepThinkingPlugin()) // 通用深度思考
        print("   ✅ 注册通用深度思考插件 - 支持基础分析")
        
        manager.register(plugin: BusinessADeepThinkingPlugin()) // 业务方A专用深度思考
        print("   ✅ 注册业务方A专用深度思考插件 - 带品牌定制")
        
        manager.register(plugin: BusinessBDeepThinkingPlugin()) // 业务方B专用深度思考
        print("   ✅ 注册业务方B专用深度思考插件 - 连接知识库")
        
        manager.register(plugin: DocumentAnalysisPlugin())
        print("   ✅ 注册文档分析插件 - 支持技术文档解析")
        
        // 注册业务方A配置
        let businessAConfig = BusinessConfiguration(
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
                "premium_features": true,
                "customer_type": "enterprise",
                "support_level": "premium"
            ]
        )
        manager.register(businessConfiguration: businessAConfig)
        print("   ✅ 注册业务方A配置 - 企业级智能客服")
        
        // 注册业务方B配置
        let businessBConfig = BusinessConfiguration(
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
                "document_analysis_enabled": true,
                "customer_type": "technical",
                "support_level": "standard",
                "knowledge_domains": ["技术文档", "最佳实践", "案例分析"]
            ]
        )
        manager.register(businessConfiguration: businessBConfig)
        print("   ✅ 注册业务方B配置 - 技术团队协作平台")
        
        print("\n✅ 聊天环境设置完成")
        print("   已注册 \(manager.getPluginStatistics()["total_plugins"] ?? 0) 个插件")
        print("   已配置 \(manager.getPluginStatistics()["registered_businesses"] ?? 0) 个业务方")
    }
    
    // MARK: - 业务方A演示
    
    private func demonstrateBusinessA() async {
        print("\n🏢 业务方A - 企业级智能客服平台")
        print("=" * 50)
        
        print("\n📋 业务场景描述:")
        print("   业务方A是一家面向企业客户的智能客服平台，")
        print("   需要提供品牌化的AI服务，包括智能对话、实时信息获取")
        print("   和深度分析能力，以提升客户服务质量和品牌形象。")
        
        let businessId = "business_a"
        
        // 场景1：基础聊天对话
        print("\n💬 场景1：智能客服对话")
        print("   场景描述：企业客户咨询AI技术发展趋势")
        print("   业务价值：提供专业、友好的客户服务体验")
        await demonstrateChatDialogue(businessId: businessId, message: "你好，我想了解一下人工智能的发展趋势，特别是对我们企业数字化转型的影响")
        
        // 场景2：网络搜索增强
        print("\n🌐 场景2：实时信息获取")
        print("   场景描述：客户需要最新的技术信息")
        print("   业务价值：提供准确、及时的行业信息，增强服务可信度")
        await demonstrateWebSearch(businessId: businessId, query: "2024年最新的人工智能技术发展和企业应用案例")
        
        // 场景3：带品牌logo的深度思考
        print("\n🤔 场景3：品牌化深度分析")
        print("   场景描述：为客户提供定制化的深度分析报告")
        print("   业务价值：展示专业能力，提升品牌价值，增强客户粘性")
        await demonstrateDeepThinking(businessId: businessId, topic: "如何构建企业级AI解决方案，包括技术选型、实施策略和ROI分析")
    }
    
    // MARK: - 业务方B演示
    
    private func demonstrateBusinessB() async {
        print("\n🏢 业务方B - 技术团队协作平台")
        print("=" * 50)
        
        print("\n📋 业务场景描述:")
        print("   业务方B是一个面向技术团队的协作平台，")
        print("   需要提供文档分析、知识库查询和深度思考能力，")
        print("   帮助技术团队提高工作效率和决策质量。")
        
        let businessId = "business_b"
        
        // 场景1：基础聊天对话
        print("\n💬 场景1：技术咨询对话")
        print("   场景描述：技术团队咨询架构设计问题")
        print("   业务价值：提供技术支持和知识分享")
        await demonstrateChatDialogue(businessId: businessId, message: "请帮我分析一下这个技术文档，看看我们的架构设计是否合理")
        
        // 场景2：文档分析
        print("\n📄 场景2：技术文档分析")
        print("   场景描述：分析微服务架构设计文档")
        print("   业务价值：提供专业的文档评估和改进建议")
        await demonstrateDocumentAnalysis(businessId: businessId, document: """
        微服务架构设计指南
        
        1. 概述
           微服务架构是一种将应用程序构建为一组小型自治服务的软件架构模式。
           每个服务运行在自己的进程中，通过轻量级机制进行通信。
        
        2. 核心原则
           - 单一职责原则：每个服务专注于单一业务功能
           - 服务自治：服务独立部署、扩展和升级
           - 数据隔离：每个服务管理自己的数据
           - 技术多样性：不同服务可以使用不同的技术栈
        
        3. 实施步骤
           - 服务拆分：基于业务边界进行服务划分
           - API设计：定义服务间的接口契约
           - 数据管理：处理分布式数据一致性
           - 部署策略：选择合适的部署模式
        
        4. 技术栈
           - Docker容器化：提供一致的运行环境
           - Kubernetes编排：管理容器生命周期
           - 服务网格：处理服务间通信
           - 监控告警：实时监控系统状态
        
        5. 挑战与风险
           - 分布式系统复杂性
           - 数据一致性问题
           - 服务间依赖管理
           - 运维复杂度增加
        """)
        
        // 场景3：结合知识库的深度思考
        print("\n🤔 场景3：知识库增强分析")
        print("   场景描述：基于历史经验和知识库进行深度分析")
        print("   业务价值：提供基于历史数据的专业建议，降低决策风险")
        await demonstrateDeepThinking(businessId: businessId, topic: "微服务架构的最佳实践和风险控制，包括性能优化、安全防护和故障处理策略")
    }
    
    // MARK: - 高级场景演示
    
    private func demonstrateAdvancedScenarios() async {
        print("\n🚀 高级场景演示")
        print("=" * 40)
        
        print("\n🔄 场景4：能力组合演示")
        print("   演示不同能力类型的组合使用")
        
        // 演示业务方A的能力组合
        print("\n   📱 业务方A能力组合：聊天对话 → 网络搜索 → 深度思考")
        await demonstrateCapabilityCombination(
            businessId: "business_a",
            capabilities: [.chatDialogue, .webSearch, .deepThinking],
            description: "智能客服的完整服务流程"
        )
        
        // 演示业务方B的能力组合
        print("\n   🏢 业务方B能力组合：聊天对话 → 文档分析 → 深度思考")
        await demonstrateCapabilityCombination(
            businessId: "business_b",
            capabilities: [.chatDialogue, .documentAnalysis, .deepThinking],
            description: "技术团队协作的完整工作流程"
        )
        
        print("\n🔍 场景5：插件选择机制演示")
        print("   演示系统如何智能选择最合适的插件")
        await demonstratePluginSelection()
    }
    
    private func demonstrateCapabilityCombination(businessId: String, capabilities: [AICapabilityType], description: String) async {
        print("   📋 \(description)")
        
        for (index, capability) in capabilities.enumerated() {
            print("   🔄 步骤\(index + 1)：\(capability.displayName)")
            
            do {
                let request = AICapabilityRequest(
                    capabilityType: capability,
                    input: .text("演示\(capability.displayName)功能")
                )
                
                let response = try await manager.execute(request: request, for: businessId)
                
                if case .text(let result) = response.output {
                    print("      ✅ 执行成功 - \(result.prefix(100))...")
                    
                    // 显示特殊元数据
                    if let brand = response.metadata["brand"] as? String {
                        print("      🏷️ 品牌标识: \(brand)")
                    }
                    if let knowledgeBaseConnected = response.metadata["knowledge_base_connected"] as? Bool, knowledgeBaseConnected {
                        print("      📚 知识库已连接")
                    }
                    if let brandLogoIncluded = response.metadata["brand_logo_included"] as? Bool, brandLogoIncluded {
                        print("      🏢 品牌logo已包含")
                    }
                }
                
            } catch {
                print("      ❌ 执行失败: \(error.localizedDescription)")
            }
        }
    }
    
    private func demonstratePluginSelection() async {
        print("   🎯 深度思考能力插件选择演示")
        
        // 演示业务方A的插件选择
        print("   📱 业务方A深度思考请求:")
        do {
            let request = AICapabilityRequest(
                capabilityType: .deepThinking,
                input: .text("企业数字化转型策略")
            )
            
            let response = try await manager.execute(request: request, for: "business_a")
            
            if case .text(let result) = response.output {
                print("      ✅ 选择插件: \(response.metadata["selected_plugin"] ?? "未知")")
                print("      🏷️ 品牌标识: \(response.metadata["brand"] ?? "未知")")
                print("      📝 分析结果: \(result.prefix(150))...")
            }
            
        } catch {
            print("      ❌ 执行失败: \(error.localizedDescription)")
        }
        
        // 演示业务方B的插件选择
        print("   🏢 业务方B深度思考请求:")
        do {
            let request = AICapabilityRequest(
                capabilityType: .deepThinking,
                input: .text("技术架构优化方案")
            )
            
            let response = try await manager.execute(request: request, for: "business_b")
            
            if case .text(let result) = response.output {
                print("      ✅ 选择插件: \(response.metadata["selected_plugin"] ?? "未知")")
                print("      📚 知识库连接: \(response.metadata["knowledge_base_connected"] ?? false)")
                print("      📝 分析结果: \(result.prefix(150))...")
            }
            
        } catch {
            print("      ❌ 执行失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 具体功能演示
    
    private func demonstrateChatDialogue(businessId: String, message: String) async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .chatDialogue,
                input: .text(message)
            )
            
            let response = try await manager.execute(request: request, for: businessId)
            
            if case .text(let result) = response.output {
                print("   💬 用户消息: \(message)")
                print("   🤖 AI回复: \(result.prefix(200))...")
                print("   ⏱️ 响应时间: \(response.metadata["response_time"] ?? "未知")")
            }
            
        } catch {
            print("   ❌ 聊天对话失败: \(error.localizedDescription)")
        }
    }
    
    private func demonstrateWebSearch(businessId: String, query: String) async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .webSearch,
                input: .text(query)
            )
            
            let response = try await manager.execute(request: request, for: businessId)
            
            if case .text(let result) = response.output {
                print("   🔍 搜索查询: \(query)")
                print("   📊 搜索结果: \(result.prefix(200))...")
                print("   🔗 数据源: \(response.metadata["data_source"] ?? "实时网络")")
            }
            
        } catch {
            print("   ❌ 网络搜索失败: \(error.localizedDescription)")
        }
    }
    
    private func demonstrateDocumentAnalysis(businessId: String, document: String) async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .documentAnalysis,
                input: .text(document)
            )
            
            let response = try await manager.execute(request: request, for: businessId)
            
            if case .text(let result) = response.output {
                print("   📄 文档内容: \(document.prefix(100))...")
                print("   📊 分析结果: \(result.prefix(200))...")
                print("   📈 分析质量: \(response.metadata["analysis_quality"] ?? "标准")")
            }
            
        } catch {
            print("   ❌ 文档分析失败: \(error.localizedDescription)")
        }
    }
    
    private func demonstrateDeepThinking(businessId: String, topic: String) async {
        do {
            let request = AICapabilityRequest(
                capabilityType: .deepThinking,
                input: .text(topic)
            )
            
            let response = try await manager.execute(request: request, for: businessId)
            
            if case .text(let result) = response.output {
                print("   🤔 思考主题: \(topic)")
                print("   🧠 深度分析: \(result.prefix(300))...")
                
                // 显示业务方特定的元数据
                if let brand = response.metadata["brand"] as? String {
                    print("   🏷️ 品牌标识: \(brand)")
                }
                if let knowledgeBaseConnected = response.metadata["knowledge_base_connected"] as? Bool, knowledgeBaseConnected {
                    print("   📚 知识库已连接")
                }
                if let brandLogoIncluded = response.metadata["brand_logo_included"] as? Bool, brandLogoIncluded {
                    print("   🏢 品牌logo已包含")
                }
            }
            
        } catch {
            print("   ❌ 深度思考失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 总结
    
    private func showChatSummary() {
        print("\n📊 即时通信场景总结")
        print("=" * 40)
        
        let stats = manager.getPluginStatistics()
        print("📈 插件统计:")
        print("   • 总插件数: \(stats["total_plugins"] ?? 0)")
        print("   • 支持能力数: \(stats["supported_capabilities"] ?? 0)")
        print("   • 覆盖率: \(String(format: "%.1f", (stats["coverage_rate"] as? Double ?? 0) * 100))%")
        print("   • 注册业务方: \(stats["registered_businesses"] ?? 0)")
        
        print("\n🎯 业务方功能对比:")
        print("   📱 业务方A (企业级智能客服):")
        print("      • 基础功能: 聊天对话")
        print("      • 特殊功能: 网络搜索、深度思考(带品牌logo)")
        print("      • 定制特色: 品牌化深度思考分析")
        print("      • 业务价值: 提升客户服务质量和品牌形象")
        
        print("\n   🏢 业务方B (技术团队协作):")
        print("      • 基础功能: 聊天对话")
        print("      • 特殊功能: 文档分析、深度思考(连接知识库)")
        print("      • 定制特色: 知识库增强的深度思考")
        print("      • 业务价值: 提高技术团队工作效率")
        
        print("\n🔧 技术亮点:")
        print("   • 业务方专用插件协议 (BusinessSpecificPlugin)")
        print("   • 智能插件选择机制 (selectPluginForBusiness)")
        print("   • 能力复用与定制化并存")
        print("   • 动态配置和参数传递")
        print("   • 完整的错误处理和日志记录")
        
        print("\n💡 架构优势:")
        print("   • 完全解耦: 不同业务方的定制需求完全独立")
        print("   • 易于扩展: 新增业务方只需实现专用插件")
        print("   • 配置灵活: 支持业务方特定的参数配置")
        print("   • 高复用性: 基础功能在多个业务方间完全复用")
        
        print("\n✅ 演示完成 - 插件化架构成功支持不同业务方的定制需求")
        print("   通过清晰的协议设计和智能的插件选择机制，")
        print("   实现了高度可扩展和可维护的即时通信系统架构。")
    }
} 