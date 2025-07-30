//
//  ChatCapabilityProtocol.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

// MARK: - Chat能力枚举

/// Chat模块支持的能力类型
enum ChatCapability: String, CaseIterable, Codable {
    case deepThinking = "深度思考"
    case webSearch = "联网搜索"
    case knowledgeBase = "知识库检索"
    case smartSummary = "智能总结"
    case conversationHistory = "对话历史"
    case emotionAnalysis = "情感分析"
    case intentRecognition = "意图识别"
    case contextMemory = "上下文记忆"
    case thinkingChain = "思考链路"
    case customKnowledgeBase = "自定义知识库"
    
    var displayName: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .deepThinking:
            return "提供深度分析和思考能力"
        case .webSearch:
            return "实时联网搜索最新信息"
        case .knowledgeBase:
            return "检索内部知识库内容"
        case .smartSummary:
            return "智能总结对话内容"
        case .conversationHistory:
            return "管理对话历史记录"
        case .emotionAnalysis:
            return "分析用户情感状态"
        case .intentRecognition:
            return "识别用户意图"
        case .contextMemory:
            return "保持对话上下文记忆"
        case .thinkingChain:
            return "展示AI思考链路和推理过程"
        case .customKnowledgeBase:
            return "使用企业自定义知识库进行内容检索"
        }
    }
}

// MARK: - Chat数据结构

/// Chat消息结构
struct ChatMessage: Codable {
    let id: String
    let content: String
    let sender: MessageSender
    let timestamp: Date
    let metadata: [String: String]
    
    enum MessageSender: String, Codable {
        case user = "user"
        case assistant = "assistant"
        case system = "system"
    }
    
    init(content: String, sender: MessageSender, metadata: [String: Any] = [:]) {
        self.id = UUID().uuidString
        self.content = content
        self.sender = sender
        self.timestamp = Date()
        self.metadata = metadata.mapValues { String(describing: $0) }
    }
}

/// Chat响应结构
struct ChatResponse: Codable {
    let message: String
    let capabilities: [ChatCapability]
    let metadata: [String: String]
    let processingTime: TimeInterval
    let confidence: Double
    
    init(message: String, capabilities: [ChatCapability] = [], metadata: [String: Any] = [:], processingTime: TimeInterval = 0.0, confidence: Double = 1.0) {
        self.message = message
        self.capabilities = capabilities
        self.metadata = metadata.mapValues { String(describing: $0) }
        self.processingTime = processingTime
        self.confidence = confidence
    }
}

/// Chat上下文结构
struct ChatContext: Codable {
    let conversationId: String
    let businessId: String
    let userId: String
    let sessionStartTime: Date
    let messageHistory: [ChatMessage]
    let userPreferences: [String: String]
    let systemConfig: [String: String]
    
    init(businessId: String, userId: String, userPreferences: [String: Any] = [:], systemConfig: [String: Any] = [:]) {
        self.conversationId = UUID().uuidString
        self.businessId = businessId
        self.userId = userId
        self.sessionStartTime = Date()
        self.messageHistory = []
        self.userPreferences = userPreferences.mapValues { String(describing: $0) }
        self.systemConfig = systemConfig.mapValues { String(describing: $0) }
    }
}

// MARK: - Chat配置结构

/// Chat模块配置
struct ChatConfiguration: Codable {
    let businessId: String
    let businessName: String
    let enabledCapabilities: [ChatCapability]
    let capabilityOrder: [ChatCapability]  // 能力执行顺序
    let mockDataEnabled: Bool
    let responseDelay: TimeInterval
    let uiCustomization: ChatUICustomization
    let logicCustomization: ChatLogicCustomization
    
    init(businessId: String, businessName: String, enabledCapabilities: [ChatCapability], capabilityOrder: [ChatCapability] = [], mockDataEnabled: Bool = true, responseDelay: TimeInterval = 1.0, uiCustomization: ChatUICustomization = ChatUICustomization(), logicCustomization: ChatLogicCustomization = ChatLogicCustomization()) {
        self.businessId = businessId
        self.businessName = businessName
        self.enabledCapabilities = enabledCapabilities
        self.capabilityOrder = capabilityOrder.isEmpty ? enabledCapabilities : capabilityOrder
        self.mockDataEnabled = mockDataEnabled
        self.responseDelay = responseDelay
        self.uiCustomization = uiCustomization
        self.logicCustomization = logicCustomization
    }
}

/// Chat UI定制化配置
struct ChatUICustomization: Codable {
    let theme: String
    let buttonStyle: String
    let animationType: String
    let colorScheme: [String: String]
    let fontFamily: String
    let borderRadius: Double
    let shadowEnabled: Bool
    
    init(theme: String = "default", buttonStyle: String = "default", animationType: String = "fade", colorScheme: [String: String] = [:], fontFamily: String = "system", borderRadius: Double = 8.0, shadowEnabled: Bool = true) {
        self.theme = theme
        self.buttonStyle = buttonStyle
        self.animationType = animationType
        self.colorScheme = colorScheme
        self.fontFamily = fontFamily
        self.borderRadius = borderRadius
        self.shadowEnabled = shadowEnabled
    }
}

/// Chat逻辑定制化配置
struct ChatLogicCustomization: Codable {
    let responseStrategy: String
    let fallbackEnabled: Bool
    let retryCount: Int
    let timeoutInterval: TimeInterval
    let priorityCapabilities: [ChatCapability]
    let customLogic: [String: String]
    
    init(responseStrategy: String = "sequential", fallbackEnabled: Bool = true, retryCount: Int = 3, timeoutInterval: TimeInterval = 30.0, priorityCapabilities: [ChatCapability] = [], customLogic: [String: Any] = [:]) {
        self.responseStrategy = responseStrategy
        self.fallbackEnabled = fallbackEnabled
        self.retryCount = retryCount
        self.timeoutInterval = timeoutInterval
        self.priorityCapabilities = priorityCapabilities
        self.customLogic = customLogic.mapValues { String(describing: $0) }
    }
}

// MARK: - Chat能力插件协议

/// Chat能力插件协议
protocol ChatCapabilityPlugin: AICapabilityPlugin {
    var supportedChatCapabilities: [ChatCapability] { get }
    func processChatMessage(_ message: String, context: ChatContext) async throws -> ChatResponse
}

/// 业务方专用Chat插件协议
protocol BusinessSpecificChatPlugin: ChatCapabilityPlugin, BusinessSpecificPlugin {
    var chatUICustomization: ChatUICustomization { get }
    var chatLogicCustomization: ChatLogicCustomization { get }
}

// MARK: - Chat能力编排器

/// Chat能力编排器
class ChatCapabilityOrchestrator {
    private let manager = AICapabilityManager.shared
    
    /// 编排Chat能力执行
    func orchestrateCapabilities(_ capabilities: [ChatCapability], 
                                message: String, 
                                context: ChatContext) async throws -> ChatResponse {
        var currentMessage = message
        var usedCapabilities: [ChatCapability] = []
        var totalProcessingTime: TimeInterval = 0
        
        for capability in capabilities {
            guard let plugin = findPlugin(for: capability, businessId: context.businessId) else {
                print("⚠️ 未找到支持能力 \(capability.rawValue) 的插件")
                continue
            }
            
            let startTime = Date()
            let response = try await plugin.processChatMessage(currentMessage, context: context)
            let processingTime = Date().timeIntervalSince(startTime)
            
            usedCapabilities.append(capability)
            totalProcessingTime += processingTime
            currentMessage = response.message
            
            print("✅ 执行能力 \(capability.rawValue) - 处理时间: \(String(format: "%.3f", processingTime))秒")
        }
        
        return ChatResponse(
            message: currentMessage,
            capabilities: usedCapabilities,
            metadata: ["total_processing_time": totalProcessingTime],
            processingTime: totalProcessingTime
        )
    }
    
    /// 查找支持指定能力的插件
    private func findPlugin(for capability: ChatCapability, businessId: String) -> ChatCapabilityPlugin? {
        // 首先查找业务方专用插件
        let businessSpecificPlugins = manager.getAllPlugins().compactMap { $0 as? BusinessSpecificChatPlugin }
        if let businessPlugin = businessSpecificPlugins.first(where: { 
            $0.targetBusinessId == businessId && $0.supportedChatCapabilities.contains(capability)
        }) {
            return businessPlugin
        }
        
        // 然后查找通用插件
        let generalPlugins = manager.getAllPlugins().compactMap { $0 as? ChatCapabilityPlugin }
        return generalPlugins.first(where: { $0.supportedChatCapabilities.contains(capability) })
    }
}

// MARK: - Chat错误定义

/// Chat模块错误类型
enum ChatError: Error, LocalizedError {
    case capabilityNotFound(ChatCapability)
    case pluginNotFound(String)
    case orchestrationFailed(String)
    case invalidConfiguration(String)
    case timeout(String)
    
    var errorDescription: String? {
        switch self {
        case .capabilityNotFound(let capability):
            return "未找到支持能力 \(capability.rawValue) 的插件"
        case .pluginNotFound(let pluginId):
            return "未找到插件: \(pluginId)"
        case .orchestrationFailed(let reason):
            return "能力编排失败: \(reason)"
        case .invalidConfiguration(let reason):
            return "配置无效: \(reason)"
        case .timeout(let operation):
            return "操作超时: \(operation)"
        }
    }
}

// MARK: - 思考链路相关数据结构

/// 思考步骤结构
struct ThinkingStep: Codable {
    let stepId: String
    let stepNumber: Int
    let thinkingType: ThinkingType
    let content: String
    let confidence: Double
    let reasoning: String
    let timestamp: Date
    
    enum ThinkingType: String, Codable {
        case analysis = "分析"
        case reasoning = "推理"
        case evaluation = "评估"
        case synthesis = "综合"
        case conclusion = "结论"
    }
    
    init(stepNumber: Int, thinkingType: ThinkingType, content: String, confidence: Double = 1.0, reasoning: String = "") {
        self.stepId = UUID().uuidString
        self.stepNumber = stepNumber
        self.thinkingType = thinkingType
        self.content = content
        self.confidence = confidence
        self.reasoning = reasoning
        self.timestamp = Date()
    }
}

/// 思考链路结构
struct ThinkingChain: Codable {
    let chainId: String
    let question: String
    let steps: [ThinkingStep]
    let totalSteps: Int
    let overallConfidence: Double
    let processingTime: TimeInterval
    let conclusion: String
    
    init(question: String, steps: [ThinkingStep], conclusion: String, processingTime: TimeInterval = 0.0) {
        self.chainId = UUID().uuidString
        self.question = question
        self.steps = steps
        self.totalSteps = steps.count
        self.overallConfidence = steps.isEmpty ? 0.0 : steps.map { $0.confidence }.reduce(0, +) / Double(steps.count)
        self.processingTime = processingTime
        self.conclusion = conclusion
    }
}

// MARK: - 自定义知识库相关数据结构

/// 知识库文档结构
struct KnowledgeDocument: Codable {
    let documentId: String
    let title: String
    let content: String
    let category: String
    let tags: [String]
    let relevanceScore: Double
    let lastUpdated: Date
    let source: String
    
    init(title: String, content: String, category: String, tags: [String] = [], relevanceScore: Double = 0.0, source: String = "") {
        self.documentId = UUID().uuidString
        self.title = title
        self.content = content
        self.category = category
        self.tags = tags
        self.relevanceScore = relevanceScore
        self.lastUpdated = Date()
        self.source = source
    }
}

/// 知识库检索结果
struct KnowledgeSearchResult: Codable {
    let query: String
    let documents: [KnowledgeDocument]
    let totalResults: Int
    let searchTime: TimeInterval
    let confidence: Double
    
    init(query: String, documents: [KnowledgeDocument], searchTime: TimeInterval = 0.0) {
        self.query = query
        self.documents = documents
        self.totalResults = documents.count
        self.searchTime = searchTime
        self.confidence = documents.isEmpty ? 0.0 : documents.map { $0.relevanceScore }.reduce(0, +) / Double(documents.count)
    }
}