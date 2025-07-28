//
//  ABTestPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

class ABTestPlugin: ActionTrackerPlugin {
    let pluginId: String = "com.myapp.abtest"
    
    // A/B 测试插件主要通过 transform 扩展点工作
    func transform(action: UserAction, context: ActionContext) -> UserAction {
        // 模拟获取用户的实验组信息
        let experimentGroup = getExperimentGroup(for: context.userId)
        
        print("ABTestPlugin: Adding experiment group '\(experimentGroup)' to action")
        
        switch action {
        case .custom(let name, var properties):
            // 为自定义事件添加实验组信息
            properties["experiment_group"] = experimentGroup
            properties["experiment_timestamp"] = context.timestamp.timeIntervalSince1970
            return .custom(name: name, properties: properties)
            
        case .purchase(let productId, let value):
            // 为购买事件创建带有实验组信息的自定义事件
            let properties: [String: Any] = [
                "product_id": productId,
                "value": value,
                "experiment_group": experimentGroup,
                "experiment_timestamp": context.timestamp.timeIntervalSince1970
            ]
            return .custom(name: "purchase_with_experiment", properties: properties)
            
        case .viewScreen(let name):
            // 为页面浏览事件添加实验组信息
            let properties: [String: Any] = [
                "screen_name": name,
                "experiment_group": experimentGroup,
                "experiment_timestamp": context.timestamp.timeIntervalSince1970
            ]
            return .custom(name: "screen_view_with_experiment", properties: properties)
            
        case .tapButton(let identifier):
            // 为按钮点击事件添加实验组信息
            let properties: [String: Any] = [
                "button_id": identifier,
                "experiment_group": experimentGroup,
                "experiment_timestamp": context.timestamp.timeIntervalSince1970
            ]
            return .custom(name: "button_tap_with_experiment", properties: properties)
        }
    }
    
    func track(action: UserAction, context: ActionContext) {
        // A/B 测试插件通常不直接处理事件，而是通过 transform 来丰富数据
        // 但这里可以记录一些内部统计信息
        print("ABTestPlugin: Processed action for user \(context.userId ?? "anonymous")")
    }
    
    // MARK: - Private Methods
    
    private func getExperimentGroup(for userId: String?) -> String {
        // 模拟 A/B 测试分组逻辑
        guard let userId = userId else {
            return "control" // 未登录用户默认为对照组
        }
        
        // 简单的哈希分组算法
        let hash = abs(userId.hashValue)
        let group = hash % 3
        
        switch group {
        case 0:
            return "control"
        case 1:
            return "variant_a"
        case 2:
            return "variant_b"
        default:
            return "control"
        }
    }
}
