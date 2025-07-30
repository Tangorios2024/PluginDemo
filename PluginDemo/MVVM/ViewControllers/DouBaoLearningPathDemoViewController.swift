//
//  DouBaoLearningPathDemoViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/1/27.
//

import UIKit
import Combine

/// 豆包爱学学习路径演示界面
final class DouBaoLearningPathDemoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DouBaoLearningPathViewModel
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
        label.text = "豆包爱学 - 个性化学习路径"
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
    
    // MARK: - Learning Style Section
    
    private lazy var learningStyleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var learningStyleLabel: UILabel = {
        let label = UILabel()
        label.text = "学习风格分析"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var learningStyleDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Learning Path Section
    
    private lazy var learningPathView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var learningPathLabel: UILabel = {
        let label = UILabel()
        label.text = "个性化学习路径"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pathCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 120)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LearningPathCell.self, forCellWithReuseIdentifier: "LearningPathCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Module Progress Section
    
    private lazy var moduleProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var moduleProgressLabel: UILabel = {
        let label = UILabel()
        label.text = "模块进度"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moduleProgressTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ModuleProgressCell.self, forCellReuseIdentifier: "ModuleProgressCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Content Recommendation Section
    
    private lazy var contentRecommendationView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentRecommendationLabel: UILabel = {
        let label = UILabel()
        label.text = "内容推荐"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentRecommendationTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Learning Effect Section
    
    private lazy var learningEffectView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var learningEffectLabel: UILabel = {
        let label = UILabel()
        label.text = "学习效果评估"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var learningEffectTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    private lazy var loadStudentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("加载学生数据", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loadStudentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var generatePathButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("生成学习路径", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(generatePathButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var updateProgressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("更新进度", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(updateProgressButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var optimizePathButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("优化路径", for: .normal)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(optimizePathButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    init(viewModel: DouBaoLearningPathViewModel) {
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
        title = "学习路径演示"
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加标题
        contentView.addSubview(titleLabel)
        
        // 添加各个区域
        setupStudentInfoSection()
        setupLearningStyleSection()
        setupLearningPathSection()
        setupModuleProgressSection()
        setupContentRecommendationSection()
        setupLearningEffectSection()
        setupControlButtons()
    }
    
    private func setupStudentInfoSection() {
        contentView.addSubview(studentInfoView)
        studentInfoView.addSubview(studentInfoLabel)
        studentInfoView.addSubview(studentNameLabel)
        studentInfoView.addSubview(studentLevelLabel)
    }
    
    private func setupLearningStyleSection() {
        contentView.addSubview(learningStyleView)
        learningStyleView.addSubview(learningStyleLabel)
        learningStyleView.addSubview(learningStyleDetailLabel)
    }
    
    private func setupLearningPathSection() {
        contentView.addSubview(learningPathView)
        learningPathView.addSubview(learningPathLabel)
        learningPathView.addSubview(pathCollectionView)
    }
    
    private func setupModuleProgressSection() {
        contentView.addSubview(moduleProgressView)
        moduleProgressView.addSubview(moduleProgressLabel)
        moduleProgressView.addSubview(moduleProgressTableView)
    }
    
    private func setupContentRecommendationSection() {
        contentView.addSubview(contentRecommendationView)
        contentRecommendationView.addSubview(contentRecommendationLabel)
        contentRecommendationView.addSubview(contentRecommendationTextView)
    }
    
    private func setupLearningEffectSection() {
        contentView.addSubview(learningEffectView)
        learningEffectView.addSubview(learningEffectLabel)
        learningEffectView.addSubview(learningEffectTextView)
    }
    
    private func setupControlButtons() {
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(loadStudentButton)
        buttonStackView.addArrangedSubview(generatePathButton)
        buttonStackView.addArrangedSubview(updateProgressButton)
        buttonStackView.addArrangedSubview(optimizePathButton)
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
            
            // 学习风格区域约束
            learningStyleView.topAnchor.constraint(equalTo: studentInfoView.bottomAnchor, constant: 16),
            learningStyleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            learningStyleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            learningStyleView.heightAnchor.constraint(equalToConstant: 120),
            
            learningStyleLabel.topAnchor.constraint(equalTo: learningStyleView.topAnchor, constant: 12),
            learningStyleLabel.leadingAnchor.constraint(equalTo: learningStyleView.leadingAnchor, constant: 12),
            learningStyleLabel.trailingAnchor.constraint(equalTo: learningStyleView.trailingAnchor, constant: -12),
            
            learningStyleDetailLabel.topAnchor.constraint(equalTo: learningStyleLabel.bottomAnchor, constant: 8),
            learningStyleDetailLabel.leadingAnchor.constraint(equalTo: learningStyleView.leadingAnchor, constant: 12),
            learningStyleDetailLabel.trailingAnchor.constraint(equalTo: learningStyleView.trailingAnchor, constant: -12),
            learningStyleDetailLabel.bottomAnchor.constraint(equalTo: learningStyleView.bottomAnchor, constant: -12),
            
            // 学习路径区域约束
            learningPathView.topAnchor.constraint(equalTo: learningStyleView.bottomAnchor, constant: 16),
            learningPathView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            learningPathView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            learningPathView.heightAnchor.constraint(equalToConstant: 180),
            
            learningPathLabel.topAnchor.constraint(equalTo: learningPathView.topAnchor, constant: 12),
            learningPathLabel.leadingAnchor.constraint(equalTo: learningPathView.leadingAnchor, constant: 12),
            learningPathLabel.trailingAnchor.constraint(equalTo: learningPathView.trailingAnchor, constant: -12),
            
            pathCollectionView.topAnchor.constraint(equalTo: learningPathLabel.bottomAnchor, constant: 8),
            pathCollectionView.leadingAnchor.constraint(equalTo: learningPathView.leadingAnchor),
            pathCollectionView.trailingAnchor.constraint(equalTo: learningPathView.trailingAnchor),
            pathCollectionView.bottomAnchor.constraint(equalTo: learningPathView.bottomAnchor, constant: -12),
            
            // 模块进度区域约束
            moduleProgressView.topAnchor.constraint(equalTo: learningPathView.bottomAnchor, constant: 16),
            moduleProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moduleProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moduleProgressView.heightAnchor.constraint(equalToConstant: 200),
            
            moduleProgressLabel.topAnchor.constraint(equalTo: moduleProgressView.topAnchor, constant: 12),
            moduleProgressLabel.leadingAnchor.constraint(equalTo: moduleProgressView.leadingAnchor, constant: 12),
            moduleProgressLabel.trailingAnchor.constraint(equalTo: moduleProgressView.trailingAnchor, constant: -12),
            
            moduleProgressTableView.topAnchor.constraint(equalTo: moduleProgressLabel.bottomAnchor, constant: 8),
            moduleProgressTableView.leadingAnchor.constraint(equalTo: moduleProgressView.leadingAnchor),
            moduleProgressTableView.trailingAnchor.constraint(equalTo: moduleProgressView.trailingAnchor),
            moduleProgressTableView.bottomAnchor.constraint(equalTo: moduleProgressView.bottomAnchor, constant: -12),
            
            // 内容推荐区域约束
            contentRecommendationView.topAnchor.constraint(equalTo: moduleProgressView.bottomAnchor, constant: 16),
            contentRecommendationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentRecommendationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentRecommendationView.heightAnchor.constraint(equalToConstant: 120),
            
            contentRecommendationLabel.topAnchor.constraint(equalTo: contentRecommendationView.topAnchor, constant: 12),
            contentRecommendationLabel.leadingAnchor.constraint(equalTo: contentRecommendationView.leadingAnchor, constant: 12),
            contentRecommendationLabel.trailingAnchor.constraint(equalTo: contentRecommendationView.trailingAnchor, constant: -12),
            
            contentRecommendationTextView.topAnchor.constraint(equalTo: contentRecommendationLabel.bottomAnchor, constant: 8),
            contentRecommendationTextView.leadingAnchor.constraint(equalTo: contentRecommendationView.leadingAnchor, constant: 12),
            contentRecommendationTextView.trailingAnchor.constraint(equalTo: contentRecommendationView.trailingAnchor, constant: -12),
            contentRecommendationTextView.bottomAnchor.constraint(equalTo: contentRecommendationView.bottomAnchor, constant: -12),
            
            // 学习效果区域约束
            learningEffectView.topAnchor.constraint(equalTo: contentRecommendationView.bottomAnchor, constant: 16),
            learningEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            learningEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            learningEffectView.heightAnchor.constraint(equalToConstant: 120),
            
            learningEffectLabel.topAnchor.constraint(equalTo: learningEffectView.topAnchor, constant: 12),
            learningEffectLabel.leadingAnchor.constraint(equalTo: learningEffectView.leadingAnchor, constant: 12),
            learningEffectLabel.trailingAnchor.constraint(equalTo: learningEffectView.trailingAnchor, constant: -12),
            
            learningEffectTextView.topAnchor.constraint(equalTo: learningEffectLabel.bottomAnchor, constant: 8),
            learningEffectTextView.leadingAnchor.constraint(equalTo: learningEffectView.leadingAnchor, constant: 12),
            learningEffectTextView.trailingAnchor.constraint(equalTo: learningEffectView.trailingAnchor, constant: -12),
            learningEffectTextView.bottomAnchor.constraint(equalTo: learningEffectView.bottomAnchor, constant: -12),
            
            // 控制按钮约束
            buttonStackView.topAnchor.constraint(equalTo: learningEffectView.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        // 绑定学生数据
        viewModel.$studentProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] student in
                self?.updateStudentInfo(student)
            }
            .store(in: &cancellables)
        
        // 绑定学习路径
        viewModel.$learningPath
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.pathCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // 绑定进度
        viewModel.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.moduleProgressTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // 绑定内容推荐
        viewModel.$recommendations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recommendations in
                self?.updateContentRecommendations(recommendations)
            }
            .store(in: &cancellables)
        
        // 绑定评估结果
        viewModel.$assessmentResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.updateLearningEffect(results)
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
    
    private func updateContentRecommendations(_ recommendations: [ContentRecommendation]) {
        if recommendations.isEmpty {
            contentRecommendationTextView.text = "暂无内容推荐"
        } else {
            let recommendationsText = recommendations.map { recommendation in
                "• \(recommendation.title): \(recommendation.description)"
            }.joined(separator: "\n\n")
            contentRecommendationTextView.text = recommendationsText
        }
    }
    
    private func updateLearningEffect(_ results: [AssessmentResult]) {
        if results.isEmpty {
            learningEffectTextView.text = "暂无学习效果评估"
        } else {
            let resultsText = results.map { result in
                "• \(result.moduleName): \(result.score)%"
            }.joined(separator: "\n")
            learningEffectTextView.text = resultsText
        }
    }
    
    // MARK: - Actions
    
    @objc private func loadStudentButtonTapped() {
        Task {
            await viewModel.loadStudentData()
        }
    }
    
    @objc private func generatePathButtonTapped() {
        Task {
            await viewModel.generatePersonalizedPath()
        }
    }
    
    @objc private func updateProgressButtonTapped() {
        Task {
            await viewModel.assessLearningEffect()
        }
    }
    
    @objc private func optimizePathButtonTapped() {
        Task {
            await viewModel.adjustLearningPath()
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension DouBaoLearningPathDemoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.learningPath.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningPathCell", for: indexPath) as! LearningPathCell
        let step = viewModel.learningPath[indexPath.item]
        cell.configure(with: step)
        return cell
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension DouBaoLearningPathDemoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.learningPath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModuleProgressCell", for: indexPath) as! ModuleProgressCell
        let step = viewModel.learningPath[indexPath.row]
        let progress = (module: step.title, progress: Float(step.completionRate))
        cell.configure(with: progress)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - LearningPathCell

private class LearningPathCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            statusLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            statusLabel.heightAnchor.constraint(equalToConstant: 16),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with step: LearningStep) {
        titleLabel.text = step.title
        descriptionLabel.text = step.description
        
        let completionRate = step.completionRate
        if completionRate >= 1.0 {
            statusLabel.text = "已完成"
            statusLabel.backgroundColor = .systemGreen
            statusLabel.textColor = .white
        } else if completionRate > 0 {
            statusLabel.text = "进行中"
            statusLabel.backgroundColor = .systemBlue
            statusLabel.textColor = .white
        } else {
            statusLabel.text = "待开始"
            statusLabel.backgroundColor = .systemGray
            statusLabel.textColor = .white
        }
    }
}

// MARK: - ModuleProgressCell

private class ModuleProgressCell: UITableViewCell {
    
    private let moduleNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(moduleNameLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            moduleNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            moduleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moduleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            progressLabel.topAnchor.constraint(equalTo: moduleNameLabel.bottomAnchor, constant: 4),
            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 4),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with progress: (module: String, progress: Float)) {
        moduleNameLabel.text = progress.module
        progressLabel.text = "\(Int(progress.progress * 100))%"
        progressView.progress = progress.progress
        
        if progress.progress >= 1.0 {
            progressView.progressTintColor = .systemGreen
        } else if progress.progress >= 0.5 {
            progressView.progressTintColor = .systemBlue
        } else {
            progressView.progressTintColor = .systemOrange
        }
    }
} 