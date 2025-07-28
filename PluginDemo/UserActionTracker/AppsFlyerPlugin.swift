//
//  AppsFlyerPlugin.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation

class AppsFlyerPlugin: ActionTrackerPlugin {
    let pluginId: String = "com.myapp.appsflyer"

    // 这个插件只关心购买和分享事件
    func shouldTrack(action: UserAction) -> Bool {
        if case .purchase = action { return true }
        if case .share = action { return true }
        return false
    }

    func track(action: UserAction, context: ActionContext) {
        switch action {
        case .purchase(let itemId, let price):
            // AppsFlyer.shared.logEvent(AFEventPurchase, withValues: [...])
            print("AppsFlyerPlugin: Logged purchase for item \(itemId) with price \(price)")
        case .share(let contentId, _):
            // AppsFlyer.shared.logEvent("af_share", withValues: ["content_id": contentId])
            print("AppsFlyerPlugin: Logged share for content \(contentId)")
        default:
            // 因为 shouldTrack 的存在，这里理论上不会被调用
            break
        }
    }
}
