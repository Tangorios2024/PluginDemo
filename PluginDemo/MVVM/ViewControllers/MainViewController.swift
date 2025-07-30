//
//  MainViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit

/// 主页面 ViewController
final class MainViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: MainViewModelProtocol
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Plugin Demo"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "插件式架构演示"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        setupConstraints()
        viewModel.viewDidLoad(viewController: self)
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加标题
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        // 添加按钮堆栈
        contentView.addSubview(stackView)
        
        // 创建按钮
        createButtons()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 内容视图约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 副标题约束
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 堆栈视图约束
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func createButtons() {
        let buttons = [
            createButton(title: "购买演示", action: #selector(purchaseButtonTapped)),
            createButton(title: "页面浏览演示", action: #selector(viewScreenButtonTapped)),
            createButton(title: "自定义事件演示", action: #selector(customEventButtonTapped)),
            createButton(title: "LLM 管道演示", action: #selector(llmDemoButtonTapped)),
            createButton(title: "AI 能力组合演示", action: #selector(aiCapabilityButtonTapped)),
            createButton(title: "智慧教育场景演示", action: #selector(educationScenarioButtonTapped)),
            createButton(title: "反馈收集场景演示", action: #selector(feedbackScenarioButtonTapped)),
            createButton(title: "深度思考按钮演示", action: #selector(deepThinkingButtonTapped)),
            createButton(title: "Chat模块架构演示", action: #selector(chatModuleButtonTapped)),
            createButton(title: "豆包爱学数学学习演示", action: #selector(douBaoMathButtonTapped)),
            createButton(title: "豆包爱学学习路径演示", action: #selector(douBaoLearningPathButtonTapped)),
            createButton(title: "豆包爱学AI辅导演示", action: #selector(douBaoTutoringButtonTapped))
        ]
        
        buttons.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Actions

    @objc private func purchaseButtonTapped() {
        viewModel.purchaseButtonTapped(viewController: self)
    }

    @objc private func viewScreenButtonTapped() {
        viewModel.viewScreenButtonTapped(viewController: self)
    }

    @objc private func customEventButtonTapped() {
        viewModel.customEventButtonTapped(viewController: self)
    }

    @objc private func llmDemoButtonTapped() {
        viewModel.llmDemoButtonTapped(viewController: self)
    }

    @objc private func aiCapabilityButtonTapped() {
        viewModel.aiCapabilityButtonTapped(viewController: self)
    }

    @objc private func educationScenarioButtonTapped() {
        viewModel.educationScenarioButtonTapped(viewController: self)
    }

    @objc private func feedbackScenarioButtonTapped() {
        viewModel.feedbackScenarioButtonTapped(viewController: self)
    }

    @objc private func deepThinkingButtonTapped() {
        viewModel.deepThinkingButtonButtonTapped(viewController: self)
    }
    
    @objc private func chatModuleButtonTapped() {
        viewModel.chatModuleButtonTapped(viewController: self)
    }
    
    @objc private func douBaoMathButtonTapped() {
        viewModel.douBaoMathButtonTapped(viewController: self)
    }
    
    @objc private func douBaoLearningPathButtonTapped() {
        viewModel.douBaoLearningPathButtonTapped(viewController: self)
    }
    
    @objc private func douBaoTutoringButtonTapped() {
        viewModel.douBaoTutoringButtonTapped(viewController: self)
    }

} 