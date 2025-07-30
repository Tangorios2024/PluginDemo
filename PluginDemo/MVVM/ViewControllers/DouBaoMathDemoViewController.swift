import UIKit
import Combine

class DouBaoMathDemoViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 学生信息区域
    private let studentInfoView = UIView()
    private let studentNameLabel = UILabel()
    private let studentTypeLabel = UILabel()
    private let studentStyleLabel = UILabel()
    private let studentPicker = UIPickerView()
    
    // 学习路径区域
    private let pathContainerView = UIView()
    private let pathTitleLabel = UILabel()
    private let pathCollectionView: UICollectionView
    private let pathProgressView = UIProgressView()
    private let progressLabel = UILabel()
    
    // 路径优化区域
    private let optimizationView = UIView()
    private let optimizationTitleLabel = UILabel()
    private let optimizationTableView = UITableView()
    
    // 反馈区域
    private let feedbackView = UIView()
    private let feedbackTitleLabel = UILabel()
    private let feedbackTableView = UITableView()
    
    // 控制按钮
    private let buttonStackView = UIStackView()
    private let loadDataButton = UIButton()
    private let executeStepButton = UIButton()
    private let optimizePathButton = UIButton()
    private let generateReportButton = UIButton()
    private let predictPathButton = UIButton()
    
    // 状态显示
    private let statusLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    private let viewModel = DouBaoMathViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var students: [DouBaoStudentProfile] = []
    private var selectedStudentIndex = 0
    
    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 120)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        pathCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupCollectionView()
        setupTableView()
        setupPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.loadStudentData()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "豆包爱学 - 数学学习"
        
        setupScrollView()
        setupStudentInfoSection()
        setupPathSection()
        setupOptimizationSection()
        setupFeedbackSection()
        setupControlButtons()
        setupStatusSection()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupStudentInfoSection() {
        contentView.addSubview(studentInfoView)
        studentInfoView.addSubview(studentNameLabel)
        studentInfoView.addSubview(studentTypeLabel)
        studentInfoView.addSubview(studentStyleLabel)
        studentInfoView.addSubview(studentPicker)
        
        studentInfoView.backgroundColor = .systemGray6
        studentInfoView.layer.cornerRadius = 12
        
        studentNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        studentNameLabel.textColor = .label
        
        studentTypeLabel.font = .systemFont(ofSize: 14)
        studentTypeLabel.textColor = .secondaryLabel
        
        studentStyleLabel.font = .systemFont(ofSize: 14)
        studentStyleLabel.textColor = .secondaryLabel
        
        studentPicker.dataSource = self
        studentPicker.delegate = self
        
        studentInfoView.translatesAutoresizingMaskIntoConstraints = false
        studentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        studentTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        studentStyleLabel.translatesAutoresizingMaskIntoConstraints = false
        studentPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            studentInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            studentInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            studentInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            studentInfoView.heightAnchor.constraint(equalToConstant: 120),
            
            studentNameLabel.topAnchor.constraint(equalTo: studentInfoView.topAnchor, constant: 12),
            studentNameLabel.leadingAnchor.constraint(equalTo: studentInfoView.leadingAnchor, constant: 12),
            studentNameLabel.trailingAnchor.constraint(equalTo: studentInfoView.trailingAnchor, constant: -12),
            
            studentTypeLabel.topAnchor.constraint(equalTo: studentNameLabel.bottomAnchor, constant: 4),
            studentTypeLabel.leadingAnchor.constraint(equalTo: studentInfoView.leadingAnchor, constant: 12),
            studentTypeLabel.trailingAnchor.constraint(equalTo: studentInfoView.trailingAnchor, constant: -12),
            
            studentStyleLabel.topAnchor.constraint(equalTo: studentTypeLabel.bottomAnchor, constant: 4),
            studentStyleLabel.leadingAnchor.constraint(equalTo: studentInfoView.leadingAnchor, constant: 12),
            studentStyleLabel.trailingAnchor.constraint(equalTo: studentInfoView.trailingAnchor, constant: -12),
            
            studentPicker.topAnchor.constraint(equalTo: studentStyleLabel.bottomAnchor, constant: 8),
            studentPicker.leadingAnchor.constraint(equalTo: studentInfoView.leadingAnchor, constant: 12),
            studentPicker.trailingAnchor.constraint(equalTo: studentInfoView.trailingAnchor, constant: -12),
            studentPicker.bottomAnchor.constraint(equalTo: studentInfoView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupPathSection() {
        contentView.addSubview(pathContainerView)
        pathContainerView.addSubview(pathTitleLabel)
        pathContainerView.addSubview(pathCollectionView)
        pathContainerView.addSubview(pathProgressView)
        pathContainerView.addSubview(progressLabel)
        
        pathContainerView.backgroundColor = .systemBackground
        pathContainerView.layer.cornerRadius = 12
        pathContainerView.layer.borderWidth = 1
        pathContainerView.layer.borderColor = UIColor.systemGray4.cgColor
        
        pathTitleLabel.text = "学习路径"
        pathTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        pathTitleLabel.textColor = .label
        
        pathProgressView.progressTintColor = .systemBlue
        pathProgressView.trackTintColor = .systemGray5
        
        progressLabel.font = .systemFont(ofSize: 12)
        progressLabel.textColor = .secondaryLabel
        progressLabel.textAlignment = .center
        
        pathContainerView.translatesAutoresizingMaskIntoConstraints = false
        pathTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        pathCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pathProgressView.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pathContainerView.topAnchor.constraint(equalTo: studentInfoView.bottomAnchor, constant: 16),
            pathContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pathContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pathContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            pathTitleLabel.topAnchor.constraint(equalTo: pathContainerView.topAnchor, constant: 12),
            pathTitleLabel.leadingAnchor.constraint(equalTo: pathContainerView.leadingAnchor, constant: 12),
            pathTitleLabel.trailingAnchor.constraint(equalTo: pathContainerView.trailingAnchor, constant: -12),
            
            pathCollectionView.topAnchor.constraint(equalTo: pathTitleLabel.bottomAnchor, constant: 8),
            pathCollectionView.leadingAnchor.constraint(equalTo: pathContainerView.leadingAnchor, constant: 12),
            pathCollectionView.trailingAnchor.constraint(equalTo: pathContainerView.trailingAnchor, constant: -12),
            pathCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            pathProgressView.topAnchor.constraint(equalTo: pathCollectionView.bottomAnchor, constant: 8),
            pathProgressView.leadingAnchor.constraint(equalTo: pathContainerView.leadingAnchor, constant: 12),
            pathProgressView.trailingAnchor.constraint(equalTo: pathContainerView.trailingAnchor, constant: -12),
            
            progressLabel.topAnchor.constraint(equalTo: pathProgressView.bottomAnchor, constant: 4),
            progressLabel.leadingAnchor.constraint(equalTo: pathContainerView.leadingAnchor, constant: 12),
            progressLabel.trailingAnchor.constraint(equalTo: pathContainerView.trailingAnchor, constant: -12),
            progressLabel.bottomAnchor.constraint(equalTo: pathContainerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupOptimizationSection() {
        contentView.addSubview(optimizationView)
        optimizationView.addSubview(optimizationTitleLabel)
        optimizationView.addSubview(optimizationTableView)
        
        optimizationView.backgroundColor = .systemBackground
        optimizationView.layer.cornerRadius = 12
        optimizationView.layer.borderWidth = 1
        optimizationView.layer.borderColor = UIColor.systemGray4.cgColor
        
        optimizationTitleLabel.text = "路径优化建议"
        optimizationTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        optimizationTitleLabel.textColor = .label
        
        optimizationView.translatesAutoresizingMaskIntoConstraints = false
        optimizationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        optimizationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            optimizationView.topAnchor.constraint(equalTo: pathContainerView.bottomAnchor, constant: 16),
            optimizationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optimizationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optimizationView.heightAnchor.constraint(equalToConstant: 150),
            
            optimizationTitleLabel.topAnchor.constraint(equalTo: optimizationView.topAnchor, constant: 12),
            optimizationTitleLabel.leadingAnchor.constraint(equalTo: optimizationView.leadingAnchor, constant: 12),
            optimizationTitleLabel.trailingAnchor.constraint(equalTo: optimizationView.trailingAnchor, constant: -12),
            
            optimizationTableView.topAnchor.constraint(equalTo: optimizationTitleLabel.bottomAnchor, constant: 8),
            optimizationTableView.leadingAnchor.constraint(equalTo: optimizationView.leadingAnchor, constant: 12),
            optimizationTableView.trailingAnchor.constraint(equalTo: optimizationView.trailingAnchor, constant: -12),
            optimizationTableView.bottomAnchor.constraint(equalTo: optimizationView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupFeedbackSection() {
        contentView.addSubview(feedbackView)
        feedbackView.addSubview(feedbackTitleLabel)
        feedbackView.addSubview(feedbackTableView)
        
        feedbackView.backgroundColor = .systemBackground
        feedbackView.layer.cornerRadius = 12
        feedbackView.layer.borderWidth = 1
        feedbackView.layer.borderColor = UIColor.systemGray4.cgColor
        
        feedbackTitleLabel.text = "用户反馈"
        feedbackTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        feedbackTitleLabel.textColor = .label
        
        feedbackView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feedbackView.topAnchor.constraint(equalTo: optimizationView.bottomAnchor, constant: 16),
            feedbackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            feedbackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            feedbackView.heightAnchor.constraint(equalToConstant: 150),
            
            feedbackTitleLabel.topAnchor.constraint(equalTo: feedbackView.topAnchor, constant: 12),
            feedbackTitleLabel.leadingAnchor.constraint(equalTo: feedbackView.leadingAnchor, constant: 12),
            feedbackTitleLabel.trailingAnchor.constraint(equalTo: feedbackView.trailingAnchor, constant: -12),
            
            feedbackTableView.topAnchor.constraint(equalTo: feedbackTitleLabel.bottomAnchor, constant: 8),
            feedbackTableView.leadingAnchor.constraint(equalTo: feedbackView.leadingAnchor, constant: 12),
            feedbackTableView.trailingAnchor.constraint(equalTo: feedbackView.trailingAnchor, constant: -12),
            feedbackTableView.bottomAnchor.constraint(equalTo: feedbackView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupControlButtons() {
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(loadDataButton)
        buttonStackView.addArrangedSubview(executeStepButton)
        buttonStackView.addArrangedSubview(optimizePathButton)
        buttonStackView.addArrangedSubview(generateReportButton)
        buttonStackView.addArrangedSubview(predictPathButton)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 8
        
        loadDataButton.setTitle("加载数据", for: .normal)
        loadDataButton.backgroundColor = .systemBlue
        loadDataButton.layer.cornerRadius = 8
        loadDataButton.addTarget(self, action: #selector(loadDataTapped), for: .touchUpInside)
        
        executeStepButton.setTitle("执行步骤", for: .normal)
        executeStepButton.backgroundColor = .systemGreen
        executeStepButton.layer.cornerRadius = 8
        executeStepButton.addTarget(self, action: #selector(executeStepTapped), for: .touchUpInside)
        
        optimizePathButton.setTitle("优化路径", for: .normal)
        optimizePathButton.backgroundColor = .systemOrange
        optimizePathButton.layer.cornerRadius = 8
        optimizePathButton.addTarget(self, action: #selector(optimizePathTapped), for: .touchUpInside)
        
        generateReportButton.setTitle("生成报告", for: .normal)
        generateReportButton.backgroundColor = .systemPurple
        generateReportButton.layer.cornerRadius = 8
        generateReportButton.addTarget(self, action: #selector(generateReportTapped), for: .touchUpInside)
        
        predictPathButton.setTitle("预测路径", for: .normal)
        predictPathButton.backgroundColor = .systemTeal
        predictPathButton.layer.cornerRadius = 8
        predictPathButton.addTarget(self, action: #selector(predictPathTapped), for: .touchUpInside)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: feedbackView.bottomAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupStatusSection() {
        contentView.addSubview(statusLabel)
        contentView.addSubview(loadingIndicator)
        
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        
        loadingIndicator.hidesWhenStopped = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        pathCollectionView.backgroundColor = .clear
        pathCollectionView.delegate = self
        pathCollectionView.dataSource = self
        pathCollectionView.register(LearningStepCell.self, forCellWithReuseIdentifier: "LearningStepCell")
        pathCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupTableView() {
        optimizationTableView.delegate = self
        optimizationTableView.dataSource = self
        optimizationTableView.register(OptimizationCell.self, forCellReuseIdentifier: "OptimizationCell")
        optimizationTableView.backgroundColor = .clear
        optimizationTableView.separatorStyle = .none
        
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.register(FeedbackCell.self, forCellReuseIdentifier: "FeedbackCell")
        feedbackTableView.backgroundColor = .clear
        feedbackTableView.separatorStyle = .none
    }
    
    private func setupPickerView() {
        students = DouBaoMockDataProviderImpl().getMockStudents()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        // 学生信息绑定
        viewModel.$currentStudent
            .sink { [weak self] student in
                self?.updateStudentInfo(student)
            }
            .store(in: &cancellables)
        
        // 学习路径绑定
        viewModel.$learningPath
            .sink { [weak self] _ in
                self?.pathCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // 学习进度绑定
        viewModel.$learningProgress
            .sink { [weak self] progress in
                self?.updateProgress(progress)
            }
            .store(in: &cancellables)
        
        // 优化建议绑定
        viewModel.$pathOptimizationSuggestions
            .sink { [weak self] _ in
                self?.optimizationTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // 用户反馈绑定
        viewModel.$userFeedback
            .sink { [weak self] _ in
                self?.feedbackTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // 加载状态绑定
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // 错误信息绑定
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
        
        // 当前步骤索引绑定
        viewModel.$currentStepIndex
            .sink { [weak self] index in
                self?.updateCurrentStep(index)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateStudentInfo(_ student: DouBaoStudentProfile?) {
        guard let student = student else { return }
        
        studentNameLabel.text = "学生：\(student.name) (\(student.grade))"
        studentTypeLabel.text = "类型：\(student.studentType.rawValue) - \(student.studentType.description)"
        studentStyleLabel.text = "风格：\(student.learningStyle.rawValue) - \(student.learningStyle.description)"
    }
    
    private func updateProgress(_ progress: LearningProgress?) {
        guard let progress = progress else { return }
        
        pathProgressView.progress = Float(progress.overallProgress)
        progressLabel.text = "进度：\(String(format: "%.1f%%", progress.completionPercentage)) (\(progress.completedSteps)/\(progress.totalSteps))"
    }
    
    private func updateCurrentStep(_ index: Int) {
        // 检查是否有数据可以滚动
        guard !viewModel.learningPath.isEmpty && index < viewModel.learningPath.count else {
            // 如果没有数据，禁用执行按钮
            executeStepButton.isEnabled = false
            return
        }
        
        // 滚动到当前步骤
        let indexPath = IndexPath(item: index, section: 0)
        pathCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // 更新UI状态
        executeStepButton.isEnabled = index < viewModel.learningPath.count
    }
    

    
    // MARK: - Actions
    @objc private func loadDataTapped() {
        Task {
            await viewModel.loadStudentData()
        }
    }
    
    @objc private func executeStepTapped() {
        guard viewModel.currentStepIndex < viewModel.learningPath.count else { return }
        
        let step = viewModel.learningPath[viewModel.currentStepIndex]
        Task {
            await viewModel.executeLearningStep(step)
        }
    }
    
    @objc private func optimizePathTapped() {
        Task {
            await viewModel.analyzeFeedbackAndAdjustPath()
        }
    }
    
    @objc private func generateReportTapped() {
        Task {
            let report = await viewModel.generateReport()
            showAlert(title: "学习报告", message: report)
        }
    }
    
    @objc private func predictPathTapped() {
        Task {
            await viewModel.predictOptimalPath()
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String = "提示", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension DouBaoMathDemoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.learningPath.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningStepCell", for: indexPath) as! LearningStepCell
        let step = viewModel.learningPath[indexPath.item]
        let isCurrentStep = indexPath.item == viewModel.currentStepIndex
        cell.configure(with: step, isCurrent: isCurrentStep)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 可以添加步骤详情展示
        let step = viewModel.learningPath[indexPath.item]
        showAlert(title: step.title, message: step.description)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DouBaoMathDemoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == optimizationTableView {
            return viewModel.pathOptimizationSuggestions.count
        } else {
            return viewModel.userFeedback.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == optimizationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptimizationCell", for: indexPath) as! OptimizationCell
            let adjustment = viewModel.pathOptimizationSuggestions[indexPath.row]
            cell.configure(with: adjustment)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackCell
            let feedback = viewModel.userFeedback[indexPath.row]
            cell.configure(with: feedback)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == optimizationTableView {
            let adjustment = viewModel.pathOptimizationSuggestions[indexPath.row]
            showOptimizationActionSheet(for: adjustment)
        }
    }
    
    private func showOptimizationActionSheet(for adjustment: PathAdjustment) {
        let alert = UIAlertController(title: "路径优化", message: adjustment.reason, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "应用调整", style: .default) { _ in
            Task {
                await self.viewModel.applyPathAdjustment(adjustment)
            }
        })
        
        alert.addAction(UIAlertAction(title: "忽略", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension DouBaoMathDemoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return students.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let student = students[row]
        return "\(student.name) (\(student.studentType.rawValue))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStudentIndex = row
        let student = students[row]
        Task {
            await viewModel.switchStudent(student)
        }
    }
}

// MARK: - Custom Cells
class LearningStepCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let typeLabel = UILabel()
    private let durationLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(durationLabel)
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        
        typeLabel.font = .systemFont(ofSize: 12)
        typeLabel.textColor = .secondaryLabel
        
        durationLabel.font = .systemFont(ofSize: 10)
        durationLabel.textColor = .tertiaryLabel
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            durationLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            durationLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with step: LearningStep, isCurrent: Bool) {
        titleLabel.text = step.title
        typeLabel.text = step.type.rawValue
        durationLabel.text = "\(Int(step.duration / 60))分钟"
        
        if let image = UIImage(systemName: step.type.icon) {
            iconImageView.image = image
        }
        
        if isCurrent {
            contentView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            contentView.backgroundColor = .systemBackground
            contentView.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
}

class OptimizationCell: UITableViewCell {
    private let strategyLabel = UILabel()
    private let reasonLabel = UILabel()
    private let confidenceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(strategyLabel)
        contentView.addSubview(reasonLabel)
        contentView.addSubview(confidenceLabel)
        
        strategyLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        strategyLabel.textColor = .label
        
        reasonLabel.font = .systemFont(ofSize: 12)
        reasonLabel.textColor = .secondaryLabel
        reasonLabel.numberOfLines = 2
        
        confidenceLabel.font = .systemFont(ofSize: 10)
        confidenceLabel.textColor = .tertiaryLabel
        
        strategyLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            strategyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            strategyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            strategyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            reasonLabel.topAnchor.constraint(equalTo: strategyLabel.bottomAnchor, constant: 4),
            reasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            reasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            confidenceLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 4),
            confidenceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            confidenceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            confidenceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with adjustment: PathAdjustment) {
        strategyLabel.text = adjustment.strategy.rawValue
        reasonLabel.text = adjustment.reason
        confidenceLabel.text = "置信度: \(String(format: "%.1f%%", adjustment.confidence * 100))"
    }
}

class FeedbackCell: UITableViewCell {
    private let typeLabel = UILabel()
    private let contentLabel = UILabel()
    private let ratingLabel = UILabel()
    private let emotionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(typeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(emotionLabel)
        
        typeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        typeLabel.textColor = .label
        
        contentLabel.font = .systemFont(ofSize: 12)
        contentLabel.textColor = .secondaryLabel
        contentLabel.numberOfLines = 2
        
        ratingLabel.font = .systemFont(ofSize: 10)
        ratingLabel.textColor = .tertiaryLabel
        
        emotionLabel.font = .systemFont(ofSize: 16)
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            typeLabel.trailingAnchor.constraint(equalTo: emotionLabel.leadingAnchor, constant: -8),
            
            contentLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            ratingLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            emotionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emotionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            emotionLabel.widthAnchor.constraint(equalToConstant: 30),
            emotionLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with feedback: UserFeedback) {
        typeLabel.text = feedback.type.rawValue
        contentLabel.text = feedback.content
        ratingLabel.text = "评分: \(String(format: "%.1f", feedback.rating))/5.0"
        
        if let emotion = feedback.emotionalState {
            emotionLabel.text = emotion.emoji
        } else {
            emotionLabel.text = ""
        }
    }
} 