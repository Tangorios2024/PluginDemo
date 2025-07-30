//
//  AICapabilityProtocol.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

// MARK: - AI 能力请求和响应模型

/// AI 能力请求
struct AICapabilityRequest {
    let requestId: String
    let capabilityType: AICapabilityType
    let input: AIInput
    let parameters: [String: Any]
    let metadata: [String: Any]
    
    init(capabilityType: AICapabilityType, input: AIInput, parameters: [String: Any] = [:], metadata: [String: Any] = [:]) {
        self.requestId = UUID().uuidString
        self.capabilityType = capabilityType
        self.input = input
        self.parameters = parameters
        self.metadata = metadata
    }
}

/// AI 能力响应
struct AICapabilityResponse {
    let requestId: String
    let capabilityType: AICapabilityType
    let output: AIOutput
    let metadata: [String: Any]
    let processingTime: TimeInterval
    
    init(requestId: String, capabilityType: AICapabilityType, output: AIOutput, metadata: [String: Any] = [:], processingTime: TimeInterval = 0) {
        self.requestId = requestId
        self.capabilityType = capabilityType
        self.output = output
        self.metadata = metadata
        self.processingTime = processingTime
    }
}

// MARK: - AI 能力类型

/// AI 能力类型枚举
enum AICapabilityType: String, CaseIterable {
    case mathProblemGeneration = "math_problem_generation"    // 数学出题
    case mathProblemSolving = "math_problem_solving"          // 数学解题
    case imageWatermark = "image_watermark"                   // 图片水印
    case imageGeneration = "image_generation"                 // 图片生成
    case deepThinking = "deep_thinking"                       // 深度思考
    case webSearch = "web_search"                             // 网络搜索
    case videoCall = "video_call"                             // 音视频通话
    case ocr = "ocr"                                          // OCR 识别
    case textSummary = "text_summary"                         // 文本摘要
    case translation = "translation"                          // 翻译

    // 教育场景新增能力
    case dataAnalysis = "data_analysis"                       // 数据分析
    case userProfiling = "user_profiling"                     // 用户画像
    case contentRecommendation = "content_recommendation"     // 内容推荐
    case tts = "tts"                                          // 文本转语音
                case dialogueInteraction = "dialogue_interaction"         // 对话交互
            case storyGeneration = "story_generation"                 // 故事生成
            
            // 即时通信场景新增能力
            case chatDialogue = "chat_dialogue"                       // 聊天对话
            case documentAnalysis = "document_analysis"               // 文档分析
            case knowledgeBaseQuery = "knowledge_base_query"          // 知识库查询
            
            // 反馈收集场景新增能力
            case feedbackCollection = "feedback_collection"           // 反馈收集
    
    var displayName: String {
        switch self {
        case .mathProblemGeneration: return "数学出题"
        case .mathProblemSolving: return "数学解题"
        case .imageWatermark: return "图片水印"
        case .imageGeneration: return "图片生成"
        case .deepThinking: return "深度思考"
        case .webSearch: return "网络搜索"
        case .videoCall: return "音视频通话"
        case .ocr: return "OCR识别"
        case .textSummary: return "文本摘要"
        case .translation: return "翻译"
        case .dataAnalysis: return "数据分析"
        case .userProfiling: return "用户画像"
        case .contentRecommendation: return "内容推荐"
        case .tts: return "文本转语音"
                        case .dialogueInteraction: return "对话交互"
                case .storyGeneration: return "故事生成"
            case .chatDialogue: return "聊天对话"
            case .documentAnalysis: return "文档分析"
            case .knowledgeBaseQuery: return "知识库查询"
            case .feedbackCollection: return "反馈收集"
        }
    }
}

// MARK: - AI 输入输出

/// AI 输入数据
enum AIInput {
    case text(String)
    case image(Data)
    case audio(Data)
    case video(Data)
    case multiModal(text: String?, image: Data?, audio: Data?)
    case structured([String: Any])
}

/// AI 输出数据
enum AIOutput {
    case text(String)
    case image(Data)
    case audio(Data)
    case video(Data)
    case multiModal(text: String?, image: Data?, audio: Data?)
    case structured([String: Any])
    case error(String)
}

// MARK: - AI 能力插件协议

/// AI 能力插件协议
protocol AICapabilityPlugin {
    /// 插件唯一标识
    var pluginId: String { get }
    
    /// 插件名称
    var displayName: String { get }
    
    /// 支持的能力类型
    var supportedCapabilities: [AICapabilityType] { get }
    
    /// 插件优先级（数字越小优先级越高）
    var priority: Int { get }
    
    /// 是否支持指定的能力类型
    func supports(_ capabilityType: AICapabilityType) -> Bool
    
    /// 执行 AI 能力
    func execute(request: AICapabilityRequest) async throws -> AICapabilityResponse
    
    /// 验证输入参数
    func validateInput(request: AICapabilityRequest) throws
    
    /// 获取能力描述
    func getCapabilityDescription(for type: AICapabilityType) -> String
}

// MARK: - AI 能力插件默认实现

extension AICapabilityPlugin {
    func supports(_ capabilityType: AICapabilityType) -> Bool {
        return supportedCapabilities.contains(capabilityType)
    }
    
    func validateInput(request: AICapabilityRequest) throws {
        guard supports(request.capabilityType) else {
            throw AICapabilityError.unsupportedCapability(request.capabilityType)
        }
    }
    
    func getCapabilityDescription(for type: AICapabilityType) -> String {
        return type.displayName
    }
}

// MARK: - AI 能力错误

enum AICapabilityError: Error, LocalizedError {
    case unsupportedCapability(AICapabilityType)
    case invalidInput(String)
    case processingFailed(String)
    case networkError(String)
    case quotaExceeded
    case authenticationFailed
    
    var errorDescription: String? {
        switch self {
        case .unsupportedCapability(let type):
            return "不支持的能力类型: \(type.displayName)"
        case .invalidInput(let message):
            return "输入参数无效: \(message)"
        case .processingFailed(let message):
            return "处理失败: \(message)"
        case .networkError(let message):
            return "网络错误: \(message)"
        case .quotaExceeded:
            return "配额已用完"
        case .authenticationFailed:
            return "认证失败"
        }
    }
}

// MARK: - 业务配置

/// 业务方配置
struct BusinessConfiguration {
    let businessId: String
    let businessName: String
    let enabledCapabilities: [AICapabilityType]
    let quotaLimits: [AICapabilityType: Int]
    let customParameters: [String: Any]
    
    init(businessId: String, businessName: String, enabledCapabilities: [AICapabilityType], quotaLimits: [AICapabilityType: Int] = [:], customParameters: [String: Any] = [:]) {
        self.businessId = businessId
        self.businessName = businessName
        self.enabledCapabilities = enabledCapabilities
        self.quotaLimits = quotaLimits
        self.customParameters = customParameters
    }
}

// MARK: - 业务方专用插件协议

/// 业务方专用插件协议 - 用于标识为特定业务方定制的插件
protocol BusinessSpecificPlugin: AICapabilityPlugin {
    /// 目标业务方ID
    var targetBusinessId: String { get }
    
    /// 业务方特定的配置参数
    var businessSpecificConfig: [String: Any] { get }
}

// MARK: - 业务方专用插件默认实现

extension BusinessSpecificPlugin {
    var businessSpecificConfig: [String: Any] {
        return [:]
    }
}
