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

    func aiCapabilityButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "ai_capability_button"),
                     from: viewController,
                     userId: currentUserId)

        // 追踪AI能力演示事件
        let properties = [
            "demo_type": "ai_capability_combination",
            "source": "main_screen",
            "feature": "ai_demo"
        ]
        tracker.track(.custom(name: "ai_capability_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)

        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToAICapabilityDemo()
    }

    func educationScenarioButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "education_scenario_button"),
                     from: viewController,
                     userId: currentUserId)

        // 追踪教育场景演示事件
        let properties: [String: Any] = [
            "demo_type": "education_scenario",
            "scenarios": ["smart_learning_assistant", "interactive_storytelling"],
            "source": "main_screen",
            "feature": "education_demo"
        ]
        tracker.track(.custom(name: "education_scenario_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)

        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToEducationScenario()
    }

    func feedbackScenarioButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "feedback_scenario_button"),
                     from: viewController,
                     userId: currentUserId)

        // 追踪反馈收集场景演示事件
        let properties: [String: Any] = [
            "demo_type": "feedback_scenario",
            "scenarios": ["enterprise_feedback", "technical_feedback"],
            "source": "main_screen",
            "feature": "feedback_demo"
        ]
        tracker.track(.custom(name: "feedback_scenario_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)

        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToFeedbackScenario()
    }

    func deepThinkingButtonButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "deep_thinking_button_demo"),
                     from: viewController,
                     userId: currentUserId)

        // 追踪深度思考按钮演示事件
        let properties: [String: Any] = [
            "demo_type": "deep_thinking_button",
            "scenarios": ["customer_ui", "enterprise_ui"],
            "source": "main_screen",
            "feature": "deep_thinking_demo"
        ]
        tracker.track(.custom(name: "deep_thinking_button_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)

        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToDeepThinkingButton()
    }
    
    func chatModuleButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "chat_module_demo"),
                     from: viewController,
                     userId: currentUserId)
        
        // 追踪Chat模块演示事件
        let properties: [String: Any] = [
            "demo_type": "chat_module_architecture",
            "scenarios": ["business_abstraction", "solid_principles", "mock_driven"],
            "source": "main_screen",
            "feature": "chat_module_demo"
        ]
        tracker.track(.custom(name: "chat_module_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)
        
        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToChatModule()
    }
    
    func douBaoMathButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "doubao_math_demo"),
                     from: viewController,
                     userId: currentUserId)
        
        // 追踪豆包爱学数学学习演示事件
        let properties: [String: Any] = [
            "demo_type": "doubao_math_learning",
            "scenarios": ["dynamic_learning_path", "feedback_driven_optimization", "adaptive_learning"],
            "source": "main_screen",
            "feature": "doubao_math_demo"
        ]
        tracker.track(.custom(name: "doubao_math_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)
        
        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToDouBaoMath()
    }
    
    func douBaoLearningPathButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "doubao_learning_path_demo"),
                     from: viewController,
                     userId: currentUserId)
        
        // 追踪豆包爱学学习路径演示事件
        let properties: [String: Any] = [
            "demo_type": "doubao_learning_path",
            "scenarios": ["personalized_path_planning", "learning_style_analysis", "content_recommendation"],
            "source": "main_screen",
            "feature": "doubao_learning_path_demo"
        ]
        tracker.track(.custom(name: "doubao_learning_path_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)
        
        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToDouBaoLearningPath()
    }
    
    func douBaoTutoringButtonTapped(viewController: UIViewController) {
        // 追踪按钮点击
        tracker.track(.tapButton(identifier: "doubao_tutoring_demo"),
                     from: viewController,
                     userId: currentUserId)
        
        // 追踪豆包爱学AI辅导演示事件
        let properties: [String: Any] = [
            "demo_type": "doubao_ai_tutoring",
            "scenarios": ["one_on_one_tutoring", "real_time_interaction", "learning_insights"],
            "source": "main_screen",
            "feature": "doubao_tutoring_demo"
        ]
        tracker.track(.custom(name: "doubao_tutoring_demo_started", properties: properties),
                     from: viewController,
                     userId: currentUserId)
        
        // 通知导航代理进行页面跳转
        navigationDelegate?.navigateToDouBaoTutoring()
    }

}
