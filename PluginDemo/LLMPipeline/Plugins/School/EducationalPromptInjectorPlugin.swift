//
//  EducationalPromptInjectorPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 教育提示词注入插件 - 用于学校客户的教学引导
final class EducationalPromptInjectorPlugin: LLMPlugin {
    let pluginId: String = "com.school.educational_prompt_injector"
    let priority: Int = 20
    
    func processRequest(context: LLMContext) async throws {
        print("\(pluginId): Injecting educational prompts")
        
        // 获取用户信息
        guard let userRole = context.sharedData["user_role"] as? String,
              let grade = context.sharedData["grade"] as? String else {
            print("\(pluginId): User information not found, using default educational prompt")
            return
        }
        
        // 根据用户角色和年级选择合适的教学风格
        let educationalPrompt = generateEducationalPrompt(role: userRole, grade: grade)
        
        // 注入教育提示词
        let originalPrompt = context.processedRequest.prompt
        let enhancedPrompt = educationalPrompt + "\n\n学生问题：" + originalPrompt
        
        // 更新处理后的请求
        var updatedMetadata = context.processedRequest.metadata
        updatedMetadata["educational_prompt_injected"] = true
        updatedMetadata["teaching_style"] = getTeachingStyle(role: userRole, grade: grade)
        updatedMetadata["original_prompt_length"] = originalPrompt.count
        updatedMetadata["enhanced_prompt_length"] = enhancedPrompt.count
        
        context.processedRequest = LLMRequest(
            prompt: enhancedPrompt,
            parameters: context.processedRequest.parameters,
            metadata: updatedMetadata
        )
        
        // 记录注入信息
        context.sharedData["prompt_enhanced"] = true
        context.sharedData["teaching_style"] = getTeachingStyle(role: userRole, grade: grade)
        
        print("\(pluginId): Educational prompt injected successfully")
        print("\(pluginId): Teaching style: \(getTeachingStyle(role: userRole, grade: grade))")
        print("\(pluginId): Enhanced prompt length: \(enhancedPrompt.count) characters")
    }
    
    private func generateEducationalPrompt(role: String, grade: String) -> String {
        switch (role, grade) {
        case ("student", "high_school"):
            return """
            你是一位耐心的高中老师，擅长用生动的例子和循序渐进的方式解释复杂概念。
            请用以下方式回答学生的问题：
            1. 首先用简单的语言概括核心概念
            2. 提供具体的例子或类比来帮助理解
            3. 引导学生思考相关的问题
            4. 鼓励学生进一步探索和学习
            
            记住要保持鼓励和支持的语调，激发学生的学习兴趣。
            """
            
        case ("student", "undergraduate"):
            return """
            你是一位博学的大学教授，善于用苏格拉底式提问法引导学生深入思考。
            请按照以下方式回答：
            1. 分析问题的核心要素
            2. 提出引导性问题帮助学生思考
            3. 提供多个角度的分析
            4. 建议相关的学习资源和延伸阅读
            
            鼓励批判性思维和独立思考，培养学生的学术素养。
            """
            
        case ("teacher", _):
            return """
            你是一位经验丰富的教育专家，专门为教师提供教学指导和建议。
            请从教学角度回答问题：
            1. 提供教学方法和策略建议
            2. 分析学生可能遇到的困难点
            3. 建议相关的教学资源和工具
            4. 考虑不同学习风格的学生需求
            
            重点关注如何有效传授知识和提高学生参与度。
            """
            
        default:
            return """
            你是一位循循善诱的导师，善于根据学习者的水平调整教学方式。
            请用启发式的方法回答问题：
            1. 从基础概念开始解释
            2. 逐步深入到复杂内容
            3. 提供实际应用的例子
            4. 鼓励主动学习和思考
            
            保持耐心和鼓励，帮助学习者建立信心。
            """
        }
    }
    
    private func getTeachingStyle(role: String, grade: String) -> String {
        switch (role, grade) {
        case ("student", "high_school"):
            return "high_school_supportive"
        case ("student", "undergraduate"):
            return "university_socratic"
        case ("teacher", _):
            return "teacher_guidance"
        default:
            return "adaptive_mentoring"
        }
    }
    
    func processResponse(context: LLMContext) async throws {
        print("\(pluginId): Processing educational response")
        
        guard let response = context.finalResponse else {
            print("\(pluginId): No response to process")
            return
        }
        
        // 为响应添加学习建议
        let learningTips = generateLearningTips(context: context)
        let enhancedContent = response.content + "\n\n" + learningTips
        
        // 更新响应元数据
        var updatedMetadata = response.metadata
        updatedMetadata["learning_tips_added"] = true
        updatedMetadata["educational_enhancement"] = true
        
        context.finalResponse = LLMResponse(
            content: enhancedContent,
            metadata: updatedMetadata,
            processingTime: response.processingTime
        )
        
        print("\(pluginId): Educational response enhancement completed")
    }
    
    private func generateLearningTips(context: LLMContext) -> String {
        guard let teachingStyle = context.sharedData["teaching_style"] as? String else {
            return generateDefaultLearningTips()
        }
        
        switch teachingStyle {
        case "high_school_supportive":
            return """
            📚 学习小贴士：
            • 尝试用自己的话重新表述这个概念
            • 寻找生活中的相关例子
            • 与同学讨论交流不同的理解
            • 如有疑问，随时向老师请教
            """
            
        case "university_socratic":
            return """
            🎓 深入思考：
            • 这个概念与你之前学过的知识有什么联系？
            • 你能想到哪些反例或特殊情况？
            • 如何将这个理论应用到实际问题中？
            • 推荐阅读相关的学术文献进一步探索
            """
            
        case "teacher_guidance":
            return """
            👨‍🏫 教学建议：
            • 考虑使用多媒体资源增强教学效果
            • 设计互动环节提高学生参与度
            • 准备不同难度的练习题
            • 关注学生的反馈和理解程度
            """
            
        default:
            return generateDefaultLearningTips()
        }
    }
    
    private func generateDefaultLearningTips() -> String {
        return """
        💡 学习建议：
        • 主动思考和提问
        • 将新知识与已有知识建立联系
        • 通过实践加深理解
        • 保持好奇心和学习热情
        """
    }
}
