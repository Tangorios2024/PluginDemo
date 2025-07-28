//
//  MainViewModelProtocol.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

/// MainViewModel 协议
protocol MainViewModelProtocol {
    /// 页面加载
    func viewDidLoad(viewController: UIViewController)

    /// 购买按钮点击
    func purchaseButtonTapped(viewController: UIViewController)

    /// 浏览页面按钮点击
    func viewScreenButtonTapped(viewController: UIViewController)

    /// 自定义事件按钮点击
    func customEventButtonTapped(viewController: UIViewController)

    /// LLM 演示按钮点击
    func llmDemoButtonTapped(viewController: UIViewController)
}

/// MainViewModel 导航代理协议
protocol MainViewModelNavigationDelegate: AnyObject {
    func navigateToProductDetail()
    func navigateToLLMDemo()
}
