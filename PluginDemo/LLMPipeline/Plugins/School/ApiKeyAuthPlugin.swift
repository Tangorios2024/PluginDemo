//
//  ApiKeyAuthPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// API Key 认证插件 - 用于学校客户的简单认证
final class ApiKeyAuthPlugin: LLMPlugin {
    let pluginId: String = "com.school.api_key_auth"
    let priority: Int = 10
    
    private let validApiKeys: Set<String>
    
    init(validApiKeys: Set<String> = ["school_demo_key_123", "edu_api_key_456", "student_access_789"]) {
        self.validApiKeys = validApiKeys
    }
    
    func authenticate(context: LLMContext) async throws {
        print("\(pluginId): Starting API Key authentication")
        
        // 从请求元数据中获取 API Key
        guard let apiKey = context.originalRequest.metadata["api_key"] as? String else {
            throw LLMPipelineError.authenticationFailed("Missing API key in request metadata")
        }
        
        // 验证 API Key
        if !validApiKeys.contains(apiKey) {
            print("\(pluginId): Invalid API key: \(apiKey)")
            throw LLMPipelineError.authenticationFailed("Invalid API key")
        }
        
        // 从 API Key 中提取用户信息（模拟）
        let userInfo = extractUserInfo(from: apiKey)
        
        // 记录认证成功信息
        context.sharedData["auth_method"] = "API_KEY"
        context.sharedData["api_key"] = apiKey
        context.sharedData["user_id"] = userInfo.userId
        context.sharedData["user_role"] = userInfo.role
        context.sharedData["school_id"] = userInfo.schoolId
        context.sharedData["client_authenticated"] = true
        
        print("\(pluginId): API Key authentication successful")
        print("\(pluginId): User: \(userInfo.userId), Role: \(userInfo.role), School: \(userInfo.schoolId)")
    }
    
    private func extractUserInfo(from apiKey: String) -> UserInfo {
        // 模拟从 API Key 中提取用户信息
        // 在实际应用中，这可能涉及数据库查询或 JWT 解析
        
        switch apiKey {
        case "school_demo_key_123":
            return UserInfo(
                userId: "student_001",
                role: "student",
                schoolId: "demo_university",
                grade: "undergraduate"
            )
        case "edu_api_key_456":
            return UserInfo(
                userId: "teacher_001",
                role: "teacher",
                schoolId: "demo_university",
                grade: "faculty"
            )
        case "student_access_789":
            return UserInfo(
                userId: "student_002",
                role: "student",
                schoolId: "demo_high_school",
                grade: "high_school"
            )
        default:
            return UserInfo(
                userId: "unknown",
                role: "guest",
                schoolId: "unknown",
                grade: "unknown"
            )
        }
    }
}

// MARK: - User Info Model

struct UserInfo {
    let userId: String
    let role: String
    let schoolId: String
    let grade: String
}
