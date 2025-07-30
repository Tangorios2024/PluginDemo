//
//  ChatModuleViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Combine
import Anchorage

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
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Chat区域
    
    private lazy var chatContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chatLabel: UILabel = {
        let label = UILabel()
        label.text = "聊天对话"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入消息..."
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
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
        label.text = "AI能力"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var capabilitiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - 企业级功能区域
    
    private lazy var enterpriseFeaturesView: UIView = {
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
    
    private lazy var enterpriseFeaturesLabel: UILabel = {
        let label = UILabel()
        label.text = "企业级功能"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var enterpriseFeaturesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var thinkingChainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("思考链路", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(toggleThinkingChain), for: .touchUpInside)
        return button
    }()
    
    private lazy var customKnowledgeBaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("知识库", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(toggleCustomKnowledgeBase), for: .touchUpInside)
        return button
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
        contentView.addSubview(enterpriseFeaturesView)
        
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
        
        enterpriseFeaturesView.addSubview(enterpriseFeaturesLabel)
        enterpriseFeaturesView.addSubview(enterpriseFeaturesStackView)
        enterpriseFeaturesStackView.addArrangedSubview(thinkingChainButton)
        enterpriseFeaturesStackView.addArrangedSubview(customKnowledgeBaseButton)
        
        setupConstraints()
        setupCapabilityButtons()
        setupTableView()
    }
    
    private func setupConstraints() {
        // 使用Anchorage设置约束
        scrollView.edgeAnchors == view.safeAreaLayoutGuide.edgeAnchors
        
        contentView.edgeAnchors == scrollView.edgeAnchors
        contentView.widthAnchor == scrollView.widthAnchor
        
        titleLabel.topAnchor == contentView.topAnchor + 20
        titleLabel.horizontalAnchors == contentView.horizontalAnchors + 20
        
        subtitleLabel.topAnchor == titleLabel.bottomAnchor + 8
        subtitleLabel.horizontalAnchors == contentView.horizontalAnchors + 20
        
        businessSwitchView.topAnchor == subtitleLabel.bottomAnchor + 20
        businessSwitchView.horizontalAnchors == contentView.horizontalAnchors + 20
        businessSwitchView.heightAnchor == 80
        
        businessSwitchLabel.topAnchor == businessSwitchView.topAnchor + 16
        businessSwitchLabel.leadingAnchor == businessSwitchView.leadingAnchor + 16
        
        businessASegmentedControl.topAnchor == businessSwitchLabel.bottomAnchor + 12
        businessASegmentedControl.horizontalAnchors == businessSwitchView.horizontalAnchors + 16
        businessASegmentedControl.heightAnchor == 32
        
        configurationView.topAnchor == businessSwitchView.bottomAnchor + 20
        configurationView.horizontalAnchors == contentView.horizontalAnchors + 20
        configurationView.heightAnchor == 200
        
        configurationLabel.topAnchor == configurationView.topAnchor + 16
        configurationLabel.leadingAnchor == configurationView.leadingAnchor + 16
        
        configurationTextView.topAnchor == configurationLabel.bottomAnchor + 12
        configurationTextView.edgeAnchors == configurationView.edgeAnchors + 16
        
        chatContainerView.topAnchor == configurationView.bottomAnchor + 20
        chatContainerView.horizontalAnchors == contentView.horizontalAnchors + 20
        chatContainerView.heightAnchor == 400
        
        chatLabel.topAnchor == chatContainerView.topAnchor + 16
        chatLabel.leadingAnchor == chatContainerView.leadingAnchor + 16
        
        chatTableView.topAnchor == chatLabel.bottomAnchor + 12
        chatTableView.horizontalAnchors == chatContainerView.horizontalAnchors + 16
        chatTableView.heightAnchor == 280
        
        inputContainerView.topAnchor == chatTableView.bottomAnchor + 12
        inputContainerView.horizontalAnchors == chatContainerView.horizontalAnchors + 16
        inputContainerView.heightAnchor == 44
        
        messageTextField.leadingAnchor == inputContainerView.leadingAnchor + 12
        messageTextField.verticalAnchors == inputContainerView.verticalAnchors + 8
        messageTextField.trailingAnchor == sendButton.leadingAnchor - 8
        
        sendButton.trailingAnchor == inputContainerView.trailingAnchor - 8
        sendButton.verticalAnchors == inputContainerView.verticalAnchors + 6
        sendButton.widthAnchor == 60
        
        capabilitiesView.topAnchor == chatContainerView.bottomAnchor + 20
        capabilitiesView.horizontalAnchors == contentView.horizontalAnchors + 20
        capabilitiesView.heightAnchor == 120
        
        capabilitiesLabel.topAnchor == capabilitiesView.topAnchor + 16
        capabilitiesLabel.leadingAnchor == capabilitiesView.leadingAnchor + 16
        
        capabilitiesStackView.topAnchor == capabilitiesLabel.bottomAnchor + 12
        capabilitiesStackView.horizontalAnchors == capabilitiesView.horizontalAnchors + 16
        capabilitiesStackView.heightAnchor == 40
        
        enterpriseFeaturesView.topAnchor == capabilitiesView.bottomAnchor + 20
        enterpriseFeaturesView.horizontalAnchors == contentView.horizontalAnchors + 20
        enterpriseFeaturesView.heightAnchor == 100
        enterpriseFeaturesView.bottomAnchor == contentView.bottomAnchor - 20
        
        enterpriseFeaturesLabel.topAnchor == enterpriseFeaturesView.topAnchor + 16
        enterpriseFeaturesLabel.leadingAnchor == enterpriseFeaturesView.leadingAnchor + 16
        
        enterpriseFeaturesStackView.topAnchor == enterpriseFeaturesLabel.bottomAnchor + 12
        enterpriseFeaturesStackView.horizontalAnchors == enterpriseFeaturesView.horizontalAnchors + 16
        enterpriseFeaturesStackView.heightAnchor == 40
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
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
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
                self?.sendButton.setTitle(isLoading ? "发送中..." : "发送", for: .normal)
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
    
    @objc private func toggleThinkingChain() {
        viewModel.toggleThinkingChain()
        
        if viewModel.showThinkingChain {
            // 生成思考链路
            Task {
                do {
                    let currentMessage = messageTextField.text ?? "请分析当前对话内容"
                    try await viewModel.generateThinkingChain(for: currentMessage)
                    showThinkingChainAlert()
                } catch {
                    showErrorAlert(message: "生成思考链路失败：\(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func toggleCustomKnowledgeBase() {
        viewModel.toggleKnowledgeSearch()
        
        if viewModel.showKnowledgeSearch {
            // 搜索自定义知识库
            Task {
                do {
                    let query = messageTextField.text ?? "企业架构设计"
                    try await viewModel.searchCustomKnowledgeBase(query: query)
                    showKnowledgeSearchAlert()
                } catch {
                    showErrorAlert(message: "知识库检索失败：\(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - UI Updates
    
    private func updateUIForBusiness(_ businessId: String) {
        if businessId == "business_a" {
            // BusinessA - 客户友好风格
            updateUIForCustomerStyle()
            // 隐藏企业级功能
            enterpriseFeaturesView.isHidden = true
        } else {
            // BusinessB - 企业专业风格
            updateUIForEnterpriseStyle()
            // 显示企业级功能
            enterpriseFeaturesView.isHidden = false
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
        // 直角、简洁、淡入淡出
        chatContainerView.layer.cornerRadius = 4
        inputContainerView.layer.cornerRadius = 4
        
        // 移除渐变背景
        chatContainerView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        // 按钮样式
        sendButton.backgroundColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)
        sendButton.layer.cornerRadius = 4
        
        // 动画效果
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.chatContainerView.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.2) {
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
        业务名称: \(config.businessName)
        业务ID: \(config.businessId)
        
        启用能力:
        \(config.enabledCapabilities.map { "- \($0.displayName)" }.joined(separator: "\n"))
        
        能力优先级:
        \(config.capabilityOrder.map { "- \($0.displayName)" }.joined(separator: "\n"))
        
        响应延迟: \(config.responseDelay)秒
        Mock数据: \(config.mockDataEnabled ? "启用" : "禁用")
        
        UI定制:
        - 主题: \(config.uiCustomization.theme)
        - 按钮样式: \(config.uiCustomization.buttonStyle)
        - 动画类型: \(config.uiCustomization.animationType)
        - 圆角: \(config.uiCustomization.borderRadius)
        
        逻辑定制:
        - 响应策略: \(config.logicCustomization.responseStrategy)
        - 重试次数: \(config.logicCustomization.retryCount)
        - 超时时间: \(config.logicCustomization.timeoutInterval)秒
        """
        
        configurationTextView.text = configText
    }
    
    private func scrollToBottom() {
        guard !viewModel.messages.isEmpty else { return }
        let lastIndex = IndexPath(row: viewModel.messages.count - 1, section: 0)
        chatTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    // MARK: - Alerts
    
    private func showThinkingChainAlert() {
        guard let thinkingChain = viewModel.thinkingChain else { return }
        
        let alert = UIAlertController(title: "思考链路", message: nil, preferredStyle: .alert)
        
        var message = ""
        for step in thinkingChain.steps {
            message += "步骤\(step.stepNumber): \(step.content)\n"
            message += "置信度: \(step.confidence)\n"
            message += "推理: \(step.reasoning)\n\n"
        }
        
        alert.message = message
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showKnowledgeSearchAlert() {
        guard let result = viewModel.knowledgeSearchResult else { return }
        
        let alert = UIAlertController(title: "知识库检索结果", message: nil, preferredStyle: .alert)
        
        var message = "查询: \(result.query)\n\n"
        message += "相关文档:\n"
        for (index, doc) in result.documents.enumerated() {
            message += "\(index + 1). \(doc.title)\n"
            message += "   相关性: \(doc.relevanceScore)\n"
            message += "   内容: \(doc.content)\n\n"
        }
        
        alert.message = message
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
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

class ChatMessageCell: UITableViewCell {
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        // 使用Anchorage设置约束
        bubbleView.edgeAnchors == contentView.edgeAnchors + UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        messageLabel.edgeAnchors == bubbleView.edgeAnchors + UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
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
            bubbleView.backgroundColor = .systemOrange.withAlphaComponent(0.2)
            messageLabel.textColor = .label
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}