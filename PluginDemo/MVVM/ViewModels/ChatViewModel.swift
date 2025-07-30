//
//  ChatViewModel.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation
import Combine

// MARK: - Chat ViewModel 协议

/// Chat ViewModel 协议
@preconcurrency
protocol ChatViewModelProtocol: ObservableObject {
    var messages: [ChatMessage] { get }
    var isLoading: Bool { get }
    var currentConfiguration: ChatConfiguration? { get }
    var availableCapabilities: [ChatCapability] { get }
    var thinkingChain: ThinkingChain? { get }
    var knowledgeSearchResult: KnowledgeSearchResult? { get }
    var showThinkingChain: Bool { get set }
    var showKnowledgeSearch: Bool { get set }
    
    func sendMessage(_ message: String) async throws
    func getConversationHistory() -> [ChatMessage]
    func clearHistory()
    func updateConfiguration(_ config: ChatConfiguration)
    func switchBusiness(_ businessId: String)
    func getMockDataProvider() -> ChatMockDataProvider
    func toggleThinkingChain()
    func toggleKnowledgeSearch()
    func generateThinkingChain(for message: String) async throws
    func searchCustomKnowledgeBase(query: String) async throws
}

// MARK: - Chat Mock数据提供者协议

/// Chat Mock数据提供者协议
protocol ChatMockDataProvider {
    func getMockResponse(for capability: ChatCapability, 
                        message: String, 
                        businessId: String) -> ChatResponse
    func getMockConversationHistory(businessId: String) -> [ChatMessage]
    func getMockCapabilities(businessId: String) -> [ChatCapability]
}

// MARK: - 业务方A Mock数据提供者

/// 业务方A - 智能客服Mock数据提供者
class BusinessACustomerServiceMockProvider: ChatMockDataProvider {
    
    func getMockResponse(for capability: ChatCapability, message: String, businessId: String) -> ChatResponse {
        let lowerMessage = message.lowercased()
        
        switch capability {
        case .deepThinking:
            return ChatResponse(
                message: generateDeepThinkingResponse(for: lowerMessage),
                capabilities: [.deepThinking],
                metadata: [
                    "business_type": "customer_service",
                    "ui_theme": "customer_friendly",
                    "button_style": "rounded_gradient",
                    "animation_type": "bounce",
                    "response_style": "friendly_and_helpful"
                ],
                processingTime: 1.2,
                confidence: 0.95
            )
        case .webSearch:
            return ChatResponse(
                message: generateWebSearchResponse(for: lowerMessage),
                capabilities: [.webSearch],
                metadata: [
                    "business_type": "customer_service",
                    "search_results": 5,
                    "search_time": 0.8
                ],
                processingTime: 0.8,
                confidence: 0.9
            )
        case .knowledgeBase:
            return ChatResponse(
                message: generateKnowledgeBaseResponse(for: lowerMessage),
                capabilities: [.knowledgeBase],
                metadata: [
                    "business_type": "customer_service",
                    "kb_articles": 3,
                    "relevance_score": 0.92
                ],
                processingTime: 0.6,
                confidence: 0.88
            )
        default:
            return ChatResponse(
                message: "BusinessA智能客服为您服务！",
                capabilities: [capability],
                metadata: ["business_type": "customer_service"],
                processingTime: 0.5,
                confidence: 0.8
            )
        }
    }
    
    func getMockConversationHistory(businessId: String) -> [ChatMessage] {
        return [
            ChatMessage(content: "您好，我想了解一下你们的产品功能", sender: .user),
            ChatMessage(content: "🏢 BusinessA 智能客服为您服务！\n\n关于产品功能的问题，我来为您详细解答：\n\n✨ 我们的产品具有以下特色功能：\n• 智能对话：24/7全天候服务\n• 快速响应：平均响应时间1.2秒\n• 个性化推荐：基于您的需求定制\n• 多语言支持：支持多种语言交流\n\n🎯 如果您需要更详细的产品介绍，我可以为您安排专业的产品顾问。\n\n💡 温馨提示：您也可以访问我们的官网了解更多产品信息。\n\n🏢 BusinessA - 您的贴心智能助手", sender: .assistant),
            ChatMessage(content: "价格是多少呢？", sender: .user),
            ChatMessage(content: "💰 价格咨询 - BusinessA智能客服\n\n感谢您对我们产品的关注！关于价格信息：\n\n📊 我们的定价策略：\n• 基础版：免费使用，包含核心功能\n• 专业版：$29/月，包含高级功能\n• 企业版：定制价格，专属服务\n\n🎁 新用户优惠：\n• 首月免费试用\n• 推荐好友获得额外优惠\n• 年付享受8折优惠\n\n📞 如需详细报价，我可以为您转接销售专员。\n\n💰 BusinessA - 性价比之选", sender: .assistant)
        ]
    }
    
    func getMockCapabilities(businessId: String) -> [ChatCapability] {
        return [
            .deepThinking,
            .webSearch,
            .knowledgeBase,
            .smartSummary,
            .conversationHistory,
            .emotionAnalysis,
            .intentRecognition
        ]
    }
    
    private func generateDeepThinkingResponse(for message: String) -> String {
        if message.contains("产品") || message.contains("功能") {
            return """
            🤔 BusinessA 深度思考分析：
            
            基于您对产品功能的询问，我进行了深度分析：
            
            📊 产品功能分析：
            • 核心价值：解决用户实际问题
            • 差异化优势：24/7智能服务
            • 用户体验：快速响应，友好交互
            • 技术优势：AI驱动，持续学习
            
            🎯 推荐策略：
            • 重点展示核心功能
            • 提供免费试用体验
            • 个性化功能推荐
            • 持续优化用户体验
            
            💡 深度洞察：用户更关注实际价值而非技术细节
            
            🏢 BusinessA - 深度思考，精准服务
            """
        } else {
            return """
            🤔 BusinessA 深度思考分析：
            
            我正在深入分析您的问题...
            
            📈 分析维度：
            • 用户需求理解
            • 解决方案匹配
            • 价值创造机会
            • 服务优化方向
            
            🎯 思考结果：为您提供最合适的解决方案
            
            🏢 BusinessA - 智能思考，贴心服务
            """
        }
    }
    
    private func generateWebSearchResponse(for message: String) -> String {
        return """
        🌐 BusinessA 联网搜索结果：
        
        为您搜索到以下相关信息：
        
        📰 最新资讯：
        • AI客服市场增长30%
        • 用户体验成为竞争关键
        • 智能化服务趋势明显
        
        📊 市场数据：
        • 客户满意度提升25%
        • 响应时间缩短50%
        • 服务成本降低40%
        
        🔍 搜索结果：5条相关资讯，相关性评分：92%
        
        🌐 BusinessA - 实时信息，精准服务
        """
    }
    
    private func generateKnowledgeBaseResponse(for message: String) -> String {
        return """
        📚 BusinessA 知识库检索结果：
        
        从我们的知识库中找到以下相关内容：
        
        📖 相关文档：
        1. 《产品功能使用指南》- 匹配度：95%
        2. 《常见问题解答》- 匹配度：88%
        3. 《最佳实践案例》- 匹配度：85%
        
        💡 知识要点：
        • 产品核心功能详解
        • 使用技巧和窍门
        • 故障排除方法
        • 高级功能介绍
        
        📚 知识库检索：3篇相关文档，平均匹配度：89%
        
        📚 BusinessA - 知识驱动，专业服务
        """
    }
}

// MARK: - 业务方B Mock数据提供者

/// 业务方B - 企业级Mock数据提供者
class BusinessBEnterpriseMockProvider: ChatMockDataProvider {
    
    func getMockResponse(for capability: ChatCapability, message: String, businessId: String) -> ChatResponse {
        let lowerMessage = message.lowercased()
        
        switch capability {
        case .deepThinking:
            return ChatResponse(
                message: generateEnterpriseDeepThinkingResponse(for: lowerMessage),
                capabilities: [.deepThinking],
                metadata: [
                    "business_type": "enterprise",
                    "ui_theme": "enterprise_professional",
                    "button_style": "sharp_corporate",
                    "animation_type": "fade",
                    "response_style": "professional_and_analytical",
                    "security_level": "enterprise",
                    "compliance_status": "verified"
                ],
                processingTime: 2.8,
                confidence: 0.98
            )
        case .knowledgeBase:
            return ChatResponse(
                message: generateEnterpriseKnowledgeBaseResponse(for: lowerMessage),
                capabilities: [.knowledgeBase],
                metadata: [
                    "business_type": "enterprise",
                    "kb_articles": 8,
                    "relevance_score": 0.96,
                    "security_level": "enterprise"
                ],
                processingTime: 1.5,
                confidence: 0.95
            )
        case .smartSummary:
            return ChatResponse(
                message: generateEnterpriseSmartSummaryResponse(for: lowerMessage),
                capabilities: [.smartSummary],
                metadata: [
                    "business_type": "enterprise",
                    "summary_length": "comprehensive",
                    "key_points": 5
                ],
                processingTime: 1.8,
                confidence: 0.94
            )
        case .thinkingChain:
            return ChatResponse(
                message: generateEnterpriseThinkingChainResponse(for: lowerMessage),
                capabilities: [.thinkingChain],
                metadata: [
                    "business_type": "enterprise",
                    "thinking_steps": 5,
                    "confidence_level": "high",
                    "security_level": "enterprise"
                ],
                processingTime: 3.2,
                confidence: 0.97
            )
        case .customKnowledgeBase:
            return ChatResponse(
                message: generateEnterpriseCustomKnowledgeBaseResponse(for: lowerMessage),
                capabilities: [.customKnowledgeBase],
                metadata: [
                    "business_type": "enterprise",
                    "kb_documents": 12,
                    "relevance_score": 0.94,
                    "security_level": "enterprise",
                    "custom_kb": true
                ],
                processingTime: 1.6,
                confidence: 0.93
            )
        default:
            return ChatResponse(
                message: "BusinessB企业级智能助手为您服务！",
                capabilities: [capability],
                metadata: [
                    "business_type": "enterprise",
                    "security_level": "enterprise"
                ],
                processingTime: 1.0,
                confidence: 0.9
            )
        }
    }
    
    func getMockConversationHistory(businessId: String) -> [ChatMessage] {
        return [
            ChatMessage(content: "我们需要设计一个高可用的微服务架构", sender: .user),
            ChatMessage(content: "🏢 BusinessB 企业级技术咨询\n\n关于系统架构设计，我为您提供专业分析：\n\n📋 架构设计评估报告：\n\n1. 技术架构分析\n   • 微服务架构：推荐采用Spring Cloud + Docker\n   • 数据存储：建议使用分布式数据库集群\n   • 缓存策略：Redis集群 + 多级缓存\n   • 消息队列：Kafka确保高吞吐量\n\n2. 安全架构设计\n   • 身份认证：OAuth 2.0 + JWT\n   • 数据加密：AES-256 + TLS 1.3\n   • 访问控制：RBAC权限模型\n   • 审计日志：完整的操作追踪\n\n3. 性能优化建议\n   • 负载均衡：Nginx + HAProxy\n   • 数据库优化：读写分离 + 分库分表\n   • 缓存优化：多级缓存策略\n   • 监控告警：Prometheus + Grafana\n\n4. 合规性要求\n   • 数据保护：GDPR合规\n   • 安全标准：ISO 27001认证\n   • 行业规范：符合金融级安全要求\n\n📊 风险评估：\n• 技术风险：中等（可控）\n• 安全风险：低（已考虑）\n• 合规风险：低（符合标准）\n\n💼 BusinessB - 企业级技术解决方案", sender: .assistant),
            ChatMessage(content: "安全方面有什么具体建议？", sender: .user),
            ChatMessage(content: "🔒 企业安全与合规咨询 - BusinessB\n\n企业级安全与合规解决方案：\n\n🛡️ 安全架构设计：\n\n1. 网络安全\n   • 防火墙：下一代防火墙(NGFW)\n   • VPN：企业级VPN解决方案\n   • DDoS防护：多层防护机制\n   • 入侵检测：IDS/IPS系统\n\n2. 数据安全\n   • 数据分类：敏感数据识别\n   • 加密存储：端到端加密\n   • 数据备份：异地容灾备份\n   • 数据销毁：安全删除机制\n\n3. 访问控制\n   • 身份管理：IAM统一身份认证\n   • 权限控制：最小权限原则\n   • 多因素认证：MFA强制启用\n   • 会话管理：安全会话控制\n\n4. 合规要求\n   • 数据保护：GDPR、CCPA合规\n   • 行业标准：SOX、PCI DSS\n   • 安全认证：ISO 27001、SOC 2\n   • 审计要求：定期安全审计\n\n📈 安全指标：\n• 安全事件响应时间：< 15分钟\n• 数据泄露风险：< 0.01%\n• 合规检查通过率：100%\n• 安全培训覆盖率：100%\n\n🔒 BusinessB - 企业级安全保障", sender: .assistant)
        ]
    }
    
    func getMockCapabilities(businessId: String) -> [ChatCapability] {
        return [
            .deepThinking,
            .knowledgeBase,
            .smartSummary,
            .conversationHistory,
            .emotionAnalysis,
            .intentRecognition,
            .contextMemory,
            .thinkingChain,
            .customKnowledgeBase
        ]
    }
    
    private func generateEnterpriseDeepThinkingResponse(for message: String) -> String {
        if message.contains("架构") || message.contains("设计") {
            return """
            🧠 BusinessB 企业级深度思考分析：
            
            基于您的架构设计需求，我进行了全面的深度分析：
            
            📊 架构设计深度分析：
            
            1. 技术选型分析
               • 微服务框架：Spring Cloud vs Kubernetes
               • 数据存储：分布式数据库 vs 云原生数据库
               • 消息队列：Kafka vs RabbitMQ vs Pulsar
               • 监控体系：Prometheus + Grafana vs ELK Stack
            
            2. 风险与挑战评估
               • 技术债务：现有系统迁移风险
               • 团队技能：新技术栈学习成本
               • 运维复杂度：分布式系统管理挑战
               • 成本控制：云原生架构成本优化
            
            3. 成功因素分析
               • 渐进式迁移：降低风险
               • 团队培训：提升技能
               • 自动化运维：减少复杂度
               • 成本监控：优化资源使用
            
            4. 实施路线图
               • 第一阶段：核心服务微服务化
               • 第二阶段：数据层分布式改造
               • 第三阶段：监控和运维体系完善
               • 第四阶段：性能优化和安全加固
            
            📈 深度洞察：
            • 技术选型需要平衡性能和复杂度
            • 团队能力是成功的关键因素
            • 渐进式迁移降低风险
            • 自动化是运维效率的保障
            
            💼 BusinessB - 深度思考，专业决策
            """
        } else {
            return """
            🧠 BusinessB 企业级深度思考分析：
            
            我正在对企业级需求进行深度分析...
            
            📋 分析框架：
            • 业务价值评估
            • 技术可行性分析
            • 风险评估与控制
            • 实施策略规划
            
            🎯 深度思考结果：为您提供最专业的企业级解决方案
            
            💼 BusinessB - 专业思考，权威决策
            """
        }
    }
    
    private func generateEnterpriseKnowledgeBaseResponse(for message: String) -> String {
        return """
        📚 BusinessB 企业级知识库检索：
        
        从企业级知识库中检索到以下专业内容：
        
        📖 技术文档：
        1. 《微服务架构设计最佳实践》- 匹配度：98%
        2. 《企业级安全架构指南》- 匹配度：95%
        3. 《分布式系统设计模式》- 匹配度：93%
        4. 《云原生架构实施指南》- 匹配度：91%
        5. 《企业级性能优化策略》- 匹配度：89%
        
        🔍 专业资源：
        • 技术白皮书：15篇
        • 案例分析：8个
        • 最佳实践：12项
        • 风险评估：6份
        
        📊 知识库统计：
        • 检索文档：8篇
        • 平均匹配度：96%
        • 专业级别：企业级
        • 安全认证：已通过
        
        📚 BusinessB - 专业知识，权威指导
        """
    }
    
    private func generateEnterpriseSmartSummaryResponse(for message: String) -> String {
        return """
        📋 BusinessB 企业级智能总结：
        
        基于我们的对话内容，为您生成专业总结：
        
        🎯 核心要点：
        
        1. 架构设计需求
           • 高可用微服务架构
           • 企业级安全要求
           • 性能优化需求
           • 合规性保障
        
        2. 技术方案建议
           • Spring Cloud + Docker 微服务框架
           • 分布式数据库集群
           • Redis + Kafka 缓存和消息
           • OAuth 2.0 + JWT 安全认证
        
        3. 实施建议
           • 渐进式迁移策略
           • 团队技能培训
           • 自动化运维体系
           • 持续监控和优化
        
        4. 风险控制
           • 技术风险评估
           • 安全合规保障
           • 成本控制策略
           • 质量保证体系
        
        📈 总结统计：
        • 关键决策点：5个
        • 技术选型：4项
        • 风险控制：3个维度
        • 实施阶段：4个阶段
        
        📋 BusinessB - 智能总结，专业决策支持
        """
    }
    
    private func generateEnterpriseThinkingChainResponse(for message: String) -> String {
        return """
        🧠 BusinessB 企业级思考链路分析：
        
        基于您的问题，我进行了深度思考分析：
        
        🔍 思考步骤：
        
        步骤1 - 问题分析：
        • 识别核心问题：\(message)
        • 确定问题类型：企业级技术咨询
        • 评估复杂度：高复杂度问题
        
        步骤2 - 信息收集：
        • 技术背景调研
        • 行业最佳实践分析
        • 风险评估框架
        
        步骤3 - 方案设计：
        • 多方案对比分析
        • 技术可行性评估
        • 成本效益分析
        
        步骤4 - 风险评估：
        • 技术风险识别
        • 安全合规检查
        • 实施风险评估
        
        步骤5 - 结论形成：
        • 推荐方案确定
        • 实施路径规划
        • 成功指标定义
        
        📊 思考链路统计：
        • 分析步骤：5个
        • 处理时间：3.2秒
        • 置信度：97%
        • 安全等级：企业级
        
        🧠 BusinessB - 深度思考，专业决策
        """
    }
    
    private func generateEnterpriseCustomKnowledgeBaseResponse(for message: String) -> String {
        return """
        📚 BusinessB 企业自定义知识库检索：
        
        基于您的查询，我从企业知识库中检索到以下信息：
        
        🔍 检索结果：
        
        文档1 - 企业架构设计指南
        • 标题：微服务架构最佳实践
        • 相关性：94%
        • 内容：包含Spring Cloud、Docker、Kubernetes等企业级技术栈
        
        文档2 - 安全合规标准
        • 标题：企业级安全架构设计
        • 相关性：92%
        • 内容：OAuth 2.0、JWT、RBAC等安全机制
        
        文档3 - 性能优化手册
        • 标题：高可用系统性能优化
        • 相关性：89%
        • 内容：负载均衡、缓存策略、数据库优化
        
        文档4 - 合规性要求
        • 标题：企业合规性检查清单
        • 相关性：87%
        • 内容：GDPR、SOX、ISO 27001等合规要求
        
        📊 知识库检索统计：
        • 检索文档：12篇
        • 平均相关性：94%
        • 检索时间：1.6秒
        • 知识库类型：企业自定义
        
        📚 BusinessB - 知识驱动，专业服务
        """
    }
}

// MARK: - Chat ViewModel 实现

/// Chat ViewModel 主实现
@MainActor
@preconcurrency
final class ChatViewModel: ChatViewModelProtocol {
    
    // MARK: - Published Properties
    
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var currentConfiguration: ChatConfiguration?
    @Published var availableCapabilities: [ChatCapability] = []
    @Published var thinkingChain: ThinkingChain?
    @Published var knowledgeSearchResult: KnowledgeSearchResult?
    @Published var showThinkingChain: Bool = false
    @Published var showKnowledgeSearch: Bool = false
    
    // MARK: - Private Properties
    
    private let orchestrator = ChatCapabilityOrchestrator()
    private var mockDataProvider: ChatMockDataProvider
    private var currentBusinessId: String = "business_a"
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(businessId: String = "business_a") {
        self.currentBusinessId = businessId
        self.mockDataProvider = BusinessACustomerServiceMockProvider()
        setupInitialState()
    }
    
    // MARK: - Public Methods
    
    func sendMessage(_ message: String) async throws {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        
        // 添加用户消息
        let userMessage = ChatMessage(content: message, sender: .user)
        messages.append(userMessage)
        
        do {
            // 使用Mock数据或真实插件处理
            let response = try await processMessage(message)
            
            // 添加助手回复
            let assistantMessage = ChatMessage(
                content: response.message,
                sender: .assistant,
                metadata: [
                    "capabilities": response.capabilities.map { $0.rawValue },
                    "processing_time": response.processingTime,
                    "confidence": response.confidence
                ]
            )
            messages.append(assistantMessage)
            
        } catch {
            // 添加错误消息
            let errorMessage = ChatMessage(
                content: "抱歉，处理您的消息时出现了错误：\(error.localizedDescription)",
                sender: .assistant,
                metadata: ["error": true]
            )
            messages.append(errorMessage)
        }
        
        isLoading = false
    }
    
    func getConversationHistory() -> [ChatMessage] {
        return messages
    }
    
    func clearHistory() {
        DispatchQueue.main.async {
            self.messages.removeAll()
        }
    }
    
    func updateConfiguration(_ config: ChatConfiguration) {
        print("🔄 更新配置: \(config.businessName) (\(config.businessId))")
        DispatchQueue.main.async {
            print("✅ 在主线程更新配置: \(config.businessName)")
            self.currentConfiguration = config
            self.availableCapabilities = config.enabledCapabilities
            // 立即发送UI更新通知
            self.objectWillChange.send()
        }
    }
    
    func switchBusiness(_ businessId: String) {
        print("🔄 开始切换业务: \(businessId)")
        currentBusinessId = businessId
        
        // 切换Mock数据提供者
        switch businessId {
        case "business_a":
            mockDataProvider = BusinessACustomerServiceMockProvider()
            print("✅ 切换到BusinessA Mock数据提供者")
        case "business_b":
            mockDataProvider = BusinessBEnterpriseMockProvider()
            print("✅ 切换到BusinessB Mock数据提供者")
        default:
            mockDataProvider = BusinessACustomerServiceMockProvider()
            print("⚠️ 使用默认Mock数据提供者")
        }
        
        // 更新配置（这会自动触发UI更新）
        updateConfigurationForBusiness(businessId)
        
        // 清空历史消息
        clearHistory()
        
        // 加载历史对话
        loadConversationHistory()
    }
    
    func getMockDataProvider() -> ChatMockDataProvider {
        return mockDataProvider
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        updateConfigurationForBusiness(currentBusinessId)
        loadConversationHistory()
    }
    
    private func updateConfigurationForBusiness(_ businessId: String) {
        switch businessId {
        case "business_a":
            let config = ChatConfiguration(
                businessId: "business_a",
                businessName: "BusinessA智能客服",
                enabledCapabilities: [
                    .deepThinking,
                    .webSearch,
                    .knowledgeBase,
                    .smartSummary,
                    .conversationHistory,
                    .emotionAnalysis,
                    .intentRecognition
                ],
                capabilityOrder: [
                    .intentRecognition,
                    .knowledgeBase,
                    .deepThinking
                ],
                mockDataEnabled: true,
                responseDelay: 1.2,
                uiCustomization: ChatUICustomization(
                    theme: "customer_friendly",
                    buttonStyle: "rounded_gradient",
                    animationType: "bounce",
                    colorScheme: [
                        "primary": "#FF6B35",
                        "secondary": "#F7931E",
                        "background": "#FFFFFF",
                        "text": "#333333"
                    ],
                    fontFamily: "Friendly",
                    borderRadius: 20.0,
                    shadowEnabled: true
                ),
                logicCustomization: ChatLogicCustomization(
                    responseStrategy: "quick_response",
                    fallbackEnabled: true,
                    retryCount: 2,
                    timeoutInterval: 15.0,
                    priorityCapabilities: [.intentRecognition, .knowledgeBase, .deepThinking],
                    customLogic: [
                        "auto_escalation": true,
                        "sentiment_aware": true,
                        "quick_resolution": true
                    ]
                )
            )
            updateConfiguration(config)
            
        case "business_b":
            let config = ChatConfiguration(
                businessId: "business_b",
                businessName: "BusinessB企业级助手",
                enabledCapabilities: [
                    .deepThinking,
                    .knowledgeBase,
                    .smartSummary,
                    .conversationHistory,
                    .emotionAnalysis,
                    .intentRecognition,
                    .contextMemory,
                    .thinkingChain,
                    .customKnowledgeBase
                ],
                capabilityOrder: [
                    .intentRecognition,
                    .knowledgeBase,
                    .deepThinking,
                    .contextMemory
                ],
                mockDataEnabled: true,
                responseDelay: 2.8,
                uiCustomization: ChatUICustomization(
                    theme: "enterprise_professional",
                    buttonStyle: "sharp_corporate",
                    animationType: "fade",
                    colorScheme: [
                        "primary": "#2C3E50",
                        "secondary": "#34495E",
                        "background": "#ECF0F1",
                        "text": "#2C3E50"
                    ],
                    fontFamily: "Professional",
                    borderRadius: 4.0,
                    shadowEnabled: false
                ),
                logicCustomization: ChatLogicCustomization(
                    responseStrategy: "deep_analysis",
                    fallbackEnabled: true,
                    retryCount: 3,
                    timeoutInterval: 30.0,
                    priorityCapabilities: [.intentRecognition, .knowledgeBase, .deepThinking, .contextMemory],
                    customLogic: [
                        "security_audit": true,
                        "compliance_check": true,
                        "detailed_analysis": true,
                        "enterprise_features": true
                    ]
                )
            )
            updateConfiguration(config)
            
        default:
            break
        }
    }
    
    private func loadConversationHistory() {
        DispatchQueue.main.async {
            self.messages = self.mockDataProvider.getMockConversationHistory(businessId: self.currentBusinessId)
        }
    }
    
    private func processMessage(_ message: String) async throws -> ChatResponse {
        guard let config = currentConfiguration else {
            throw ChatError.invalidConfiguration("未找到Chat配置")
        }
        
        // 使用Mock数据
        if config.mockDataEnabled {
            // 根据配置的能力顺序处理
            let primaryCapability = config.capabilityOrder.first ?? .deepThinking
            return mockDataProvider.getMockResponse(for: primaryCapability, message: message, businessId: currentBusinessId)
        } else {
            // 使用真实插件处理
            let context = ChatContext(businessId: currentBusinessId, userId: "user_123")
            return try await orchestrator.orchestrateCapabilities(
                config.capabilityOrder,
                message: message,
                context: context
            )
        }
    }
    
    // MARK: - 思考链路功能
    
    func toggleThinkingChain() {
        showThinkingChain.toggle()
        if !showThinkingChain {
            thinkingChain = nil
        }
    }
    
    func generateThinkingChain(for message: String) async throws {
        isLoading = true
        
        // 模拟生成思考链路
        let steps = [
            ThinkingStep(stepNumber: 1, thinkingType: .analysis, content: "分析用户问题：\(message)", confidence: 0.95, reasoning: "识别问题类型和复杂度"),
            ThinkingStep(stepNumber: 2, thinkingType: .reasoning, content: "收集相关信息", confidence: 0.92, reasoning: "从知识库和上下文获取相关信息"),
            ThinkingStep(stepNumber: 3, thinkingType: .evaluation, content: "评估解决方案", confidence: 0.89, reasoning: "对比不同方案的优缺点"),
            ThinkingStep(stepNumber: 4, thinkingType: .synthesis, content: "综合最佳方案", confidence: 0.94, reasoning: "整合信息形成推荐方案"),
            ThinkingStep(stepNumber: 5, thinkingType: .conclusion, content: "形成最终结论", confidence: 0.97, reasoning: "基于分析提供专业建议")
        ]
        
        let chain = ThinkingChain(
            question: message,
            steps: steps,
            conclusion: "基于深度分析，为您提供专业的企业级解决方案",
            processingTime: 3.2
        )
        
        thinkingChain = chain
        isLoading = false
    }
    
    // MARK: - 自定义知识库功能
    
    func toggleKnowledgeSearch() {
        showKnowledgeSearch.toggle()
        if !showKnowledgeSearch {
            knowledgeSearchResult = nil
        }
    }
    
    func searchCustomKnowledgeBase(query: String) async throws {
        isLoading = true
        
        // 模拟知识库检索
        let documents = [
            KnowledgeDocument(
                title: "企业微服务架构设计指南",
                content: "包含Spring Cloud、Docker、Kubernetes等企业级技术栈的最佳实践",
                category: "架构设计",
                tags: ["微服务", "Spring Cloud", "Docker"],
                relevanceScore: 0.94,
                source: "企业知识库"
            ),
            KnowledgeDocument(
                title: "企业级安全架构设计",
                content: "OAuth 2.0、JWT、RBAC等安全机制的详细实现方案",
                category: "安全合规",
                tags: ["安全", "OAuth", "JWT"],
                relevanceScore: 0.92,
                source: "企业知识库"
            ),
            KnowledgeDocument(
                title: "高可用系统性能优化",
                content: "负载均衡、缓存策略、数据库优化等性能提升方案",
                category: "性能优化",
                tags: ["性能", "负载均衡", "缓存"],
                relevanceScore: 0.89,
                source: "企业知识库"
            ),
            KnowledgeDocument(
                title: "企业合规性检查清单",
                content: "GDPR、SOX、ISO 27001等合规要求的详细检查项",
                category: "合规管理",
                tags: ["合规", "GDPR", "SOX"],
                relevanceScore: 0.87,
                source: "企业知识库"
            )
        ]
        
        let result = KnowledgeSearchResult(
            query: query,
            documents: documents,
            searchTime: 1.6
        )
        
        knowledgeSearchResult = result
        isLoading = false
    }
}
