//
//  FinancialGuardrailPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 金融护栏插件 - 用于银行客户的内容安全检查
final class FinancialGuardrailPlugin: LLMPlugin {
    let pluginId: String = "com.bank.financial_guardrail"
    let priority: Int = 25
    
    // 禁止的非金融领域关键词
    private let prohibitedKeywords = [
        // 政治敏感
        "政治", "选举", "政府", "政策", "党派",
        // 医疗建议
        "诊断", "治疗", "药物", "手术", "病情",
        // 法律建议
        "起诉", "诉讼", "法律咨询", "律师建议",
        // 其他敏感话题
        "赌博", "博彩", "色情", "暴力", "恐怖主义"
    ]
    
    // 金融相关的允许关键词
    private let allowedFinancialKeywords = [
        "银行", "存款", "贷款", "理财", "投资", "基金", "股票", "债券",
        "保险", "信用卡", "账户", "转账", "汇款", "利率", "收益",
        "风险", "资产", "负债", "财务", "金融", "经济"
    ]
    
    func processRequest(context: LLMContext) async throws {
        print("\(pluginId): Starting financial guardrail check")
        
        let prompt = context.processedRequest.prompt.lowercased()
        
        // 检查是否包含禁止的关键词
        for keyword in prohibitedKeywords {
            if prompt.contains(keyword) {
                let errorMessage = "Request contains prohibited content: '\(keyword)'. This service is restricted to financial topics only."
                print("\(pluginId): Blocked request due to prohibited keyword: \(keyword)")
                
                // 记录违规信息
                context.sharedData["guardrail_violation"] = true
                context.sharedData["violation_keyword"] = keyword
                context.sharedData["violation_type"] = "prohibited_content"
                
                throw LLMPipelineError.contentViolation(errorMessage)
            }
        }
        
        // 检查是否包含金融相关内容
        let hasFinancialContent = allowedFinancialKeywords.contains { keyword in
            prompt.contains(keyword)
        }
        
        if !hasFinancialContent {
            // 如果没有明确的金融关键词，进行更宽松的检查
            let financialIndicators = ["钱", "费用", "价格", "成本", "收入", "支出", "财产"]
            let hasFinancialIndicator = financialIndicators.contains { indicator in
                prompt.contains(indicator)
            }
            
            if !hasFinancialIndicator {
                let warningMessage = "Request does not appear to be related to financial services. Please ensure your inquiry is within our service scope."
                print("\(pluginId): Warning - Non-financial content detected")
                
                // 记录警告信息，但不阻止请求
                context.sharedData["guardrail_warning"] = true
                context.sharedData["warning_type"] = "non_financial_content"
                
                // 在实际应用中，这里可能会根据配置决定是否阻止请求
                // 为了演示，我们只记录警告但允许继续处理
            }
        }
        
        // 检查请求长度
        if context.processedRequest.prompt.count > 2000 {
            print("\(pluginId): Warning - Request exceeds recommended length")
            context.sharedData["length_warning"] = true
        }
        
        // 记录检查结果
        context.sharedData["guardrail_checked"] = true
        context.sharedData["financial_content_detected"] = hasFinancialContent
        
        print("\(pluginId): Financial guardrail check completed - Request approved")
    }
    
    func processResponse(context: LLMContext) async throws {
        print("\(pluginId): Checking response content")
        
        guard let response = context.finalResponse else {
            print("\(pluginId): No response to check")
            return
        }
        
        let responseContent = response.content.lowercased()
        
        // 检查响应中是否包含不当内容
        for keyword in prohibitedKeywords {
            if responseContent.contains(keyword) {
                print("\(pluginId): Warning - Response contains potentially inappropriate content: \(keyword)")
                
                // 在实际应用中，这里可能会过滤或修改响应内容
                // 为了演示，我们只记录警告
                var updatedMetadata = response.metadata
                updatedMetadata["content_warning"] = true
                updatedMetadata["warning_keyword"] = keyword
                
                context.finalResponse = LLMResponse(
                    content: response.content,
                    metadata: updatedMetadata,
                    processingTime: response.processingTime
                )
            }
        }
        
        // 添加合规声明
        let complianceNotice = "\n\n[免责声明：以上信息仅供参考，不构成投资建议。请根据自身情况谨慎决策，如有疑问请咨询专业理财顾问。]"
        
        let updatedContent = response.content + complianceNotice
        var updatedMetadata = response.metadata
        updatedMetadata["compliance_notice_added"] = true
        
        context.finalResponse = LLMResponse(
            content: updatedContent,
            metadata: updatedMetadata,
            processingTime: response.processingTime
        )
        
        print("\(pluginId): Response guardrail check completed")
    }
}
