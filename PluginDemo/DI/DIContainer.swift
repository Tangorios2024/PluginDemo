//
//  DIContainer.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import Foundation
import Swinject

/// 依赖注入容器管理器
final class DIContainer {
    static let shared = DIContainer()
    
    let container = Container()
    
    private init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        // MARK: - Services
        
        // 注册 UserActionTracker 服务
        container.register(UserActionTrackerProtocol.self) { _ in
            return UserActionTracker.shared
        }.inObjectScope(.container)
        
        // 注册插件
        container.register(ActionTrackerPlugin.self, name: "firebase") { _ in
            return FirebaseAnalyticsPlugin()
        }
        
        container.register(ActionTrackerPlugin.self, name: "appsflyer") { _ in
            return AppsFlyerPlugin()
        }
        
        container.register(ActionTrackerPlugin.self, name: "abtest") { _ in
            return ABTestPlugin()
        }
        
        // MARK: - ViewModels
        
        container.register(MainViewModelProtocol.self) { resolver in
            let tracker = resolver.resolve(UserActionTrackerProtocol.self)!
            return MainViewModel(tracker: tracker)
        }
        
        // MARK: - Coordinators
        
        container.register(MainCoordinatorProtocol.self) { resolver in
            return MainCoordinator(container: self.container)
        }
    }
    
    /// 解析依赖
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
    
    /// 解析带名称的依赖
    func resolve<T>(_ type: T.Type, name: String) -> T? {
        return container.resolve(type, name: name)
    }
}
