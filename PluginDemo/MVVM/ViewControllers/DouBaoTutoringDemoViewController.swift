//
//  DouBaoTutoringDemoViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/1/27.
//

import UIKit
import Combine

/// 豆包爱学AI辅导演示界面
final class DouBaoTutoringDemoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DouBaoTutoringViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
        label.text = "豆包爱学 - AI一对一辅导"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Student Info Section
    
    private lazy var studentInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var studentInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "学生信息"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var studentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var studentLevelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Tutoring Mode Section
    
    private lazy var tutoringModeView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tutoringModeLabel: UILabel = {
        let label = UILabel()
        label.text = "辅导模式"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var modePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    // MARK: - Conversation History Section
    
    private lazy var conversationView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var conversationLabel: UILabel = {
        let label = UILabel()
        label.text = "对话历史"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var conversationTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Practice Questions Section
    
    private lazy var practiceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var practiceLabel: UILabel = {
        let label = UILabel()
        label.text = "练习题目"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var practiceTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Learning Insights Section
    
    private lazy var insightsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var insightsLabel: UILabel = {
        let label = UILabel()
        label.text = "学习洞察"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var insightsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Session Status Section
    
    private lazy var sessionStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sessionStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "会话状态"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sessionStatusDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Control Buttons
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var startSessionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始辅导", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startSessionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var generatePracticeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("生成练习", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(generatePracticeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var analyzeResponseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("分析回答", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(analyzeResponseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var optimizeInteractionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("优化交互", for: .normal)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(optimizeInteractionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    init(viewModel: DouBaoTutoringViewModel) {
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
        setupBindings()
        Task {
            await viewModel.loadStudentData()
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "AI辅导演示"
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加标题
        contentView.addSubview(titleLabel)
        
        // 添加各个区域
        setupStudentInfoSection()
        setupTutoringModeSection()
        setupConversationSection()
        setupPracticeSection()
        setupInsightsSection()
        setupSessionStatusSection()
        setupControlButtons()
    }
    
    private func setupStudentInfoSection() {
        contentView.addSubview(studentInfoView)
        studentInfoView.addSubview(studentInfoLabel)
        studentInfoView.addSubview(studentNameLabel)
        studentInfoView.addSubview(studentLevelLabel)
    }
    
    private func setupTutoringModeSection() {
        contentView.addSubview(tutoringModeView)
        tutoringModeView.addSubview(tutoringModeLabel)
        tutoringModeView.addSubview(modePickerView)
    }
    
    private func setupConversationSection() {
        contentView.addSubview(conversationView)
        conversationView.addSubview(conversationLabel)
        conversationView.addSubview(conversationTableView)
    }
    
    private func setupPracticeSection() {
        contentView.addSubview(practiceView)
        practiceView.addSubview(practiceLabel)
        practiceView.addSubview(practiceTextView)
    }
    
    private func setupInsightsSection() {
        contentView.addSubview(insightsView)
        insightsView.addSubview(insightsLabel)
        insightsView.addSubview(insightsTextView)
    }
    
    private func setupSessionStatusSection() {
        contentView.addSubview(sessionStatusView)
        sessionStatusView.addSubview(sessionStatusLabel)
        sessionStatusView.addSubview(sessionStatusDetailLabel)
    }
    
    private func setupControlButtons() {
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(startSessionButton)
        buttonStackView.addArrangedSubview(generatePracticeButton)
        buttonStackView.addArrangedSubview(analyzeResponseButton)
        buttonStackView.addArrangedSubview(optimizeInteractionButton)
    }
    
    // MARK: - Constraints
    
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 学生信息区域约束
            studentInfoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            studentInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            studentInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            studentInfoView.heightAnchor.constraint(equalToConstant: 100),
            
            studentInfoLabel.topAnchor.constraint(equalTo: studentInfoView.topAnchor, constant: 12),
            studentInfoLabel.leadingAnchor.constraint(equalTo: studentInfoView.leadingAnchor, constant: 12),
            studentInfoLabel.trailingAnchor.constraint(equalTo: studentInfoView.trailingAnchor, constant: -12),
            
            studentNameLabel.topAnchor.constraint(equalTo: studentInfoLabel.bottomAnchor, constant: 8),
            studentNameLabel.leadingAnchor.constraint(equalTo: studentInfoView.leadingAnchor, constant: 12),
            studentNameLabel.trailingAnchor.constraint(equalTo: studentInfoView.trailingAnchor, constant: -12),
            
            studentLevelLabel.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor, constant: 4),
            studentLevelLabel.leadingAnchor.constraint(equalTo: studentInfoView.leadingAnchor, constant: 12),
            studentLevelLabel.trailingAnchor.constraint(equalTo: studentInfoView.trailingAnchor, constant: -12),
            
            // 辅导模式区域约束
            tutoringModeView.topAnchor.constraint(equalTo: studentInfoView.bottomAnchor, constant: 16),
            tutoringModeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tutoringModeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tutoringModeView.heightAnchor.constraint(equalToConstant: 120),
            
            tutoringModeLabel.topAnchor.constraint(equalTo: tutoringModeView.topAnchor, constant: 12),
            tutoringModeLabel.leadingAnchor.constraint(equalTo: tutoringModeView.leadingAnchor, constant: 12),
            tutoringModeLabel.trailingAnchor.constraint(equalTo: tutoringModeView.trailingAnchor, constant: -12),
            
            modePickerView.topAnchor.constraint(equalTo: tutoringModeLabel.bottomAnchor, constant: 8),
            modePickerView.leadingAnchor.constraint(equalTo: tutoringModeView.leadingAnchor),
            modePickerView.trailingAnchor.constraint(equalTo: tutoringModeView.trailingAnchor),
            modePickerView.bottomAnchor.constraint(equalTo: tutoringModeView.bottomAnchor, constant: -12),
            
            // 对话历史区域约束
            conversationView.topAnchor.constraint(equalTo: tutoringModeView.bottomAnchor, constant: 16),
            conversationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            conversationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            conversationView.heightAnchor.constraint(equalToConstant: 200),
            
            conversationLabel.topAnchor.constraint(equalTo: conversationView.topAnchor, constant: 12),
            conversationLabel.leadingAnchor.constraint(equalTo: conversationView.leadingAnchor, constant: 12),
            conversationLabel.trailingAnchor.constraint(equalTo: conversationView.trailingAnchor, constant: -12),
            
            conversationTableView.topAnchor.constraint(equalTo: conversationLabel.bottomAnchor, constant: 8),
            conversationTableView.leadingAnchor.constraint(equalTo: conversationView.leadingAnchor),
            conversationTableView.trailingAnchor.constraint(equalTo: conversationView.trailingAnchor),
            conversationTableView.bottomAnchor.constraint(equalTo: conversationView.bottomAnchor, constant: -12),
            
            // 练习题目区域约束
            practiceView.topAnchor.constraint(equalTo: conversationView.bottomAnchor, constant: 16),
            practiceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            practiceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            practiceView.heightAnchor.constraint(equalToConstant: 120),
            
            practiceLabel.topAnchor.constraint(equalTo: practiceView.topAnchor, constant: 12),
            practiceLabel.leadingAnchor.constraint(equalTo: practiceView.leadingAnchor, constant: 12),
            practiceLabel.trailingAnchor.constraint(equalTo: practiceView.trailingAnchor, constant: -12),
            
            practiceTextView.topAnchor.constraint(equalTo: practiceLabel.bottomAnchor, constant: 8),
            practiceTextView.leadingAnchor.constraint(equalTo: practiceView.leadingAnchor, constant: 12),
            practiceTextView.trailingAnchor.constraint(equalTo: practiceView.trailingAnchor, constant: -12),
            practiceTextView.bottomAnchor.constraint(equalTo: practiceView.bottomAnchor, constant: -12),
            
            // 学习洞察区域约束
            insightsView.topAnchor.constraint(equalTo: practiceView.bottomAnchor, constant: 16),
            insightsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            insightsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            insightsView.heightAnchor.constraint(equalToConstant: 120),
            
            insightsLabel.topAnchor.constraint(equalTo: insightsView.topAnchor, constant: 12),
            insightsLabel.leadingAnchor.constraint(equalTo: insightsView.leadingAnchor, constant: 12),
            insightsLabel.trailingAnchor.constraint(equalTo: insightsView.trailingAnchor, constant: -12),
            
            insightsTextView.topAnchor.constraint(equalTo: insightsLabel.bottomAnchor, constant: 8),
            insightsTextView.leadingAnchor.constraint(equalTo: insightsView.leadingAnchor, constant: 12),
            insightsTextView.trailingAnchor.constraint(equalTo: insightsView.trailingAnchor, constant: -12),
            insightsTextView.bottomAnchor.constraint(equalTo: insightsView.bottomAnchor, constant: -12),
            
            // 会话状态区域约束
            sessionStatusView.topAnchor.constraint(equalTo: insightsView.bottomAnchor, constant: 16),
            sessionStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sessionStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sessionStatusView.heightAnchor.constraint(equalToConstant: 100),
            
            sessionStatusLabel.topAnchor.constraint(equalTo: sessionStatusView.topAnchor, constant: 12),
            sessionStatusLabel.leadingAnchor.constraint(equalTo: sessionStatusView.leadingAnchor, constant: 12),
            sessionStatusLabel.trailingAnchor.constraint(equalTo: sessionStatusView.trailingAnchor, constant: -12),
            
            sessionStatusDetailLabel.topAnchor.constraint(equalTo: sessionStatusLabel.bottomAnchor, constant: 8),
            sessionStatusDetailLabel.leadingAnchor.constraint(equalTo: sessionStatusView.leadingAnchor, constant: 12),
            sessionStatusDetailLabel.trailingAnchor.constraint(equalTo: sessionStatusView.trailingAnchor, constant: -12),
            sessionStatusDetailLabel.bottomAnchor.constraint(equalTo: sessionStatusView.bottomAnchor, constant: -12),
            
            // 控制按钮约束
            buttonStackView.topAnchor.constraint(equalTo: sessionStatusView.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        // 绑定学生数据
        viewModel.$currentStudent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] student in
                self?.updateStudentInfo(student)
            }
            .store(in: &cancellables)
        
        // 绑定对话历史
        viewModel.$conversationHistory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.conversationTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // 绑定学习洞察
        viewModel.$learningInsights
            .receive(on: DispatchQueue.main)
            .sink { [weak self] insights in
                self?.updateLearningInsights(insights)
            }
            .store(in: &cancellables)
        
        // 绑定会话状态
        viewModel.$currentSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                self?.updateSessionStatus(session)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    
    private func updateStudentInfo(_ student: DouBaoStudentProfile?) {
        guard let student = student else {
            studentNameLabel.text = "未加载学生数据"
            studentLevelLabel.text = ""
            return
        }
        
        studentNameLabel.text = "姓名: \(student.name) | 年级: \(student.grade)"
        studentLevelLabel.text = "学习风格: \(student.learningStyle.rawValue)"
    }
    
    private func updateLearningInsights(_ insights: [LearningInsight]) {
        if insights.isEmpty {
            insightsTextView.text = "暂无学习洞察"
        } else {
            let insightsText = insights.map { insight in
                "• \(insight.title): \(insight.description)"
            }.joined(separator: "\n")
            insightsTextView.text = insightsText
        }
    }
    
    private func updateSessionStatus(_ session: TutoringSession?) {
        if let session = session {
            let statusText: String
            switch session.status {
            case .active:
                statusText = "进行中"
            case .paused:
                statusText = "暂停"
            case .completed:
                statusText = "已完成"
            }
            sessionStatusDetailLabel.text = "会话ID: \(session.id)\n模式: \(session.mode.rawValue)\n状态: \(statusText)"
        } else {
            sessionStatusDetailLabel.text = "会话未开始"
        }
    }
    
    // MARK: - Actions
    
    @objc private func startSessionButtonTapped() {
        let selectedMode = TutoringMode.allCases[modePickerView.selectedRow(inComponent: 0)]
        Task {
            await viewModel.startTutoringSession(mode: selectedMode)
        }
    }
    
    @objc private func generatePracticeButtonTapped() {
        Task {
            await viewModel.generatePracticeQuestions()
        }
    }
    
    @objc private func analyzeResponseButtonTapped() {
        Task {
            await viewModel.analyzeStudentResponse("学生回答示例")
        }
    }
    
    @objc private func optimizeInteractionButtonTapped() {
        Task {
            await viewModel.optimizeResponseStyle()
        }
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension DouBaoTutoringDemoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TutoringMode.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TutoringMode.allCases[row].rawValue
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension DouBaoTutoringDemoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        let message = viewModel.conversationHistory[indexPath.row]
        let messageTuple = (role: message.sender == .ai ? "AI" : "学生", content: message.content, timestamp: message.timestamp)
        cell.configure(with: messageTuple)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - ConversationCell

private class ConversationCell: UITableViewCell {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
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
        
        contentView.addSubview(roleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            roleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            roleLabel.widthAnchor.constraint(equalToConstant: 60),
            roleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with message: (role: String, content: String, timestamp: Date)) {
        roleLabel.text = message.role
        messageLabel.text = message.content
        timeLabel.text = formatTimestamp(message.timestamp)
        
        if message.role == "学生" {
            roleLabel.backgroundColor = .systemBlue
            roleLabel.textColor = .white
        } else {
            roleLabel.backgroundColor = .systemGreen
            roleLabel.textColor = .white
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
} 