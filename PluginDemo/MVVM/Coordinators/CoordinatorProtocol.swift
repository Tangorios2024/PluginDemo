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

    func start()
}

/// 主页面 Coordinator 协议
protocol MainCoordinatorProtocol: CoordinatorProtocol {
    func showProductDetail()
    func showSettings()
}
