//
//  AppsFlyerPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

class AppsFlyerPlugin: ActionTrackerPlugin {
    let pluginId: String = "com.myapp.appsflyer"

    // 这个插件只关心购买事件
    func shouldTrack(action: UserAction, context: ActionContext) -> Bool {
        if case .purchase = action { return true }
        return false
    }

    func track(action: UserAction, context: ActionContext) {
        switch action {
        case .purchase(let productId, let value):
            // AppsFlyer.shared.logEvent(AFEventPurchase, withValues: [...])
            print("AppsFlyerPlugin: Logged purchase for product \(productId) with value \(value)")
        default:
            // 因为 shouldTrack 的存在，这里理论上不会被调用
            break
        }
    }
}
