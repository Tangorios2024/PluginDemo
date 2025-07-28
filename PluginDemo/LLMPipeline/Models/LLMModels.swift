//
//  LLMModels.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

// MARK: - Client Profile

/// 客户配置信息
struct ClientProfile {
    let clientId: String
    let clientType: ClientType
    let name: String
    let configuration: [String: Any]
    
    enum ClientType: String {
        case bank = "bank"
        case school = "school"
        case research = "research"
        case enterprise = "enterprise"
    }
}

// MARK: - LLM Request & Response

/// LLM 请求
struct LLMRequest {
    let requestId: String
    let prompt: String
    let parameters: [String: Any]
    let metadata: [String: Any]
    
    init(prompt: String, parameters: [String: Any] = [:], metadata: [String: Any] = [:]) {
        self.requestId = UUID().uuidString
        self.prompt = prompt
        self.parameters = parameters
        self.metadata = metadata
    }
}

/// LLM 响应
struct LLMResponse {
    let responseId: String
    let content: String
    let metadata: [String: Any]
    let processingTime: TimeInterval
    
    init(content: String, metadata: [String: Any] = [:], processingTime: TimeInterval = 0) {
        self.responseId = UUID().uuidString
        self.content = content
        self.metadata = metadata
        self.processingTime = processingTime
    }
}

// MARK: - LLM Context

/// 贯穿整个管道的上下文对象，用于在插件间传递和修改状态
class LLMContext {
    // 客户的身份和配置信息
    let clientProfile: ClientProfile
    
    // 请求相关数据
    let originalRequest: LLMRequest
    var processedRequest: LLMRequest
    
    // 响应相关数据
    var rawResponse: LLMResponse?
    var finalResponse: LLMResponse?
    
    // 一个字典，用于插件间传递临时数据
    var sharedData: [String: Any] = [:]
    
    // 错误信息
    var error: Error?
    var isAborted: Bool = false
    
    // 处理时间戳
    let startTime: Date
    var endTime: Date?
    
    init(clientProfile: ClientProfile, request: LLMRequest) {
        self.clientProfile = clientProfile
        self.originalRequest = request
        self.processedRequest = request
        self.startTime = Date()
    }
    
    /// 终止管道执行的方法
    func abort(withError error: Error) {
        self.error = error
        self.isAborted = true
        self.endTime = Date()
        print("LLMContext: Pipeline aborted with error: \(error.localizedDescription)")
    }
    
    /// 标记处理完成
    func markCompleted() {
        self.endTime = Date()
    }
    
    /// 获取总处理时间
    var totalProcessingTime: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
}

// MARK: - Errors

enum LLMPipelineError: Error, LocalizedError {
    case authenticationFailed(String)
    case quotaExceeded(String)
    case contentViolation(String)
    case processingFailed(String)
    case pluginError(String, Error)
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .quotaExceeded(let message):
            return "Quota exceeded: \(message)"
        case .contentViolation(let message):
            return "Content violation: \(message)"
        case .processingFailed(let message):
            return "Processing failed: \(message)"
        case .pluginError(let pluginId, let error):
            return "Plugin '\(pluginId)' error: \(error.localizedDescription)"
        }
    }
}
