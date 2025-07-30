//
//  MainCoordinator.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Swinject

/// 主页面 Coordinator
final class MainCoordinator: MainCoordinatorProtocol {

    // MARK: - Properties

    let navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    weak var parentCoordinator: CoordinatorProtocol?

    private let container: Container

    // MARK: - Initialization

    init(container: Container, navigationController: UINavigationController = UINavigationController()) {
        self.container = container
        self.navigationController = navigationController
        print("🏗️ MainCoordinator: 初始化完成")
    }

    deinit {
        print("🗑️ MainCoordinator: 已释放")
    }

    // MARK: - CoordinatorProtocol

    func start() {
        print("🚀 MainCoordinator: 开始启动...")

        let viewModel = container.resolve(MainViewModelProtocol.self)!
        let viewController = MainViewController(viewModel: viewModel)

        // 设置 ViewModel 的导航代理
        if let mainViewModel = viewModel as? MainViewModel {
            mainViewModel.navigationDelegate = self
        }

        navigationController.setViewControllers([viewController], animated: false)

        print("✅ MainCoordinator: 启动完成")
    }
    
    // MARK: - MainCoordinatorProtocol
    
    func showProductDetail() {
        // 这里可以创建并推送产品详情页面
        print("MainCoordinator: Navigating to product detail")
        
        // 示例：创建一个简单的详情页面
        let detailVC = UIViewController()
        detailVC.title = "Product Detail"
        detailVC.view.backgroundColor = .systemBackground
        
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func showSettings() {
        // 这里可以创建并推送设置页面
        print("MainCoordinator: Navigating to settings")

        // 示例：创建一个简单的设置页面
        let settingsVC = UIViewController()
        settingsVC.title = "Settings"
        settingsVC.view.backgroundColor = .systemBackground

        navigationController.pushViewController(settingsVC, animated: true)
    }
}

// MARK: - MainViewModelNavigationDelegate

extension MainCoordinator: MainViewModelNavigationDelegate {
    func navigateToProductDetail() {
        showProductDetail()
    }

    func navigateToLLMDemo() {
        let llmDemoVC = LLMDemoViewController()
        navigationController.pushViewController(llmDemoVC, animated: true)
    }

    func navigateToAICapabilityDemo() {
        let aiCapabilityVC = AICapabilityDemoViewController()
        navigationController.pushViewController(aiCapabilityVC, animated: true)
    }

    func navigateToEducationScenario() {
        let educationVC = EducationScenarioDemoViewController()
        navigationController.pushViewController(educationVC, animated: true)
    }

    func navigateToFeedbackScenario() {
        let feedbackVC = FeedbackScenarioDemoViewController()
        navigationController.pushViewController(feedbackVC, animated: true)
    }

    func navigateToDeepThinkingButton() {
        let deepThinkingVC = DeepThinkingButtonViewController()
        navigationController.pushViewController(deepThinkingVC, animated: true)
    }
    
    func navigateToChatModule() {
        let chatModuleVC = ChatModuleViewController()
        navigationController.pushViewController(chatModuleVC, animated: true)
    }
}
