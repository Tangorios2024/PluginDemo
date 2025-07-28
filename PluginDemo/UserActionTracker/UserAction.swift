//
//  UserAction.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

// 定义用户行为，使用 enum 可以类型安全地传递参数
enum UserAction {
    case purchase(itemId: String, price: Double)
    case share(contentId: String, platform: String)
    case viewScreen(screenName: String)
    case custom(name: String, parameters: [String: Any])
}

// 定义一个上下文对象，用于传递宿主环境的信息给插件
// 例如，插件可能需要当前的 ViewController 来弹窗
struct ActionContext {
    let sourceViewController: UIViewController?
}

// 插件协议 (The Contract)
protocol ActionTrackerPlugin {
    // 插件的唯一标识符，便于管理
    var pluginId: String { get }

    // 插件可以选择是否处理某个行为，提高效率
    func shouldTrack(action: UserAction) -> Bool

    // 核心处理方法
    func track(action: UserAction, context: ActionContext)
}

// 为 `shouldTrack` 提供一个默认实现，默认所有事件都处理
extension ActionTrackerPlugin {
    func shouldTrack(action: UserAction) -> Bool {
        return true
    }
}
