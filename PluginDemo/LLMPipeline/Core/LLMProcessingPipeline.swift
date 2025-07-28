//
//  LLMProcessingPipeline.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 大模型处理管道 - 宿主系统
final class LLMProcessingPipeline {
    
    // MARK: - Properties
    
    private var plugins: [any LLMPlugin] = []
    private let coreLLMService: CoreLLMServiceProtocol
    
    // MARK: - Initialization
    
    init(coreLLMService: CoreLLMServiceProtocol) {
        self.coreLLMService = coreLLMService
    }
    
    // MARK: - Plugin Management
    
    /// 注册插件
    func register(plugin: any LLMPlugin) {
        // 防止重复注册
        if !plugins.contains(where: { $0.pluginId == plugin.pluginId }) {
            plugins.append(plugin)
            // 按优先级排序
            plugins.sort { $0.priority < $1.priority }
            print("LLMPipeline: Registered plugin '\(plugin.pluginId)' with priority \(plugin.priority)")
        }
    }
    
    /// 注册多个插件
    func register(plugins: [any LLMPlugin]) {
        for plugin in plugins {
            register(plugin: plugin)
        }
    }
    
    /// 移除插件
    func unregister(pluginId: String) {
        plugins.removeAll { $0.pluginId == pluginId }
        print("LLMPipeline: Unregistered plugin '\(pluginId)'")
    }
    
    // MARK: - Core Processing
    
    /// 处理 LLM 请求的主要方法
    func process(request: LLMRequest, for clientProfile: ClientProfile) async -> Result<LLMResponse, Error> {
        let context = LLMContext(clientProfile: clientProfile, request: request)
        
        print("LLMPipeline: Starting processing for client '\(clientProfile.name)' (ID: \(clientProfile.clientId))")
        print("LLMPipeline: Request ID: \(request.requestId)")
        
        do {
            // 阶段 1: 认证与授权
            try await authenticatePhase(context: context)
            if context.isAborted { throw context.error! }
            
            // 阶段 2: 请求预处理
            try await requestProcessingPhase(context: context)
            if context.isAborted { throw context.error! }
            
            // 阶段 3: 核心 LLM 调用
            try await coreLLMProcessing(context: context)
            if context.isAborted { throw context.error! }
            
            // 阶段 4: 响应后处理
            try await responseProcessingPhase(context: context)
            if context.isAborted { throw context.error! }
            
            // 标记完成
            context.markCompleted()
            
            // 阶段 5: 审计与日志
            await auditPhase(context: context)
            
            guard let finalResponse = context.finalResponse else {
                throw LLMPipelineError.processingFailed("No final response generated")
            }
            
            print("LLMPipeline: Processing completed successfully in \(String(format: "%.3f", context.totalProcessingTime))s")
            return .success(finalResponse)
            
        } catch {
            context.abort(withError: error)
            
            // 即使失败也要进行审计
            await auditPhase(context: context)
            
            print("LLMPipeline: Processing failed: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    // MARK: - Processing Phases
    
    private func authenticatePhase(context: LLMContext) async throws {
        print("LLMPipeline: Starting authentication phase")
        
        for plugin in plugins {
            if context.isAborted { break }
            
            do {
                try await plugin.authenticate(context: context)
            } catch {
                throw LLMPipelineError.pluginError(plugin.pluginId, error)
            }
        }
        
        print("LLMPipeline: Authentication phase completed")
    }
    
    private func requestProcessingPhase(context: LLMContext) async throws {
        print("LLMPipeline: Starting request processing phase")
        
        for plugin in plugins {
            if context.isAborted { break }
            
            do {
                try await plugin.processRequest(context: context)
            } catch {
                throw LLMPipelineError.pluginError(plugin.pluginId, error)
            }
        }
        
        print("LLMPipeline: Request processing phase completed")
        print("LLMPipeline: Processed prompt: \(context.processedRequest.prompt.prefix(100))...")
    }
    
    private func coreLLMProcessing(context: LLMContext) async throws {
        print("LLMPipeline: Starting core LLM processing")
        
        let response = try await coreLLMService.process(request: context.processedRequest)
        context.rawResponse = response
        context.finalResponse = response
        
        print("LLMPipeline: Core LLM processing completed")
        print("LLMPipeline: Response content: \(response.content.prefix(100))...")
    }
    
    private func responseProcessingPhase(context: LLMContext) async throws {
        print("LLMPipeline: Starting response processing phase")
        
        for plugin in plugins {
            if context.isAborted { break }
            
            do {
                try await plugin.processResponse(context: context)
            } catch {
                throw LLMPipelineError.pluginError(plugin.pluginId, error)
            }
        }
        
        print("LLMPipeline: Response processing phase completed")
    }
    
    private func auditPhase(context: LLMContext) async {
        print("LLMPipeline: Starting audit phase")
        
        for plugin in plugins {
            await plugin.audit(context: context)
        }
        
        print("LLMPipeline: Audit phase completed")
    }
}
