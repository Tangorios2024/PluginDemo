//
//  PiiRedactionPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// PII 脱敏插件 - 用于银行客户的敏感信息保护
final class PiiRedactionPlugin: LLMPlugin {
    let pluginId: String = "com.bank.pii_redaction"
    let priority: Int = 20
    
    // 存储脱敏映射，用于响应时的反向处理
    private var redactionMap: [String: String] = [:]
    
    func processRequest(context: LLMContext) async throws {
        print("\(pluginId): Starting PII redaction for request")
        
        var redactedPrompt = context.processedRequest.prompt
        var redactedMetadata = context.processedRequest.metadata
        
        // 脱敏身份证号码
        redactedPrompt = redactIDNumbers(in: redactedPrompt)
        
        // 脱敏银行卡号
        redactedPrompt = redactBankCardNumbers(in: redactedPrompt)
        
        // 脱敏手机号码
        redactedPrompt = redactPhoneNumbers(in: redactedPrompt)
        
        // 脱敏邮箱地址
        redactedPrompt = redactEmailAddresses(in: redactedPrompt)
        
        // 脱敏姓名（简单的中文姓名检测）
        redactedPrompt = redactChineseNames(in: redactedPrompt)
        
        // 更新处理后的请求
        context.processedRequest = LLMRequest(
            prompt: redactedPrompt,
            parameters: context.processedRequest.parameters,
            metadata: redactedMetadata
        )
        
        // 保存脱敏信息到共享数据
        context.sharedData["pii_redacted"] = true
        context.sharedData["redaction_count"] = redactionMap.count
        
        print("\(pluginId): PII redaction completed, \(redactionMap.count) items redacted")
        if !redactionMap.isEmpty {
            print("\(pluginId): Redacted prompt: \(redactedPrompt.prefix(200))...")
        }
    }
    
    func processResponse(context: LLMContext) async throws {
        print("\(pluginId): Processing response for PII handling")
        
        guard let finalResponse = context.finalResponse else {
            print("\(pluginId): No response to process")
            return
        }
        
        var processedContent = finalResponse.content
        var processedMetadata = finalResponse.metadata
        
        // 检查响应中是否包含脱敏标记，如果有则保持脱敏状态
        // 在实际应用中，这里可能需要更复杂的逻辑来决定是否反向脱敏
        
        // 为响应添加脱敏相关的元数据
        processedMetadata["pii_processed"] = true
        processedMetadata["redaction_applied"] = !redactionMap.isEmpty
        
        // 更新最终响应
        context.finalResponse = LLMResponse(
            content: processedContent,
            metadata: processedMetadata,
            processingTime: finalResponse.processingTime
        )
        
        print("\(pluginId): Response PII processing completed")
    }
    
    // MARK: - Private Redaction Methods
    
    private func redactIDNumbers(in text: String) -> String {
        // 身份证号码正则：18位数字，最后一位可能是X
        let pattern = "\\b\\d{17}[\\dXx]\\b"
        return redactWithPattern(text: text, pattern: pattern, replacement: "[REDACTED_ID]")
    }
    
    private func redactBankCardNumbers(in text: String) -> String {
        // 银行卡号正则：13-19位数字
        let pattern = "\\b\\d{13,19}\\b"
        return redactWithPattern(text: text, pattern: pattern, replacement: "[REDACTED_CARD]")
    }
    
    private func redactPhoneNumbers(in text: String) -> String {
        // 手机号码正则：11位数字，以1开头
        let pattern = "\\b1[3-9]\\d{9}\\b"
        return redactWithPattern(text: text, pattern: pattern, replacement: "[REDACTED_PHONE]")
    }
    
    private func redactEmailAddresses(in text: String) -> String {
        // 邮箱地址正则
        let pattern = "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b"
        return redactWithPattern(text: text, pattern: pattern, replacement: "[REDACTED_EMAIL]")
    }
    
    private func redactChineseNames(in text: String) -> String {
        // 简单的中文姓名检测：2-4个中文字符，前面有"我是"、"姓名"等关键词
        let pattern = "(?<=我是|姓名[:：]?\\s*|叫做|名字[:：]?\\s*)[\\u4e00-\\u9fa5]{2,4}(?=\\s|，|。|$)"
        return redactWithPattern(text: text, pattern: pattern, replacement: "[REDACTED_NAME]")
    }
    
    private func redactWithPattern(text: String, pattern: String, replacement: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: text.utf16.count)
            let matches = regex.matches(in: text, options: [], range: range)
            
            var result = text
            var offset = 0
            
            for match in matches {
                let matchRange = match.range
                let adjustedRange = NSRange(location: matchRange.location + offset, length: matchRange.length)
                
                if let swiftRange = Range(adjustedRange, in: result) {
                    let originalValue = String(result[swiftRange])
                    let redactionKey = "redaction_\(redactionMap.count)"
                    redactionMap[redactionKey] = originalValue
                    
                    result.replaceSubrange(swiftRange, with: replacement)
                    offset += replacement.count - matchRange.length
                }
            }
            
            return result
        } catch {
            print("\(pluginId): Regex error for pattern \(pattern): \(error)")
            return text
        }
    }
}
