//
//  UserActionTrackerProtocol.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

/// UserActionTracker 服务协议
protocol UserActionTrackerProtocol {
    /// 注册插件
    func register(plugin: ActionTrackerPlugin)
    
    /// 追踪用户行为
    func track(_ action: UserAction, from viewController: UIViewController?, userId: String?)
}

// 让现有的 UserActionTracker 遵循协议
extension UserActionTracker: UserActionTrackerProtocol {
    // 已经实现了所需的方法
}
