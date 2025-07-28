//
//  SceneDelegate.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var mainCoordinator: MainCoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 设置窗口
        window = UIWindow(windowScene: windowScene)

        // 初始化依赖注入容器
        let diContainer = DIContainer.shared

        // 组装我们的追踪系统
        let tracker = UserActionTracker.shared

        // 注册插件 - 顺序很重要！
        // ABTestPlugin 需要先注册，因为它在 transform 阶段为事件添加实验组信息
        if let abTestPlugin = diContainer.resolve(ActionTrackerPlugin.self, name: "abtest") {
            tracker.register(plugin: abTestPlugin)
        }
        if let firebasePlugin = diContainer.resolve(ActionTrackerPlugin.self, name: "firebase") {
            tracker.register(plugin: firebasePlugin)
        }
        if let appsFlyerPlugin = diContainer.resolve(ActionTrackerPlugin.self, name: "appsflyer") {
            tracker.register(plugin: appsFlyerPlugin)
        }

        print("UserActionTracker: All plugins registered successfully")

        // 启动主 Coordinator
        mainCoordinator = diContainer.resolve(MainCoordinatorProtocol.self)
        window?.rootViewController = mainCoordinator?.navigationController
        mainCoordinator?.start()

        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

