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
    private let container: Container
    
    // MARK: - Initialization
    
    init(container: Container, navigationController: UINavigationController = UINavigationController()) {
        self.container = container
        self.navigationController = navigationController
    }
    
    // MARK: - CoordinatorProtocol

    func start() {
        let viewModel = container.resolve(MainViewModelProtocol.self)!
        let viewController = MainViewController(viewModel: viewModel)

        // 设置 ViewModel 的导航代理
        if let mainViewModel = viewModel as? MainViewModel {
            mainViewModel.navigationDelegate = self
        }

        navigationController.setViewControllers([viewController], animated: false)
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
}
