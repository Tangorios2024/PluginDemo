//
//  BankTokenAuthPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

/// 银行令牌认证插件 - 用于银行客户的简化认证
final class BankTokenAuthPlugin: LLMPlugin {
    let pluginId: String = "com.bank.token_auth"
    let priority: Int = 10

    // 有效的银行令牌列表
    private let validTokens: Set<String> = [
        "BANK_TOKEN_DEMO_001",
        "BANK_TOKEN_VIP_002",
        "BANK_TOKEN_CORP_003"
    ]

    func authenticate(context: LLMContext) async throws {
        print("\(pluginId): Starting bank token authentication")

        // 从请求元数据中获取银行令牌
        guard let bankToken = context.originalRequest.metadata["bank_token"] as? String else {
            throw LLMPipelineError.authenticationFailed("Missing bank_token in request metadata")
        }

        // 验证令牌格式
        if !bankToken.hasPrefix("BANK_TOKEN_") {
            throw LLMPipelineError.authenticationFailed("Invalid bank token format")
        }

        // 验证令牌有效性
        if !validTokens.contains(bankToken) {
            print("\(pluginId): Invalid bank token: \(bankToken)")
            throw LLMPipelineError.authenticationFailed("Invalid or expired bank token")
        }

        // 从令牌中提取客户信息
        let customerInfo = extractCustomerInfo(from: bankToken)

        // 记录认证成功信息
        context.sharedData["auth_method"] = "BANK_TOKEN"
        context.sharedData["bank_token"] = bankToken
        context.sharedData["customer_id"] = customerInfo.customerId
        context.sharedData["customer_level"] = customerInfo.level
        context.sharedData["branch_code"] = customerInfo.branchCode
        context.sharedData["client_authenticated"] = true

        print("\(pluginId): Bank token authentication successful")
        print("\(pluginId): Customer: \(customerInfo.customerId), Level: \(customerInfo.level), Branch: \(customerInfo.branchCode)")
    }

    private func extractCustomerInfo(from token: String) -> CustomerInfo {
        // 模拟从令牌中提取客户信息
        switch token {
        case "BANK_TOKEN_DEMO_001":
            return CustomerInfo(
                customerId: "CUST_001",
                level: "普通客户",
                branchCode: "BJ001",
                accountType: "储蓄账户"
            )
        case "BANK_TOKEN_VIP_002":
            return CustomerInfo(
                customerId: "VIP_002",
                level: "VIP客户",
                branchCode: "SH002",
                accountType: "理财账户"
            )
        case "BANK_TOKEN_CORP_003":
            return CustomerInfo(
                customerId: "CORP_003",
                level: "企业客户",
                branchCode: "GZ003",
                accountType: "企业账户"
            )
        default:
            return CustomerInfo(
                customerId: "UNKNOWN",
                level: "未知",
                branchCode: "000",
                accountType: "未知"
            )
        }
    }
}

// MARK: - Customer Info Model

struct CustomerInfo {
    let customerId: String
    let level: String
    let branchCode: String
    let accountType: String
}
