//
//  BusinessBFeedbackPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 业务方B专用的反馈收集插件 - 技术团队协作反馈收集
final class BusinessBFeedbackPlugin: BusinessSpecificPlugin {
    
    let pluginId: String = "com.ai.businessB.feedback"
    let displayName: String = "业务方B反馈收集引擎"
    let supportedCapabilities: [AICapabilityType] = [.feedbackCollection]
    let priority: Int = 1
    let targetBusinessId: String = "business_b"
    
    var businessSpecificConfig: [String: Any] {
        return [
            "brand_name": "BusinessB",
            "brand_logo": "💻",
            "ui_theme": "developer",
            "feedback_categories": ["功能建议", "Bug报告", "性能问题", "文档改进"],
            "rating_scale": 10,
            "auto_categorization": true,
            "github_integration": true,
            "developer_features": true,
            "knowledge_base_linking": true
        ]
    }
    
    func execute(request: AICapabilityRequest) async throws -> AICapabilityResponse {
        try validateInput(request: request)
        
        print("📝 BusinessBFeedbackPlugin: 开始处理技术团队反馈收集")
        print("   💻 品牌标识: \(businessSpecificConfig["brand_logo"] ?? "")")
        print("   🎨 UI主题: \(businessSpecificConfig["ui_theme"] ?? "")")
        
        guard case .text(let feedbackContent) = request.input else {
            throw AICapabilityError.invalidInput("反馈收集需要文本输入")
        }
        
        // 模拟技术团队反馈处理时间（包含技术分析）
        try await Task.sleep(nanoseconds: 700_000_000) // 0.7秒
        
        // 技术团队特有的反馈处理逻辑
        let categories = businessSpecificConfig["feedback_categories"] as? [String] ?? []
        let selectedCategory = categories.randomElement() ?? "其他"
        let severity = feedbackContent.contains("崩溃") || feedbackContent.contains("错误") ? "严重" : "一般"
        let hasRelatedDocs = feedbackContent.contains("文档") || feedbackContent.contains("说明")
        
        let response = """
        💻 BusinessB 技术团队反馈收集结果
        
        \(businessSpecificConfig["brand_logo"] ?? "") \(businessSpecificConfig["brand_name"] ?? "")
        
        用户反馈：\(feedbackContent)
        
        ✅ 反馈已成功收集并分析
        📊 情感分析：积极
        🏷️ 分类标签：\(selectedCategory)
        ⚠️ 严重程度：\(severity)
        ⭐ 满意度评分：8.5/10.0
        
        🔧 技术团队处理：
        • 自动分类：\(selectedCategory)
        • 严重程度评估：\(severity)
        • GitHub集成：已创建Issue
        • 知识库关联：\(hasRelatedDocs ? "找到相关文档" : "无相关文档")
        • 技术标签：已添加技术标签
        
        💻 开发者回复：
        感谢您的技术反馈！我们的开发团队将仔细分析您的建议。
        相关Issue已创建，您可以在GitHub上跟踪处理进度。
        
        📚 相关资源：
        • 技术文档：已关联相关章节
        • 最佳实践：推荐查看相关指南
        • 社区讨论：可在开发者论坛继续讨论
        
        💻 您的技术协作伙伴
        """
        
        print("✅ BusinessBFeedbackPlugin: 技术团队反馈收集处理完成")
        
        return AICapabilityResponse(
            requestId: request.requestId,
            capabilityType: request.capabilityType,
            output: .text(response),
            metadata: [
                "brand": "BusinessB",
                "ui_theme": "developer",
                "feedback_category": selectedCategory,
                "severity_level": severity,
                "developer_features": true,
                "github_integration": true,
                "knowledge_base_linking": hasRelatedDocs,
                "issue_created": true,
                "satisfaction_score": 8.5,
                "processing_time": "0.7s"
            ]
        )
    }
} 