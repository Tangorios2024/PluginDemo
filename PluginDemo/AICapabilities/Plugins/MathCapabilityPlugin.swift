//
//  MathCapabilityPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 数学能力插件 - 支持数学出题和解题
final class MathCapabilityPlugin: AICapabilityPlugin {
    
    // MARK: - AICapabilityPlugin
    
    let pluginId: String = "com.ai.math"
    let displayName: String = "数学能力引擎"
    let supportedCapabilities: [AICapabilityType] = [.mathProblemGeneration, .mathProblemSolving]
    let priority: Int = 1
    
    func execute(request: AICapabilityRequest) async throws -> AICapabilityResponse {
        try validateInput(request: request)
        
        print("🧮 MathCapabilityPlugin: 开始处理 \(request.capabilityType.displayName)")
        
        // 模拟处理延迟
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒
        
        let output: AIOutput
        var metadata: [String: Any] = [:]
        
        switch request.capabilityType {
        case .mathProblemGeneration:
            output = try await generateMathProblem(request: request)
            metadata["problem_type"] = "algebra"
            metadata["difficulty"] = "medium"
            
        case .mathProblemSolving:
            output = try await solveMathProblem(request: request)
            metadata["solution_steps"] = 3
            metadata["confidence"] = 0.95
            
        default:
            throw AICapabilityError.unsupportedCapability(request.capabilityType)
        }
        
        print("✅ MathCapabilityPlugin: 处理完成")
        
        return AICapabilityResponse(
            requestId: request.requestId,
            capabilityType: request.capabilityType,
            output: output,
            metadata: metadata
        )
    }
    
    // MARK: - Private Methods
    
    private func generateMathProblem(request: AICapabilityRequest) async throws -> AIOutput {
        guard case .text(let prompt) = request.input else {
            throw AICapabilityError.invalidInput("数学出题需要文本输入")
        }
        
        print("📝 MathCapabilityPlugin: 生成数学题目，主题: \(prompt)")
        
        // 模拟生成数学题目
        let problems = [
            "求解方程：2x + 5 = 13",
            "计算：(3 + 4) × 2 - 1",
            "一个长方形的长是8cm，宽是5cm，求面积",
            "小明有15个苹果，吃了3个，还剩多少个？",
            "求函数 f(x) = x² + 2x + 1 的最小值"
        ]
        
        let selectedProblem = problems.randomElement() ?? problems[0]
        
        let result = """
        📚 数学题目生成结果：
        
        题目：\(selectedProblem)
        
        难度：中等
        类型：代数运算
        预计用时：5分钟
        
        提示：仔细阅读题目，按步骤计算
        """
        
        return .text(result)
    }
    
    private func solveMathProblem(request: AICapabilityRequest) async throws -> AIOutput {
        guard case .text(let problem) = request.input else {
            throw AICapabilityError.invalidInput("数学解题需要文本输入")
        }
        
        print("🔍 MathCapabilityPlugin: 解答数学题目: \(problem)")
        
        // 模拟解题过程
        let solution = """
        🧮 数学题目解答：
        
        题目：\(problem)
        
        解题步骤：
        1. 分析题目类型和已知条件
        2. 选择合适的解题方法
        3. 按步骤进行计算
        4. 验证答案的合理性
        
        详细解答：
        根据题目要求，我们需要进行以下计算...
        [模拟详细的解题过程]
        
        最终答案：42
        
        解题要点：
        • 注意运算顺序
        • 检查计算结果
        • 确保答案符合实际情况
        """
        
        return .text(solution)
    }
    
    func validateInput(request: AICapabilityRequest) throws {
        guard supports(request.capabilityType) else {
            throw AICapabilityError.unsupportedCapability(request.capabilityType)
        }

        guard case .text(let input) = request.input, !input.isEmpty else {
            throw AICapabilityError.invalidInput("数学能力需要非空的文本输入")
        }
    }

    func getCapabilityDescription(for type: AICapabilityType) -> String {
        switch type {
        case .mathProblemGeneration:
            return "根据指定主题和难度生成数学题目，支持代数、几何、概率等多种类型"
        case .mathProblemSolving:
            return "解答数学题目，提供详细的解题步骤和思路分析"
        default:
            return type.displayName
        }
    }
}

/// 深度思考能力插件
final class DeepThinkingPlugin: AICapabilityPlugin {
    
    let pluginId: String = "com.ai.deepthinking"
    let displayName: String = "深度思考引擎"
    let supportedCapabilities: [AICapabilityType] = [.deepThinking]
    let priority: Int = 2
    
    func execute(request: AICapabilityRequest) async throws -> AICapabilityResponse {
        try validateInput(request: request)
        
        print("🤔 DeepThinkingPlugin: 开始深度思考分析")
        
        guard case .text(let topic) = request.input else {
            throw AICapabilityError.invalidInput("深度思考需要文本输入")
        }
        
        // 模拟深度思考处理时间
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒
        
        let analysis = """
        🧠 深度思考分析报告：
        
        主题：\(topic)
        
        多维度分析：
        
        1. 问题本质分析
           • 核心问题识别
           • 关键要素提取
           • 影响因素梳理
        
        2. 历史背景考察
           • 相关历史事件
           • 发展演变过程
           • 经验教训总结
        
        3. 现状深度剖析
           • 当前状况评估
           • 存在问题识别
           • 机遇挑战并存
        
        4. 未来趋势预测
           • 发展方向判断
           • 潜在风险评估
           • 应对策略建议
        
        5. 跨领域关联
           • 相关领域影响
           • 系统性思考
           • 综合解决方案
        
        结论：
        通过多维度深度分析，建议采用系统性思维方式，
        综合考虑各种因素，制定科学合理的决策方案。
        """
        
        print("✅ DeepThinkingPlugin: 深度思考分析完成")
        
        return AICapabilityResponse(
            requestId: request.requestId,
            capabilityType: request.capabilityType,
            output: .text(analysis),
            metadata: [
                "analysis_depth": "comprehensive",
                "thinking_time": "1.0s",
                "dimensions": 5
            ]
        )
    }
}
