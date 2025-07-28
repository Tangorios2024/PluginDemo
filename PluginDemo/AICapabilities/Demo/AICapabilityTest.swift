//
//  AICapabilityTest.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// AI 能力测试类 - 用于验证插件架构的正确性
final class AICapabilityTest {
    
    private let manager = AICapabilityManager.shared
    
    /// 运行快速测试
    static func runQuickTest() async {
        let test = AICapabilityTest()
        await test.setupTestEnvironment()
        await test.runBasicTests()
        test.printTestResults()
    }
    
    // MARK: - 测试环境设置
    
    private func setupTestEnvironment() async {
        print("🧪 AI能力测试开始")
        print("=" * 40)
        
        // 注册插件
        manager.register(plugin: MathCapabilityPlugin())
        manager.register(plugin: DeepThinkingPlugin())
        manager.register(plugin: ContentCapabilityPlugin())
        
        // 注册测试业务配置
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "test_001",
            businessName: "测试业务",
            enabledCapabilities: [.mathProblemGeneration, .deepThinking, .textSummary]
        ))
        
        print("✅ 测试环境设置完成")
    }
    
    // MARK: - 基础测试
    
    private func runBasicTests() async {
        print("\n🔬 开始基础功能测试")
        print("-" * 30)
        
        // 测试1：数学出题
        await testMathProblemGeneration()
        
        // 测试2：深度思考
        await testDeepThinking()
        
        // 测试3：文本摘要
        await testTextSummary()
        
        // 测试4：错误处理
        await testErrorHandling()
    }
    
    private func testMathProblemGeneration() async {
        print("\n📝 测试1：数学出题功能")
        
        let request = AICapabilityRequest(
            capabilityType: .mathProblemGeneration,
            input: .text("代数方程"),
            parameters: ["difficulty": "easy"]
        )
        
        do {
            let response = try await manager.execute(request: request, for: "test_001")
            print("   ✅ 数学出题测试通过")
            print("   📊 处理时间: \(String(format: "%.3f", response.processingTime))秒")
            
            if case .text(let result) = response.output {
                print("   📄 结果预览: \(result.prefix(50))...")
            }
        } catch {
            print("   ❌ 数学出题测试失败: \(error.localizedDescription)")
        }
    }
    
    private func testDeepThinking() async {
        print("\n🤔 测试2：深度思考功能")
        
        let request = AICapabilityRequest(
            capabilityType: .deepThinking,
            input: .text("人工智能的未来发展")
        )
        
        do {
            let response = try await manager.execute(request: request, for: "test_001")
            print("   ✅ 深度思考测试通过")
            print("   📊 处理时间: \(String(format: "%.3f", response.processingTime))秒")
            
            if let dimensions = response.metadata["dimensions"] as? Int {
                print("   🔍 分析维度: \(dimensions)个")
            }
        } catch {
            print("   ❌ 深度思考测试失败: \(error.localizedDescription)")
        }
    }
    
    private func testTextSummary() async {
        print("\n📝 测试3：文本摘要功能")
        
        let longText = """
        人工智能（Artificial Intelligence，AI）是计算机科学的一个分支，
        它企图了解智能的实质，并生产出一种新的能以人类智能相似的方式做出反应的智能机器。
        该领域的研究包括机器人、语言识别、图像识别、自然语言处理和专家系统等。
        人工智能从诞生以来，理论和技术日益成熟，应用领域也不断扩大。
        """
        
        let request = AICapabilityRequest(
            capabilityType: .textSummary,
            input: .text(longText)
        )
        
        do {
            let response = try await manager.execute(request: request, for: "test_001")
            print("   ✅ 文本摘要测试通过")
            print("   📊 处理时间: \(String(format: "%.3f", response.processingTime))秒")
            
            if let compressionRatio = response.metadata["compression_ratio"] as? Double {
                print("   📉 压缩比例: \(Int(compressionRatio * 100))%")
            }
        } catch {
            print("   ❌ 文本摘要测试失败: \(error.localizedDescription)")
        }
    }
    
    private func testErrorHandling() async {
        print("\n⚠️ 测试4：错误处理")
        
        // 测试未启用的能力
        let request = AICapabilityRequest(
            capabilityType: .imageGeneration, // 测试业务未启用此能力
            input: .text("测试图片")
        )
        
        do {
            let _ = try await manager.execute(request: request, for: "test_001")
            print("   ❌ 错误处理测试失败：应该抛出错误但没有")
        } catch AICapabilityError.unsupportedCapability(let type) {
            print("   ✅ 错误处理测试通过：正确识别未支持的能力 \(type.displayName)")
        } catch {
            print("   ⚠️ 错误处理测试部分通过：抛出了错误但类型不符合预期")
        }
        
        // 测试不存在的业务方
        do {
            let mathRequest = AICapabilityRequest(
                capabilityType: .mathProblemGeneration,
                input: .text("测试")
            )
            let _ = try await manager.execute(request: mathRequest, for: "nonexistent_business")
            print("   ❌ 业务验证测试失败：应该抛出认证错误但没有")
        } catch AICapabilityError.authenticationFailed {
            print("   ✅ 业务验证测试通过：正确识别不存在的业务方")
        } catch {
            print("   ⚠️ 业务验证测试部分通过：抛出了错误但类型不符合预期")
        }
    }
    
    // MARK: - 测试结果
    
    private func printTestResults() {
        print("\n" + "=" * 40)
        print("📊 测试结果统计")
        print("=" * 40)
        
        let stats = manager.getPluginStatistics()
        
        print("🔌 插件信息：")
        print("   注册插件数：\(stats["total_plugins"] ?? 0)")
        print("   支持能力数：\(stats["supported_capabilities"] ?? 0)")
        print("   能力覆盖率：\(String(format: "%.1f", (stats["coverage_rate"] as? Double ?? 0) * 100))%")
        
        print("\n🏢 业务配置：")
        print("   注册业务方：\(stats["registered_businesses"] ?? 0)")
        
        let availableCapabilities = manager.getAvailableCapabilities(for: "test_001")
        print("   测试业务可用能力：\(availableCapabilities.count)个")
        
        let combinations = manager.getCapabilityCombinations(for: "test_001")
        print("   推荐能力组合：\(combinations.count)个")
        
        print("\n✅ AI能力测试完成")
        print("=" * 40)
    }
}

// MARK: - String Extension

private extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
