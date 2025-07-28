//
//  MainViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Anchorage

/// 主页面 ViewController - 使用 MVVM-C 架构
final class MainViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: MainViewModelProtocol

    // MARK: - UI Components

    private lazy var purchaseButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("购买商品", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 8
        return btn
    }()

    private lazy var viewScreenButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("浏览页面", for: .normal)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 8
        return btn
    }()

    private lazy var customEventButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("自定义事件", for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 8
        return btn
    }()

    private lazy var llmDemoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("LLM 管道演示", for: .normal)
        btn.backgroundColor = .systemPurple
        btn.layer.cornerRadius = 8
        return btn
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [purchaseButton, viewScreenButton, customEventButton, llmDemoButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Initialization

    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupActions()

        // 通过 ViewModel 处理页面加载
        viewModel.viewDidLoad(viewController: self)
    }

    // MARK: - Private Methods

    private func setupUI() {
        title = "插件式架构演示"
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)

        stackView.centerXAnchor == view.centerXAnchor
        stackView.centerYAnchor == view.centerYAnchor
        stackView.widthAnchor == 250
        stackView.heightAnchor == 280
    }

    private func setupActions() {
        purchaseButton.addTarget(self, action: #selector(purchaseAction), for: .touchUpInside)
        viewScreenButton.addTarget(self, action: #selector(viewScreenAction), for: .touchUpInside)
        customEventButton.addTarget(self, action: #selector(customEventAction), for: .touchUpInside)
        llmDemoButton.addTarget(self, action: #selector(llmDemoAction), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func purchaseAction() {
        viewModel.purchaseButtonTapped(viewController: self)
    }

    @objc private func viewScreenAction() {
        viewModel.viewScreenButtonTapped(viewController: self)
    }

    @objc private func customEventAction() {
        viewModel.customEventButtonTapped(viewController: self)
    }

    @objc private func llmDemoAction() {
        viewModel.llmDemoButtonTapped(viewController: self)
    }
}

