//
//  SecureAuditPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 安全审计插件 - 用于银行客户的完整交互记录
final class SecureAuditPlugin: LLMPlugin {
    let pluginId: String = "com.bank.secure_audit"
    let priority: Int = 100 // 最后执行
    
    private let auditLogger: AuditLoggerProtocol
    
    init(auditLogger: AuditLoggerProtocol = MockAuditLogger()) {
        self.auditLogger = auditLogger
    }
    
    func audit(context: LLMContext) async {
        print("\(pluginId): Starting secure audit logging")
        
        let auditRecord = createAuditRecord(from: context)
        
        do {
            try await auditLogger.log(record: auditRecord)
            print("\(pluginId): Audit record successfully logged with ID: \(auditRecord.id)")
        } catch {
            print("\(pluginId): Failed to log audit record: \(error.localizedDescription)")
            // 在实际应用中，审计失败可能需要特殊处理，如发送告警
        }
        
        // 记录关键指标
        await recordMetrics(from: context)
    }
    
    private func createAuditRecord(from context: LLMContext) -> AuditRecord {
        return AuditRecord(
            id: UUID().uuidString,
            timestamp: Date(),
            clientId: context.clientProfile.clientId,
            clientType: context.clientProfile.clientType.rawValue,
            requestId: context.originalRequest.requestId,
            
            // 请求信息（脱敏后）
            originalPromptHash: context.originalRequest.prompt.sha256Hash,
            processedPromptHash: context.processedRequest.prompt.sha256Hash,
            requestMetadata: context.originalRequest.metadata,
            
            // 响应信息
            responseId: context.finalResponse?.responseId,
            responseContentHash: context.finalResponse?.content.sha256Hash,
            responseMetadata: context.finalResponse?.metadata ?? [:],
            
            // 处理信息
            processingStartTime: context.startTime,
            processingEndTime: context.endTime,
            totalProcessingTime: context.totalProcessingTime,
            
            // 状态信息
            isSuccessful: !context.isAborted,
            errorMessage: context.error?.localizedDescription,
            
            // 安全相关信息
            authenticationMethod: context.sharedData["auth_method"] as? String,
            piiRedacted: context.sharedData["pii_redacted"] as? Bool ?? false,
            guardrailViolation: context.sharedData["guardrail_violation"] as? Bool ?? false,
            contentWarning: context.sharedData["content_warning"] as? Bool ?? false,
            
            // 其他共享数据
            additionalData: context.sharedData
        )
    }
    
    private func recordMetrics(from context: LLMContext) async {
        print("\(pluginId): Recording performance metrics")
        
        // 记录处理时间
        let processingTime = context.totalProcessingTime
        print("\(pluginId): Processing time: \(String(format: "%.3f", processingTime))s")
        
        // 记录认证状态
        if let authMethod = context.sharedData["auth_method"] as? String {
            print("\(pluginId): Authentication method: \(authMethod)")
        }
        
        // 记录PII脱敏统计
        if let redactionCount = context.sharedData["redaction_count"] as? Int {
            print("\(pluginId): PII items redacted: \(redactionCount)")
        }
        
        // 记录安全事件
        if context.sharedData["guardrail_violation"] as? Bool == true {
            print("\(pluginId): SECURITY ALERT - Guardrail violation detected")
        }
        
        // 在实际应用中，这些指标会发送到监控系统
        // 例如：Prometheus、CloudWatch、DataDog 等
    }
}

// MARK: - Audit Models

struct AuditRecord {
    let id: String
    let timestamp: Date
    let clientId: String
    let clientType: String
    let requestId: String
    
    let originalPromptHash: String
    let processedPromptHash: String
    let requestMetadata: [String: Any]
    
    let responseId: String?
    let responseContentHash: String?
    let responseMetadata: [String: Any]
    
    let processingStartTime: Date
    let processingEndTime: Date?
    let totalProcessingTime: TimeInterval
    
    let isSuccessful: Bool
    let errorMessage: String?
    
    let authenticationMethod: String?
    let piiRedacted: Bool
    let guardrailViolation: Bool
    let contentWarning: Bool
    
    let additionalData: [String: Any]
}

// MARK: - Audit Logger Protocol

protocol AuditLoggerProtocol {
    func log(record: AuditRecord) async throws
}

// MARK: - Mock Audit Logger

final class MockAuditLogger: AuditLoggerProtocol {
    func log(record: AuditRecord) async throws {
        // 模拟写入审计日志的延迟
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
        
        print("MockAuditLogger: Logging audit record")
        print("  - Record ID: \(record.id)")
        print("  - Client: \(record.clientId) (\(record.clientType))")
        print("  - Request: \(record.requestId)")
        print("  - Status: \(record.isSuccessful ? "SUCCESS" : "FAILED")")
        print("  - Processing Time: \(String(format: "%.3f", record.totalProcessingTime))s")
        print("  - PII Redacted: \(record.piiRedacted)")
        print("  - Security Violations: \(record.guardrailViolation)")
        
        // 在实际应用中，这里会将记录写入安全的审计数据库
        // 例如：加密存储、不可篡改的日志系统等
    }
}

// MARK: - String Extension for Hashing

extension String {
    var sha256Hash: String {
        // 简单的哈希实现，实际应用中应使用更安全的哈希算法
        return String(self.hashValue)
    }
}
