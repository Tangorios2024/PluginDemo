//
//  QuotaControlPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 配额控制插件 - 用于学校客户的使用量管理
final class QuotaControlPlugin: LLMPlugin {
    let pluginId: String = "com.school.quota_control"
    let priority: Int = 15
    
    private let quotaManager: QuotaManagerProtocol
    
    init(quotaManager: QuotaManagerProtocol = MockQuotaManager()) {
        self.quotaManager = quotaManager
    }
    
    func authenticate(context: LLMContext) async throws {
        print("\(pluginId): Checking user quota")
        
        // 获取用户信息
        guard let userId = context.sharedData["user_id"] as? String,
              let userRole = context.sharedData["user_role"] as? String else {
            throw LLMPipelineError.authenticationFailed("User information not found for quota check")
        }
        
        // 检查用户配额
        let quotaInfo = try await quotaManager.getQuotaInfo(userId: userId)
        
        // 验证是否还有可用配额
        if quotaInfo.usedQuota >= quotaInfo.totalQuota {
            let errorMessage = "User \(userId) has exceeded their quota (\(quotaInfo.usedQuota)/\(quotaInfo.totalQuota))"
            print("\(pluginId): Quota exceeded for user \(userId)")
            
            context.sharedData["quota_exceeded"] = true
            context.sharedData["quota_info"] = quotaInfo
            
            throw LLMPipelineError.quotaExceeded(errorMessage)
        }
        
        // 预扣配额（乐观锁）
        try await quotaManager.reserveQuota(userId: userId, amount: 1)
        
        // 记录配额信息
        context.sharedData["quota_reserved"] = true
        context.sharedData["quota_info"] = quotaInfo
        context.sharedData["remaining_quota"] = quotaInfo.totalQuota - quotaInfo.usedQuota - 1
        
        print("\(pluginId): Quota check passed for user \(userId)")
        print("\(pluginId): Remaining quota: \(quotaInfo.totalQuota - quotaInfo.usedQuota - 1)/\(quotaInfo.totalQuota)")
    }
    
    func audit(context: LLMContext) async {
        print("\(pluginId): Finalizing quota usage")
        
        guard let userId = context.sharedData["user_id"] as? String else {
            print("\(pluginId): No user ID found for quota finalization")
            return
        }
        
        if context.isAborted {
            // 如果处理失败，释放预留的配额
            do {
                try await quotaManager.releaseQuota(userId: userId, amount: 1)
                print("\(pluginId): Released reserved quota for failed request")
            } catch {
                print("\(pluginId): Failed to release quota: \(error.localizedDescription)")
            }
        } else {
            // 如果处理成功，确认配额使用
            do {
                try await quotaManager.confirmQuotaUsage(userId: userId, amount: 1)
                print("\(pluginId): Confirmed quota usage for successful request")
            } catch {
                print("\(pluginId): Failed to confirm quota usage: \(error.localizedDescription)")
            }
        }
        
        // 记录使用统计
        await recordUsageStats(userId: userId, context: context)
    }
    
    private func recordUsageStats(userId: String, context: LLMContext) async {
        print("\(pluginId): Recording usage statistics for user \(userId)")
        
        let stats = UsageStats(
            userId: userId,
            timestamp: Date(),
            requestId: context.originalRequest.requestId,
            isSuccessful: !context.isAborted,
            processingTime: context.totalProcessingTime,
            promptLength: context.originalRequest.prompt.count,
            responseLength: context.finalResponse?.content.count ?? 0
        )
        
        // 在实际应用中，这些统计数据会存储到数据库中用于分析
        print("\(pluginId): Usage stats - Prompt: \(stats.promptLength) chars, Response: \(stats.responseLength) chars")
    }
}

// MARK: - Quota Models

struct QuotaInfo {
    let userId: String
    let totalQuota: Int
    let usedQuota: Int
    let resetDate: Date
    let quotaType: QuotaType
    
    enum QuotaType {
        case daily
        case weekly
        case monthly
        case semester
    }
}

struct UsageStats {
    let userId: String
    let timestamp: Date
    let requestId: String
    let isSuccessful: Bool
    let processingTime: TimeInterval
    let promptLength: Int
    let responseLength: Int
}

// MARK: - Quota Manager Protocol

protocol QuotaManagerProtocol {
    func getQuotaInfo(userId: String) async throws -> QuotaInfo
    func reserveQuota(userId: String, amount: Int) async throws
    func releaseQuota(userId: String, amount: Int) async throws
    func confirmQuotaUsage(userId: String, amount: Int) async throws
}

// MARK: - Mock Quota Manager

final class MockQuotaManager: QuotaManagerProtocol {
    private var quotaData: [String: QuotaInfo] = [
        "student_001": QuotaInfo(userId: "student_001", totalQuota: 50, usedQuota: 23, resetDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, quotaType: .daily),
        "teacher_001": QuotaInfo(userId: "teacher_001", totalQuota: 200, usedQuota: 45, resetDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, quotaType: .daily),
        "student_002": QuotaInfo(userId: "student_002", totalQuota: 30, usedQuota: 28, resetDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, quotaType: .daily)
    ]
    
    private var reservedQuota: [String: Int] = [:]
    
    func getQuotaInfo(userId: String) async throws -> QuotaInfo {
        // 模拟数据库查询延迟
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05秒
        
        guard let quota = quotaData[userId] else {
            // 为新用户创建默认配额
            let defaultQuota = QuotaInfo(
                userId: userId,
                totalQuota: 20,
                usedQuota: 0,
                resetDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                quotaType: .daily
            )
            quotaData[userId] = defaultQuota
            return defaultQuota
        }
        
        return quota
    }
    
    func reserveQuota(userId: String, amount: Int) async throws {
        reservedQuota[userId, default: 0] += amount
        print("MockQuotaManager: Reserved \(amount) quota for user \(userId)")
    }
    
    func releaseQuota(userId: String, amount: Int) async throws {
        reservedQuota[userId, default: 0] = max(0, reservedQuota[userId, default: 0] - amount)
        print("MockQuotaManager: Released \(amount) quota for user \(userId)")
    }
    
    func confirmQuotaUsage(userId: String, amount: Int) async throws {
        if var quota = quotaData[userId] {
            quota = QuotaInfo(
                userId: quota.userId,
                totalQuota: quota.totalQuota,
                usedQuota: quota.usedQuota + amount,
                resetDate: quota.resetDate,
                quotaType: quota.quotaType
            )
            quotaData[userId] = quota
        }
        
        reservedQuota[userId, default: 0] = max(0, reservedQuota[userId, default: 0] - amount)
        print("MockQuotaManager: Confirmed usage of \(amount) quota for user \(userId)")
    }
}
