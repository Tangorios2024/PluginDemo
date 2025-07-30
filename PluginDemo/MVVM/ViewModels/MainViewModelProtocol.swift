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

    /// AI 能力组合演示按钮点击
    func aiCapabilityButtonTapped(viewController: UIViewController)

    /// 智慧教育场景按钮点击
    func educationScenarioButtonTapped(viewController: UIViewController)

    /// 反馈收集场景按钮点击
    func feedbackScenarioButtonTapped(viewController: UIViewController)

    /// 深度思考按钮展示按钮点击
func deepThinkingButtonButtonTapped(viewController: UIViewController)

/// Chat模块架构演示按钮点击
func chatModuleButtonTapped(viewController: UIViewController)

/// 豆包爱学数学学习演示按钮点击
func douBaoMathButtonTapped(viewController: UIViewController)

/// 豆包爱学学习路径演示按钮点击
func douBaoLearningPathButtonTapped(viewController: UIViewController)

/// 豆包爱学AI辅导演示按钮点击
func douBaoTutoringButtonTapped(viewController: UIViewController)

}

/// MainViewModel 导航代理协议
protocol MainViewModelNavigationDelegate: AnyObject {
    func navigateToProductDetail()
    func navigateToLLMDemo()
    func navigateToAICapabilityDemo()
    func navigateToEducationScenario()
    func navigateToFeedbackScenario()
    func navigateToDeepThinkingButton()
    func navigateToChatModule()
    func navigateToDouBaoMath()
    func navigateToDouBaoLearningPath()
    func navigateToDouBaoTutoring()

}
