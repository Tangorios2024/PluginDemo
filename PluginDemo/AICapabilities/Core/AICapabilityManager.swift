//
//  AICapabilityManager.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// AI 能力管理器 - 插件式架构的宿主系统
final class AICapabilityManager {
    
    // MARK: - Properties
    
    private var plugins: [AICapabilityPlugin] = []
    private var businessConfigurations: [String: BusinessConfiguration] = [:]
    
    // MARK: - Singleton
    
    static let shared = AICapabilityManager()
    
    private init() {
        print("🤖 AICapabilityManager: 初始化完成")
    }
    
    // MARK: - 插件管理
    
    /// 注册 AI 能力插件
    func register(plugin: AICapabilityPlugin) {
        // 检查是否已存在相同 ID 的插件
        if plugins.contains(where: { $0.pluginId == plugin.pluginId }) {
            print("⚠️ AICapabilityManager: 插件 \(plugin.pluginId) 已存在，跳过注册")
            return
        }
        
        plugins.append(plugin)
        // 按优先级排序
        plugins.sort { $0.priority < $1.priority }
        
        print("✅ AICapabilityManager: 注册插件 \(plugin.pluginId) - \(plugin.displayName)")
        print("   支持能力: \(plugin.supportedCapabilities.map { $0.displayName }.joined(separator: ", "))")
    }
    
    /// 获取所有已注册的插件
    func getAllPlugins() -> [AICapabilityPlugin] {
        return plugins
    }
    
    /// 获取支持指定能力的插件
    func getPlugins(for capabilityType: AICapabilityType) -> [AICapabilityPlugin] {
        return plugins.filter { $0.supports(capabilityType) }
    }
    
    // MARK: - 业务配置管理
    
    /// 注册业务方配置
    func register(businessConfiguration: BusinessConfiguration) {
        businessConfigurations[businessConfiguration.businessId] = businessConfiguration
        print("🏢 AICapabilityManager: 注册业务配置 \(businessConfiguration.businessId) - \(businessConfiguration.businessName)")
        print("   启用能力: \(businessConfiguration.enabledCapabilities.map { $0.displayName }.joined(separator: ", "))")
    }
    
    /// 获取业务方配置
    func getBusinessConfiguration(for businessId: String) -> BusinessConfiguration? {
        return businessConfigurations[businessId]
    }
    
    // MARK: - AI 能力执行
    
    /// 执行 AI 能力
    func execute(request: AICapabilityRequest, for businessId: String) async throws -> AICapabilityResponse {
        let startTime = Date()
        
        print("🚀 AICapabilityManager: 开始执行能力 \(request.capabilityType.displayName)")
        print("   请求ID: \(request.requestId)")
        print("   业务方: \(businessId)")
        
        // 1. 验证业务方配置
        guard let businessConfig = getBusinessConfiguration(for: businessId) else {
            throw AICapabilityError.authenticationFailed
        }
        
        // 2. 检查业务方是否启用了该能力
        guard businessConfig.enabledCapabilities.contains(request.capabilityType) else {
            print("❌ AICapabilityManager: 业务方 \(businessId) 未启用能力 \(request.capabilityType.displayName)")
            throw AICapabilityError.unsupportedCapability(request.capabilityType)
        }
        
        // 3. 获取支持该能力的插件
        let availablePlugins = getPlugins(for: request.capabilityType)
        guard !availablePlugins.isEmpty else {
            print("❌ AICapabilityManager: 没有找到支持 \(request.capabilityType.displayName) 的插件")
            throw AICapabilityError.unsupportedCapability(request.capabilityType)
        }
        
        // 4. 选择第一个可用的插件（按优先级排序）
        let selectedPlugin = availablePlugins[0]
        print("🔧 AICapabilityManager: 选择插件 \(selectedPlugin.pluginId) - \(selectedPlugin.displayName)")
        
        // 5. 验证输入参数
        try selectedPlugin.validateInput(request: request)
        
        // 6. 执行能力
        do {
            let response = try await selectedPlugin.execute(request: request)
            let processingTime = Date().timeIntervalSince(startTime)
            
            print("✅ AICapabilityManager: 能力执行成功")
            print("   处理时间: \(String(format: "%.3f", processingTime))秒")
            
            // 返回带有实际处理时间的响应
            return AICapabilityResponse(
                requestId: response.requestId,
                capabilityType: response.capabilityType,
                output: response.output,
                metadata: response.metadata,
                processingTime: processingTime
            )
            
        } catch {
            let processingTime = Date().timeIntervalSince(startTime)
            print("❌ AICapabilityManager: 能力执行失败: \(error.localizedDescription)")
            print("   处理时间: \(String(format: "%.3f", processingTime))秒")
            throw error
        }
    }
    
    // MARK: - 能力发现
    
    /// 获取业务方可用的所有能力
    func getAvailableCapabilities(for businessId: String) -> [AICapabilityType] {
        guard let businessConfig = getBusinessConfiguration(for: businessId) else {
            return []
        }
        
        return businessConfig.enabledCapabilities.filter { capabilityType in
            !getPlugins(for: capabilityType).isEmpty
        }
    }
    
    /// 获取能力组合建议
    func getCapabilityCombinations(for businessId: String) -> [[AICapabilityType]] {
        let availableCapabilities = getAvailableCapabilities(for: businessId)
        
        // 预定义的能力组合
        let combinations: [[AICapabilityType]] = [
            // 教育场景
            [.mathProblemGeneration, .mathProblemSolving],
            [.ocr, .textSummary],
            [.translation, .textSummary],
            
            // 内容创作场景
            [.imageGeneration, .imageWatermark],
            [.deepThinking, .textSummary],
            [.webSearch, .textSummary],
            
            // 办公场景
            [.ocr, .translation],
            [.webSearch, .deepThinking],
            [.textSummary, .translation]
        ]
        
        // 过滤出业务方可用的组合
        return combinations.filter { combination in
            combination.allSatisfy { availableCapabilities.contains($0) }
        }
    }
    
    // MARK: - 统计信息
    
    /// 获取插件统计信息
    func getPluginStatistics() -> [String: Any] {
        let totalPlugins = plugins.count
        let capabilityCount = AICapabilityType.allCases.count
        let supportedCapabilities = Set(plugins.flatMap { $0.supportedCapabilities }).count
        
        return [
            "total_plugins": totalPlugins,
            "total_capabilities": capabilityCount,
            "supported_capabilities": supportedCapabilities,
            "coverage_rate": Double(supportedCapabilities) / Double(capabilityCount),
            "registered_businesses": businessConfigurations.count
        ]
    }
}
