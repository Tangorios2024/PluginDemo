//
//  LLMPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

// MARK: - LLM Plugin Protocol

/// LLM 插件的契约
protocol LLMPlugin {
    /// 插件的唯一标识符
    var pluginId: String { get }
    
    /// 插件的执行优先级，数字越小越先执行
    var priority: Int { get }
    
    /// **扩展点 1: 请求认证与授权**
    /// 在处理管道的最开始执行，用于验证请求的合法性。
    func authenticate(context: LLMContext) async throws
    
    /// **扩展点 2: 请求预处理**
    /// 在请求发送给核心 LLM 之前，对请求进行修改。
    func processRequest(context: LLMContext) async throws
    
    /// **扩展点 3: 响应后处理**
    /// 在收到核心 LLM 的响应之后，对响应进行修改。
    func processResponse(context: LLMContext) async throws
    
    /// **扩展点 4: 审计与日志**
    /// 在整个流程的最后（无论成功或失败）执行，用于记录。
    func audit(context: LLMContext) async
}

// MARK: - Default Implementations

extension LLMPlugin {
    /// 默认不进行认证
    func authenticate(context: LLMContext) async throws {
        print("\(pluginId): Default authentication - no action")
    }
    
    /// 默认不处理请求
    func processRequest(context: LLMContext) async throws {
        print("\(pluginId): Default request processing - no action")
    }
    
    /// 默认不处理响应
    func processResponse(context: LLMContext) async throws {
        print("\(pluginId): Default response processing - no action")
    }
    
    /// 默认审计实现
    func audit(context: LLMContext) async {
        let status = context.isAborted ? "FAILED" : "SUCCESS"
        let processingTime = context.totalProcessingTime
        print("\(pluginId): Audit - Status: \(status), Processing time: \(String(format: "%.3f", processingTime))s")
    }
}

// MARK: - Plugin Comparison

/// 全局函数用于插件排序
func < (lhs: any LLMPlugin, rhs: any LLMPlugin) -> Bool {
    return lhs.priority < rhs.priority
}
