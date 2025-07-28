//
//  UserActionTracker.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

// 宿主系统 (The Host)
final class UserActionTracker {
    
    // 单例模式，方便全局访问
    static let shared = UserActionTracker()
    
    // 插件管理器：一个简单的插件数组
    private var plugins: [ActionTrackerPlugin] = []

    private init() {} // 私有化构造器

    // 注册插件
    func register(plugin: ActionTrackerPlugin) {
        // 防止重复注册
        if !plugins.contains(where: { $0.pluginId == plugin.pluginId }) {
            plugins.append(plugin)
            print("ActionTracker: Registered plugin '\(plugin.pluginId)'")
        }
    }

    // 核心分发方法 (扩展点)
    func track(_ action: UserAction, from viewController: UIViewController? = nil, userId: String? = nil) {
        let context = ActionContext(userId: userId, sourceViewController: viewController)

        print("ActionTracker: Tracking action \(action)")

        // 第一阶段：事件转换 (Transform Phase)
        var transformedAction = action
        for plugin in plugins {
            if plugin.shouldTrack(action: transformedAction, context: context) {
                transformedAction = plugin.transform(action: transformedAction, context: context)
            }
        }

        print("ActionTracker: Transformed action \(transformedAction)")

        // 第二阶段：事件处理 (Track Phase)
        for plugin in plugins {
            if plugin.shouldTrack(action: transformedAction, context: context) {
                plugin.track(action: transformedAction, context: context)
            }
        }
    }
}
