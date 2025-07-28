//
//  CoreLLMService.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

// MARK: - Core LLM Service Protocol

/// 核心 LLM 服务协议
protocol CoreLLMServiceProtocol {
    func process(request: LLMRequest) async throws -> LLMResponse
}

// MARK: - Mock Core LLM Service

/// 模拟的核心 LLM 服务实现
final class MockCoreLLMService: CoreLLMServiceProtocol {
    
    func process(request: LLMRequest) async throws -> LLMResponse {
        // 模拟处理延迟
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒
        
        print("MockCoreLLMService: Processing request \(request.requestId)")
        
        // 模拟不同类型的响应
        let responseContent = generateMockResponse(for: request.prompt)
        
        let response = LLMResponse(
            content: responseContent,
            metadata: [
                "model": "mock-gpt-4",
                "tokens_used": Int.random(in: 100...500),
                "processing_node": "node-\(Int.random(in: 1...10))"
            ],
            processingTime: 0.5
        )
        
        print("MockCoreLLMService: Generated response \(response.responseId)")
        return response
    }
    
    private func generateMockResponse(for prompt: String) -> String {
        // 根据提示词生成不同的模拟响应
        let lowercasePrompt = prompt.lowercased()
        
        if lowercasePrompt.contains("银行") || lowercasePrompt.contains("金融") || lowercasePrompt.contains("bank") {
            return """
            作为您的金融助手，我可以帮您解答银行业务相关问题。请注意，所有金融建议仅供参考，具体操作请咨询专业理财顾问。
            
            关于您的询问：\(prompt.prefix(50))...
            
            建议您：
            1. 仔细阅读相关条款
            2. 评估风险承受能力
            3. 咨询专业人士意见
            
            如需更多帮助，请联系客服热线。
            """
        } else if lowercasePrompt.contains("学习") || lowercasePrompt.contains("教育") || lowercasePrompt.contains("school") {
            return """
            很高兴为您提供学习指导！让我们一起探索知识的海洋。
            
            关于您的问题：\(prompt.prefix(50))...
            
            我建议采用苏格拉底式的学习方法：
            1. 首先思考您已经知道什么？
            2. 这个问题的核心是什么？
            3. 我们可以从哪些角度来分析？
            
            请告诉我您的思考过程，我会引导您找到答案。
            """
        } else {
            return """
            感谢您的提问！我是一个大语言模型助手，致力于为您提供有用、准确、安全的信息。
            
            关于您的询问：\(prompt.prefix(50))...
            
            基于我的理解，我认为这个问题涉及以下几个方面：
            1. 核心概念的理解
            2. 实际应用的考虑
            3. 潜在风险的评估
            
            请让我知道您希望我重点关注哪个方面，我会为您提供更详细的解答。
            """
        }
    }
}
