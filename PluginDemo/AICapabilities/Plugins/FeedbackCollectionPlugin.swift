//
//  FeedbackCollectionPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 反馈收集能力插件 - 支持用户反馈收集功能
final class FeedbackCollectionPlugin: AICapabilityPlugin {
    
    let pluginId: String = "com.ai.feedback"
    let displayName: String = "反馈收集引擎"
    let supportedCapabilities: [AICapabilityType] = [.feedbackCollection]
    let priority: Int = 1
    
    func execute(request: AICapabilityRequest) async throws -> AICapabilityResponse {
        try validateInput(request: request)
        
        print("📝 FeedbackCollectionPlugin: 开始处理反馈收集")
        
        guard case .text(let feedbackContent) = request.input else {
            throw AICapabilityError.invalidInput("反馈收集需要文本输入")
        }
        
        // 模拟反馈处理时间
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6秒
        
        let response = """
        📝 反馈收集结果：
        
        用户反馈：\(feedbackContent)
        
        ✅ 反馈已成功收集
        📊 情感分析：积极
        🏷️ 分类标签：用户体验
        ⭐ 满意度评分：4.2/5.0
        
        感谢您的宝贵反馈！
        """
        
        print("✅ FeedbackCollectionPlugin: 反馈收集处理完成")
        
        return AICapabilityResponse(
            requestId: request.requestId,
            capabilityType: request.capabilityType,
            output: .text(response),
            metadata: [
                "response_type": "feedback_collection",
                "sentiment": "positive",
                "category": "user_experience",
                "satisfaction_score": 4.2,
                "processing_time": "0.6s"
            ]
        )
    }
} 