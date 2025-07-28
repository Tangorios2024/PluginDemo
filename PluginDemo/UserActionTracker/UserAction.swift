//
//  UserAction.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

// 定义一个抽象的用户行为，使用 enum 保证类型安全
enum UserAction {
    case viewScreen(name: String)
    case tapButton(identifier: String)
    case purchase(productId: String, value: Double)
    case custom(name: String, properties: [String: Any])
}

// 插件可以访问的上下文信息
struct ActionContext {
    let timestamp: Date
    let userId: String?
    let sourceViewController: UIViewController?
    // 其他可能需要的全局信息，如设备ID, App版本等
    let deviceId: String?
    let appVersion: String?

    init(timestamp: Date = Date(),
         userId: String? = nil,
         sourceViewController: UIViewController? = nil,
         deviceId: String? = UIDevice.current.identifierForVendor?.uuidString,
         appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) {
        self.timestamp = timestamp
        self.userId = userId
        self.sourceViewController = sourceViewController
        self.deviceId = deviceId
        self.appVersion = appVersion
    }
}

// 插件契约协议
protocol ActionTrackerPlugin {
    /// 插件的唯一标识符，便于管理和调试
    var pluginId: String { get }

    /// **扩展点 1: 事件过滤**
    /// 插件可以选择是否对某个特定事件感兴趣，以优化性能。
    /// - Returns: `true` 如果插件需要处理此事件。
    func shouldTrack(action: UserAction, context: ActionContext) -> Bool

    /// **扩展点 2: 事件转换 (可选)**
    /// 在分发给所有插件前，允许插件修改或丰富事件本身。
    /// 例如，一个 A/B 测试插件可以为所有事件附加实验组信息。
    /// - Returns: 修改后的 UserAction，如果不想修改则返回原始 action。
    func transform(action: UserAction, context: ActionContext) -> UserAction

    /// **扩展点 3: 事件处理**
    /// 插件的核心逻辑，执行实际的追踪操作，如调用第三方 SDK。
    func track(action: UserAction, context: ActionContext)
}

// 提供默认实现，简化插件的编写
extension ActionTrackerPlugin {
    // 默认处理所有事件
    func shouldTrack(action: UserAction, context: ActionContext) -> Bool {
        return true
    }
    // 默认不转换事件
    func transform(action: UserAction, context: ActionContext) -> UserAction {
        return action
    }
}
