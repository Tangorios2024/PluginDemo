//
//  CoordinatorProtocol.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

/// 基础 Coordinator 协议
protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [CoordinatorProtocol] { get set }
    var parentCoordinator: CoordinatorProtocol? { get set }

    // 生命周期方法
    func start()
    func stop()

    // 子 Coordinator 管理
    func addChild(_ coordinator: CoordinatorProtocol)
    func removeChild(_ coordinator: CoordinatorProtocol)
    func removeAllChildren()
}

/// Coordinator 协议默认实现
extension CoordinatorProtocol {
    func addChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }

    func removeChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
        coordinator.parentCoordinator = nil
    }

    func removeAllChildren() {
        childCoordinators.forEach { child in
            child.stop()
            child.parentCoordinator = nil
        }
        childCoordinators.removeAll()
    }

    func stop() {
        removeAllChildren()
    }
}

/// 主页面 Coordinator 协议
protocol MainCoordinatorProtocol: CoordinatorProtocol {
    func showProductDetail()
    func showSettings()
}
