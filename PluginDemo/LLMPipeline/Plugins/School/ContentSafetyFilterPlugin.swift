//
//  ContentSafetyFilterPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 内容安全过滤插件 - 用于学校客户的内容安全检查
final class ContentSafetyFilterPlugin: LLMPlugin {
    let pluginId: String = "com.school.content_safety_filter"
    let priority: Int = 30
    
    // 不当内容关键词
    private let inappropriateKeywords = [
        // 暴力相关
        "暴力", "打架", "伤害", "攻击", "武器",
        // 不当言论
        "歧视", "仇恨", "种族", "性别歧视",
        // 成人内容
        "色情", "性", "裸体", "成人",
        // 危险行为
        "自杀", "自残", "毒品", "酒精", "吸烟",
        // 其他不当内容
        "欺凌", "霸凌", "作弊", "抄袭"
    ]
    
    // 积极正面的替代词汇
    private let positiveAlternatives: [String: String] = [
        "暴力": "和平解决冲突",
        "打架": "友好沟通",
        "歧视": "包容理解",
        "仇恨": "友爱互助",
        "欺凌": "友善相处",
        "作弊": "诚信学习"
    ]
    
    func processRequest(context: LLMContext) async throws {
        print("\(pluginId): Checking request content safety")
        
        let prompt = context.processedRequest.prompt.lowercased()
        var safetyIssues: [String] = []
        
        // 检查不当内容
        for keyword in inappropriateKeywords {
            if prompt.contains(keyword) {
                safetyIssues.append(keyword)
            }
        }
        
        if !safetyIssues.isEmpty {
            print("\(pluginId): Safety issues detected: \(safetyIssues)")
            
            // 记录安全问题
            context.sharedData["safety_issues"] = safetyIssues
            context.sharedData["content_filtered"] = true
            
            // 根据学校政策决定是否阻止请求
            let userRole = context.sharedData["user_role"] as? String ?? "unknown"
            let grade = context.sharedData["grade"] as? String ?? "unknown"
            
            if shouldBlockContent(issues: safetyIssues, userRole: userRole, grade: grade) {
                let errorMessage = "Content contains inappropriate material for educational environment: \(safetyIssues.joined(separator: ", "))"
                throw LLMPipelineError.contentViolation(errorMessage)
            } else {
                // 不阻止但添加警告
                context.sharedData["content_warning"] = true
                print("\(pluginId): Content warning added, but request allowed to proceed")
            }
        }
        
        // 检查是否包含学术诚信相关问题
        checkAcademicIntegrity(context: context)
        
        print("\(pluginId): Request content safety check completed")
    }
    
    func processResponse(context: LLMContext) async throws {
        print("\(pluginId): Filtering response content")
        
        guard let response = context.finalResponse else {
            print("\(pluginId): No response to filter")
            return
        }
        
        var filteredContent = response.content
        var contentModified = false
        
        // 过滤响应中的不当内容
        for keyword in inappropriateKeywords {
            if filteredContent.lowercased().contains(keyword) {
                if let alternative = positiveAlternatives[keyword] {
                    filteredContent = filteredContent.replacingOccurrences(
                        of: keyword,
                        with: alternative,
                        options: .caseInsensitive
                    )
                    contentModified = true
                    print("\(pluginId): Replaced '\(keyword)' with '\(alternative)'")
                }
            }
        }
        
        // 添加教育性的安全提醒
        if context.sharedData["content_warning"] as? Bool == true {
            let safetyReminder = generateSafetyReminder(context: context)
            filteredContent = filteredContent + "\n\n" + safetyReminder
            contentModified = true
        }
        
        // 更新响应
        if contentModified {
            var updatedMetadata = response.metadata
            updatedMetadata["content_filtered"] = true
            updatedMetadata["safety_filter_applied"] = true
            
            context.finalResponse = LLMResponse(
                content: filteredContent,
                metadata: updatedMetadata,
                processingTime: response.processingTime
            )
            
            print("\(pluginId): Response content filtered and safety reminders added")
        } else {
            print("\(pluginId): No content filtering needed")
        }
    }
    
    private func shouldBlockContent(issues: [String], userRole: String, grade: String) -> Bool {
        // 对于高中以下学生，更严格的过滤
        if grade == "high_school" || grade == "middle_school" || grade == "elementary" {
            return !issues.isEmpty
        }
        
        // 对于大学生和教师，只阻止严重的不当内容
        let seriousIssues = ["暴力", "色情", "自杀", "毒品"]
        return issues.contains { seriousIssues.contains($0) }
    }
    
    private func checkAcademicIntegrity(context: LLMContext) {
        let prompt = context.processedRequest.prompt.lowercased()
        
        // 检查可能的学术不诚信行为
        let academicIntegrityKeywords = [
            "帮我写作业", "代写", "答案是什么", "直接给我答案",
            "考试答案", "作业答案", "帮我完成", "替我做"
        ]
        
        for keyword in academicIntegrityKeywords {
            if prompt.contains(keyword) {
                context.sharedData["academic_integrity_concern"] = true
                context.sharedData["integrity_keyword"] = keyword
                print("\(pluginId): Academic integrity concern detected: \(keyword)")
                break
            }
        }
    }
    
    private func generateSafetyReminder(context: LLMContext) -> String {
        let userRole = context.sharedData["user_role"] as? String ?? "student"
        let grade = context.sharedData["grade"] as? String ?? "unknown"
        
        var reminder = "🛡️ 安全提醒："
        
        if let academicConcern = context.sharedData["academic_integrity_concern"] as? Bool, academicConcern {
            reminder += """
            
            
            📚 学术诚信提醒：
            • 学习的目的是理解和掌握知识，而不是获得答案
            • 独立思考和解决问题是重要的学习技能
            • 如需帮助，请寻求老师或同学的指导，而非直接答案
            • 诚信是学术研究和个人发展的基石
            """
        }
        
        if let safetyIssues = context.sharedData["safety_issues"] as? [String], !safetyIssues.isEmpty {
            reminder += """
            
            
            🌟 正面引导：
            • 遇到困难时，寻求积极正面的解决方案
            • 与老师、家长或心理咨询师交流
            • 培养健康的兴趣爱好和社交关系
            • 记住：每个问题都有积极的解决方式
            """
        }
        
        // 根据年级添加特定提醒
        switch grade {
        case "high_school":
            reminder += """
            
            
            🎓 高中生特别提醒：
            • 专注于学业和个人发展
            • 培养批判性思维和独立判断能力
            • 如有心理压力，及时寻求帮助
            """
        case "undergraduate":
            reminder += """
            
            
            🎓 大学生特别提醒：
            • 保持学术诚信和道德标准
            • 发展专业技能和社会责任感
            • 建立健康的学习和生活习惯
            """
        default:
            break
        }
        
        return reminder
    }
    
    func audit(context: LLMContext) async {
        print("\(pluginId): Recording content safety audit")
        
        let safetyAudit = ContentSafetyAudit(
            requestId: context.originalRequest.requestId,
            userId: context.sharedData["user_id"] as? String ?? "unknown",
            userRole: context.sharedData["user_role"] as? String ?? "unknown",
            safetyIssues: context.sharedData["safety_issues"] as? [String] ?? [],
            contentFiltered: context.sharedData["content_filtered"] as? Bool ?? false,
            academicIntegrityConcern: context.sharedData["academic_integrity_concern"] as? Bool ?? false,
            timestamp: Date()
        )
        
        // 在实际应用中，这些审计记录会存储到安全数据库中
        print("\(pluginId): Safety audit - Issues: \(safetyAudit.safetyIssues.count), Filtered: \(safetyAudit.contentFiltered)")
        
        if safetyAudit.academicIntegrityConcern {
            print("\(pluginId): Academic integrity concern logged for user \(safetyAudit.userId)")
        }
    }
}

// MARK: - Content Safety Audit Model

struct ContentSafetyAudit {
    let requestId: String
    let userId: String
    let userRole: String
    let safetyIssues: [String]
    let contentFiltered: Bool
    let academicIntegrityConcern: Bool
    let timestamp: Date
}
