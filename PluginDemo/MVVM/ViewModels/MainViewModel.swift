//
//  MainViewModel.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

/// 主页面 ViewModel
final class MainViewModel: MainViewModelProtocol {

    // MARK: - Dependencies

    private let tracker: UserActionTrackerProtocol

    // MARK: - Delegates

    weak var navigationDelegate: MainViewModelNavigationDelegate?

    // MARK: - Properties

    private let currentUserId = "user123" // 模拟当前用户ID

    // MARK: - Initialization

    init(tracker: UserActionTrackerProtocol) {
        self.tracker = tracker
    }
    
    // MARK: - MainViewModelProtocol
    
    func viewDidLoad(viewController: UIViewController) {
        // 追踪页面浏览
        tracker.track(.viewScreen(name: "MainViewController"), 
                     from: viewController, 
                     userId: currentUserId)
    }
    
    func purchaseButtonTapped(viewController: UIViewController) {
        // 先追踪按钮点击
        tracker.track(.tapButton(identifier: "purchase_button"), 
                     from: viewController, 
                     userId: currentUserId)
        
        // 再追踪购买事件
        tracker.track(.purchase(productId: "SKU123", value: 9.99), 
                     from: viewController, 
                     userId: currentUserId)
    }
    
    func viewScreenButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "view_screen_button"),
                     from: viewController,
                     userId: currentUserId)

        // 追踪页面浏览
        tracker.track(.viewScreen(name: "ProductDetailViewController"),
                     from: viewController,
                     userId: currentUserId)

        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToProductDetail()
    }

    func customEventButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "custom_event_button"),
                     from: viewController,
                     userId: currentUserId)

        // 追踪自定义事件
        let properties = [
            "category": "engagement",
            "source": "main_screen",
            "feature": "custom_interaction"
        ]
        tracker.track(.custom(name: "feature_interaction", properties: properties),
                     from: viewController,
                     userId: currentUserId)
    }

    func llmDemoButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "llm_demo_button"),
                     from: viewController,
                     userId: currentUserId)

        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToLLMDemo()
    }
}
