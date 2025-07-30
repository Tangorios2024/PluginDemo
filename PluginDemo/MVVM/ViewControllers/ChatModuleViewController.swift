//
//  ChatModuleViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Combine

/// Chat模块演示页面
/// 展示两个业务方的UI和逻辑差异
final class ChatModuleViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat模块架构演示"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "展示业务抽象能力和SOLID原则实践"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 业务方切换区域
    
    private lazy var businessSwitchView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var businessSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "选择业务方"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var businessASegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["BusinessA", "BusinessB"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(businessChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    // MARK: - 配置展示区域
    
    private lazy var configurationView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var configurationLabel: UILabel = {
        let label = UILabel()
        label.text = "当前配置"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var configurationTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .label
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Chat界面区域
    
    private lazy var chatContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chatLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat对话"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tableView.backgroundColor = .systemGray6
        tableView.layer.cornerRadius = 8
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入消息..."
        textField.font = .systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - 能力按钮区域
    
    private lazy var capabilitiesView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var capabilitiesLabel: UILabel = {
        let label = UILabel()
        label.text = "AI能力按钮"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var capabilitiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    
    private var viewModel: ChatViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupBindings()
        updateUIForBusiness("business_a")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Chat模块演示"
        
        // 添加子视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(businessSwitchView)
        contentView.addSubview(configurationView)
        contentView.addSubview(chatContainerView)
        contentView.addSubview(capabilitiesView)
        
        businessSwitchView.addSubview(businessSwitchLabel)
        businessSwitchView.addSubview(businessASegmentedControl)
        
        configurationView.addSubview(configurationLabel)
        configurationView.addSubview(configurationTextView)
        
        chatContainerView.addSubview(chatLabel)
        chatContainerView.addSubview(chatTableView)
        chatContainerView.addSubview(inputContainerView)
        
        inputContainerView.addSubview(messageTextField)
        inputContainerView.addSubview(sendButton)
        
        capabilitiesView.addSubview(capabilitiesLabel)
        capabilitiesView.addSubview(capabilitiesStackView)
        
        setupConstraints()
        setupCapabilityButtons()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Business Switch
            businessSwitchView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            businessSwitchView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            businessSwitchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            businessSwitchView.heightAnchor.constraint(equalToConstant: 80),
            
            businessSwitchLabel.topAnchor.constraint(equalTo: businessSwitchView.topAnchor, constant: 16),
            businessSwitchLabel.leadingAnchor.constraint(equalTo: businessSwitchView.leadingAnchor, constant: 16),
            
            businessASegmentedControl.topAnchor.constraint(equalTo: businessSwitchLabel.bottomAnchor, constant: 12),
            businessASegmentedControl.leadingAnchor.constraint(equalTo: businessSwitchView.leadingAnchor, constant: 16),
            businessASegmentedControl.trailingAnchor.constraint(equalTo: businessSwitchView.trailingAnchor, constant: -16),
            businessASegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            // Configuration
            configurationView.topAnchor.constraint(equalTo: businessSwitchView.bottomAnchor, constant: 20),
            configurationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            configurationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            configurationView.heightAnchor.constraint(equalToConstant: 200),
            
            configurationLabel.topAnchor.constraint(equalTo: configurationView.topAnchor, constant: 16),
            configurationLabel.leadingAnchor.constraint(equalTo: configurationView.leadingAnchor, constant: 16),
            
            configurationTextView.topAnchor.constraint(equalTo: configurationLabel.bottomAnchor, constant: 12),
            configurationTextView.leadingAnchor.constraint(equalTo: configurationView.leadingAnchor, constant: 16),
            configurationTextView.trailingAnchor.constraint(equalTo: configurationView.trailingAnchor, constant: -16),
            configurationTextView.bottomAnchor.constraint(equalTo: configurationView.bottomAnchor, constant: -16),
            
            // Chat Container
            chatContainerView.topAnchor.constraint(equalTo: configurationView.bottomAnchor, constant: 20),
            chatContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chatContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chatContainerView.heightAnchor.constraint(equalToConstant: 400),
            
            chatLabel.topAnchor.constraint(equalTo: chatContainerView.topAnchor, constant: 16),
            chatLabel.leadingAnchor.constraint(equalTo: chatContainerView.leadingAnchor, constant: 16),
            
            chatTableView.topAnchor.constraint(equalTo: chatLabel.bottomAnchor, constant: 12),
            chatTableView.leadingAnchor.constraint(equalTo: chatContainerView.leadingAnchor, constant: 16),
            chatTableView.trailingAnchor.constraint(equalTo: chatContainerView.trailingAnchor, constant: -16),
            chatTableView.heightAnchor.constraint(equalToConstant: 280),
            
            inputContainerView.topAnchor.constraint(equalTo: chatTableView.bottomAnchor, constant: 12),
            inputContainerView.leadingAnchor.constraint(equalTo: chatContainerView.leadingAnchor, constant: 16),
            inputContainerView.trailingAnchor.constraint(equalTo: chatContainerView.trailingAnchor, constant: -16),
            inputContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            messageTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 12),
            messageTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 8),
            messageTextField.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -8),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -8),
            sendButton.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 6),
            sendButton.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -6),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            
            // Capabilities
            capabilitiesView.topAnchor.constraint(equalTo: chatContainerView.bottomAnchor, constant: 20),
            capabilitiesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            capabilitiesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            capabilitiesView.heightAnchor.constraint(equalToConstant: 120),
            capabilitiesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            capabilitiesLabel.topAnchor.constraint(equalTo: capabilitiesView.topAnchor, constant: 16),
            capabilitiesLabel.leadingAnchor.constraint(equalTo: capabilitiesView.leadingAnchor, constant: 16),
            
            capabilitiesStackView.topAnchor.constraint(equalTo: capabilitiesLabel.bottomAnchor, constant: 12),
            capabilitiesStackView.leadingAnchor.constraint(equalTo: capabilitiesView.leadingAnchor, constant: 16),
            capabilitiesStackView.trailingAnchor.constraint(equalTo: capabilitiesView.trailingAnchor, constant: -16),
            capabilitiesStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCapabilityButtons() {
        let capabilities: [ChatCapability] = [.deepThinking, .webSearch, .knowledgeBase, .smartSummary]
        
        for capability in capabilities {
            let button = createCapabilityButton(for: capability)
            capabilitiesStackView.addArrangedSubview(button)
        }
    }
    
    private func createCapabilityButton(for capability: ChatCapability) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(capability.displayName, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.tag = capability.hashValue
        button.addTarget(self, action: #selector(capabilityButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func setupViewModel() {
        viewModel = ChatViewModel(businessId: "business_a")
    }
    
    private func setupBindings() {
        // 监听消息变化
        viewModel.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.chatTableView.reloadData()
                self?.scrollToBottom()
            }
            .store(in: &cancellables)
        
        // 监听加载状态
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.sendButton.isEnabled = !isLoading
                self?.messageTextField.isEnabled = !isLoading
                if isLoading {
                    self?.sendButton.setTitle("发送中...", for: .normal)
                } else {
                    self?.sendButton.setTitle("发送", for: .normal)
                }
            }
            .store(in: &cancellables)
        
        // 监听配置变化
        viewModel.$currentConfiguration
            .receive(on: DispatchQueue.main)
            .sink { [weak self] config in
                self?.updateConfigurationDisplay(config)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc private func businessChanged() {
        let businessId = businessASegmentedControl.selectedSegmentIndex == 0 ? "business_a" : "business_b"
        viewModel.switchBusiness(businessId)
        updateUIForBusiness(businessId)
    }
    
    @objc private func sendMessage() {
        guard let message = messageTextField.text, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        Task {
            do {
                try await viewModel.sendMessage(message)
                messageTextField.text = ""
            } catch {
                print("发送消息失败: \(error)")
            }
        }
    }
    
    @objc private func capabilityButtonTapped(_ sender: UIButton) {
        let capabilities: [ChatCapability] = [.deepThinking, .webSearch, .knowledgeBase, .smartSummary]
        let capability = capabilities[sender.tag % capabilities.count]
        
        let message = "请使用\(capability.displayName)能力"
        messageTextField.text = message
        sendMessage()
    }
    
    // MARK: - UI Updates
    
    private func updateUIForBusiness(_ businessId: String) {
        if businessId == "business_a" {
            // BusinessA - 客户友好风格
            updateUIForCustomerStyle()
        } else {
            // BusinessB - 企业专业风格
            updateUIForEnterpriseStyle()
        }
    }
    
    private func updateUIForCustomerStyle() {
        // 圆角、渐变、弹跳动画
        chatContainerView.layer.cornerRadius = 16
        inputContainerView.layer.cornerRadius = 22
        
        // 渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.42, blue: 0.21, alpha: 0.1).cgColor,
            UIColor(red: 0.97, green: 0.58, blue: 0.12, alpha: 0.1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 16
        chatContainerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // 按钮样式
        sendButton.backgroundColor = UIColor(red: 1.0, green: 0.42, blue: 0.21, alpha: 1.0)
        sendButton.layer.cornerRadius = 18
        
        // 动画效果
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.chatContainerView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.chatContainerView.transform = .identity
            }
        }
    }
    
    private func updateUIForEnterpriseStyle() {
        // 直角、单色、淡入淡出
        chatContainerView.layer.cornerRadius = 4
        inputContainerView.layer.cornerRadius = 4
        
        // 移除渐变背景
        chatContainerView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        // 按钮样式
        sendButton.backgroundColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        sendButton.layer.cornerRadius = 4
        
        // 动画效果
        UIView.animate(withDuration: 0.5) {
            self.chatContainerView.alpha = 0.8
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.chatContainerView.alpha = 1.0
            }
        }
    }
    
    private func updateConfigurationDisplay(_ config: ChatConfiguration?) {
        guard let config = config else {
            configurationTextView.text = "未找到配置"
            return
        }
        
        let configText = """
        业务方: \(config.businessName)
        业务ID: \(config.businessId)
        
        🎨 UI定制化:
        • 主题: \(config.uiCustomization.theme)
        • 按钮样式: \(config.uiCustomization.buttonStyle)
        • 动画类型: \(config.uiCustomization.animationType)
        • 圆角半径: \(config.uiCustomization.borderRadius)
        • 阴影效果: \(config.uiCustomization.shadowEnabled ? "启用" : "禁用")
        
        🔧 逻辑定制化:
        • 响应策略: \(config.logicCustomization.responseStrategy)
        • 重试次数: \(config.logicCustomization.retryCount)
        • 超时时间: \(config.logicCustomization.timeoutInterval)秒
        • 回退机制: \(config.logicCustomization.fallbackEnabled ? "启用" : "禁用")
        
        🚀 启用能力:
        \(config.enabledCapabilities.map { "• \($0.displayName): \($0.description)" }.joined(separator: "\n"))
        
        📋 能力执行顺序:
        \(config.capabilityOrder.map { "\($0.displayName)" }.joined(separator: " → "))
        """
        
        configurationTextView.text = configText
    }
    
    private func scrollToBottom() {
        guard !viewModel.messages.isEmpty else { return }
        let lastRow = viewModel.messages.count - 1
        let indexPath = IndexPath(row: lastRow, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ChatModuleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let message = viewModel.messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - ChatMessageCell

/// Chat消息单元格
final class ChatMessageCell: UITableViewCell {
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.content
        
        switch message.sender {
        case .user:
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        case .assistant:
            bubbleView.backgroundColor = .systemGray5
            messageLabel.textColor = .label
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .system:
            bubbleView.backgroundColor = .systemYellow
            messageLabel.textColor = .label
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
} 