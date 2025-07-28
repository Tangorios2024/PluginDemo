//
//  EducationScenarioDemo.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 智慧教育场景演示 - 展示两个具体的教育应用场景
final class EducationScenarioDemo {
    
    private let manager = AICapabilityManager.shared
    
    /// 运行教育场景演示
    static func runEducationScenarios() async {
        let demo = EducationScenarioDemo()
        await demo.setupEducationEnvironment()
        await demo.demonstrateScenario1_SmartLearningAssistant()
        await demo.demonstrateScenario2_InteractiveStoryTelling()
        demo.showEducationSummary()
    }
    
    // MARK: - 环境设置
    
    private func setupEducationEnvironment() async {
        print("🎓 智慧教育平台场景演示")
        print("=" * 50)
        
        // 注册教育相关插件
        print("\n📦 注册教育专用插件...")
        manager.register(plugin: MathCapabilityPlugin())
        manager.register(plugin: ContentCapabilityPlugin()) // OCR, 文本摘要
        manager.register(plugin: NetworkCapabilityPlugin()) // 音视频通话
        manager.register(plugin: EducationCapabilityPlugin()) // 数据分析, 用户画像
        manager.register(plugin: ContentRecommendationPlugin()) // 内容推荐, 故事生成
        manager.register(plugin: InteractionCapabilityPlugin()) // TTS, 对话交互
        manager.register(plugin: AdvancedTTSPlugin()) // 高级TTS (更高优先级)
        
        // 注册智慧教育平台配置
        manager.register(businessConfiguration: BusinessConfiguration(
            businessId: "smart_edu_001",
            businessName: "智慧教育平台",
            enabledCapabilities: [
                // 场景1：智能学习助手
                .mathProblemGeneration, .mathProblemSolving, .ocr, .dataAnalysis, .textSummary, .videoCall,
                // 场景2：互动故事推荐
                .userProfiling, .contentRecommendation, .storyGeneration, .tts, .dialogueInteraction
            ],
            quotaLimits: [:], // 教育平台无限制
            customParameters: [
                "education_level": "primary_school",
                "age_range": "6-12",
                "learning_mode": "interactive",
                "safety_level": "high"
            ]
        ))
        
        print("✅ 教育环境设置完成")
    }
    
    // MARK: - 场景1：智能学习助手
    
    private func demonstrateScenario1_SmartLearningAssistant() async {
        print("\n" + "=" * 50)
        print("📚 场景1：智能学习助手")
        print("=" * 50)
        print("功能：智能出题 → 拍照识别 → 解答分析 → 错题收集 → 学习周报 → 一对一讲解")
        
        // 步骤1：智能出题
        await executeCapabilityStep(
            stepName: "智能出题",
            capabilityType: .mathProblemGeneration,
            input: .text("小学四年级数学 - 分数运算"),
            parameters: ["difficulty": "medium", "count": 3, "topic": "分数"]
        )
        
        // 步骤2：拍照识别题目 (OCR)
        await executeCapabilityStep(
            stepName: "拍照识别题目",
            capabilityType: .ocr,
            input: .image(Data()), // 模拟图片数据
            parameters: ["image_type": "math_problem", "enhance": true]
        )
        
        // 步骤3：智能解答
        await executeCapabilityStep(
            stepName: "智能解答",
            capabilityType: .mathProblemSolving,
            input: .text("计算：3/4 + 1/2 = ?"),
            parameters: ["show_steps": true, "difficulty_analysis": true]
        )
        
        // 步骤4：学习数据分析
        await executeCapabilityStep(
            stepName: "学习数据分析",
            capabilityType: .dataAnalysis,
            input: .structured([
                "analysis_type": "learning_progress",
                "student_id": "student_001",
                "time_period": "last_week",
                "subjects": ["math"],
                "wrong_answers": [
                    ["question": "3/4 + 1/2", "student_answer": "4/6", "correct_answer": "5/4"],
                    ["question": "2/3 × 3/4", "student_answer": "6/12", "correct_answer": "1/2"]
                ]
            ]),
            parameters: ["include_recommendations": true]
        )
        
        // 步骤5：生成学习周报
        await executeCapabilityStep(
            stepName: "生成学习周报",
            capabilityType: .textSummary,
            input: .text("本周学习数据：完成练习45道，正确率78%，主要错误在分数运算..."),
            parameters: ["summary_type": "weekly_report", "target_audience": "student_parent"]
        )
        
        // 步骤6：一对一视频讲解
        await executeCapabilityStep(
            stepName: "一对一视频讲解",
            capabilityType: .videoCall,
            input: .structured([
                "target_user": "teacher_001",
                "call_type": "video",
                "session_type": "tutoring",
                "subject": "math_fractions"
            ]),
            parameters: ["recording": true, "whiteboard": true]
        )
        
        print("\n✅ 场景1演示完成：智能学习助手全流程")
    }
    
    // MARK: - 场景2：互动故事推荐
    
    private func demonstrateScenario2_InteractiveStoryTelling() async {
        print("\n" + "=" * 50)
        print("📖 场景2：互动故事推荐")
        print("=" * 50)
        print("功能：用户画像 → 故事推荐 → 个性化生成 → 语音合成 → 智能交互")
        
        // 步骤1：构建用户画像
        await executeCapabilityStep(
            stepName: "构建用户画像",
            capabilityType: .userProfiling,
            input: .structured([
                "age": 8,
                "reading_level": "intermediate",
                "interests": ["太空", "动物", "科学"],
                "learning_history": [
                    "completed_stories": 15,
                    "favorite_genres": ["adventure", "science"],
                    "interaction_preference": "high"
                ],
                "vocabulary_level": 2500
            ]),
            parameters: ["profile_depth": "comprehensive"]
        )
        
        // 步骤2：个性化内容推荐
        await executeCapabilityStep(
            stepName: "个性化内容推荐",
            capabilityType: .contentRecommendation,
            input: .structured([
                "age": 8,
                "interests": ["太空", "动物", "科学"],
                "reading_level": "intermediate",
                "session_time": "evening",
                "mood": "curious"
            ]),
            parameters: ["recommendation_count": 5, "diversity": true]
        )
        
        // 步骤3：生成个性化故事
        await executeCapabilityStep(
            stepName: "生成个性化故事",
            capabilityType: .storyGeneration,
            input: .structured([
                "theme": "太空探险",
                "character_name": "小星",
                "story_length": "medium",
                "educational_elements": ["天文知识", "友谊", "勇气"],
                "interaction_points": 3
            ]),
            parameters: ["age_appropriate": true, "educational_value": "high"]
        )
        
        // 步骤4：语音合成 (TTS)
        await executeCapabilityStep(
            stepName: "语音合成",
            capabilityType: .tts,
            input: .text("小星是一个对宇宙充满好奇心的小朋友。一天晚上，他在观察星空时发现了一颗特别亮的星星..."),
            parameters: [
                "voice_settings": [
                    "voice_type": "child_friendly",
                    "speech_rate": "normal",
                    "emotion": "cheerful",
                    "background_music": "gentle"
                ]
            ]
        )
        
        // 步骤5：智能交互对话
        await executeCapabilityStep(
            stepName: "智能交互对话",
            capabilityType: .dialogueInteraction,
            input: .structured([
                "user_input": "我想知道小星会遇到什么外星朋友",
                "context": "story_telling",
                "story_progress": "middle",
                "user_emotion": "excited",
                "previous_choices": ["选择了勇敢探索"]
            ]),
            parameters: ["response_style": "encouraging", "educational_guidance": true]
        )
        
        print("\n✅ 场景2演示完成：互动故事推荐全流程")
    }
    
    // MARK: - 辅助方法
    
    private func executeCapabilityStep(
        stepName: String,
        capabilityType: AICapabilityType,
        input: AIInput,
        parameters: [String: Any] = [:]
    ) async {
        print("\n🔄 执行步骤：\(stepName)")
        print("   能力类型：\(capabilityType.displayName)")
        
        let request = AICapabilityRequest(
            capabilityType: capabilityType,
            input: input,
            parameters: parameters
        )
        
        do {
            let response = try await manager.execute(request: request, for: "smart_edu_001")
            print("   ✅ 执行成功 - 处理时间: \(String(format: "%.3f", response.processingTime))秒")
            
            // 显示部分结果
            if case .text(let result) = response.output {
                let preview = result.components(separatedBy: "\n").prefix(3).joined(separator: "\n")
                print("   📄 结果预览: \(preview)...")
            }
            
            // 显示元数据
            if !response.metadata.isEmpty {
                print("   📊 元数据: \(response.metadata.keys.joined(separator: ", "))")
            }
            
        } catch {
            print("   ❌ 执行失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 总结
    
    private func showEducationSummary() {
        print("\n" + "=" * 50)
        print("📊 智慧教育平台总结")
        print("=" * 50)
        
        let availableCapabilities = manager.getAvailableCapabilities(for: "smart_edu_001")
        let combinations = manager.getCapabilityCombinations(for: "smart_edu_001")
        
        print("\n🎯 平台能力概览：")
        print("   总可用能力：\(availableCapabilities.count)个")
        print("   能力列表：\(availableCapabilities.map { $0.displayName }.joined(separator: "、"))")
        
        print("\n🔗 智能能力组合：")
        print("   推荐组合数：\(combinations.count)个")
        
        // 显示教育场景专用组合
        let educationCombinations = [
            "场景1 - 智能学习助手": [
                AICapabilityType.mathProblemGeneration,
                .ocr,
                .mathProblemSolving,
                .dataAnalysis,
                .textSummary,
                .videoCall
            ],
            "场景2 - 互动故事推荐": [
                AICapabilityType.userProfiling,
                .contentRecommendation,
                .storyGeneration,
                .tts,
                .dialogueInteraction
            ]
        ]
        
        for (scenarioName, capabilities) in educationCombinations {
            print("   \(scenarioName):")
            print("     \(capabilities.map { $0.displayName }.joined(separator: " → "))")
        }
        
        print("\n🌟 教育价值：")
        print("   • 个性化学习：基于用户画像提供定制化内容")
        print("   • 智能辅导：AI驱动的学习分析和指导")
        print("   • 互动体验：多模态交互提升学习兴趣")
        print("   • 全程跟踪：从学习到反馈的闭环管理")
        
        print("\n✅ 智慧教育平台演示完成")
        print("=" * 50)
    }
}

// MARK: - String Extension

private extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
