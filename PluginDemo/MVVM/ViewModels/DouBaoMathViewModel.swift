import Foundation
import Combine

@MainActor
final class DouBaoMathViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentStudent: DouBaoStudentProfile?
    @Published var currentProblem: MathProblem?
    @Published var learningPath: [LearningStep] = []
    @Published var pathHistory: [PathSnapshot] = []
    @Published var currentAdjustments: [PathAdjustment] = []
    @Published var analysisResult: ProblemAnalysis?
    @Published var recommendedExercises: [MathExercise] = []
    @Published var learningProgress: LearningProgress?
    @Published var userFeedback: [UserFeedback] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showPathOptimization: Bool = false
    @Published var currentStepIndex: Int = 0
    @Published var pathOptimizationSuggestions: [PathAdjustment] = []
    
    // MARK: - Private Properties
    private let mockDataProvider: DouBaoMockDataProvider
    private var cancellables = Set<AnyCancellable>()
    private var pathOptimizationTimer: Timer?
    
    // MARK: - Initialization
    init(mockDataProvider: DouBaoMockDataProvider = DouBaoMockDataProviderImpl()) {
        self.mockDataProvider = mockDataProvider
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // 监听学习路径变化，自动生成路径快照
        $learningPath
            .sink { [weak self] path in
                self?.snapshotCurrentPath()
            }
            .store(in: &cancellables)
        
        // 监听用户反馈，自动触发路径优化
        $userFeedback
            .sink { [weak self] feedback in
                if !feedback.isEmpty {
                    Task { @MainActor in
                        await self?.analyzeFeedbackAndAdjustPath()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    /// 加载学生数据
    func loadStudentData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let students = mockDataProvider.getMockStudents()
            currentStudent = students.first
            
            // 生成初始学习路径
            if let student = currentStudent {
                learningPath = mockDataProvider.generateDynamicPath(for: student)
                currentStepIndex = 0
                updateLearningProgress()
            }
            
            isLoading = false
        } catch {
            errorMessage = "加载学生数据失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 切换学生
    func switchStudent(_ student: DouBaoStudentProfile) async {
        currentStudent = student
        learningPath = mockDataProvider.generateDynamicPath(for: student)
        currentStepIndex = 0
        userFeedback.removeAll()
        currentAdjustments.removeAll()
        pathOptimizationSuggestions.removeAll()
        updateLearningProgress()
    }
    
    /// 处理数学问题
    func processMathProblem(_ imageData: Data) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 模拟OCR识别过程
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2秒
            
            let problems = mockDataProvider.getMockMathProblems()
            currentProblem = problems.randomElement()
            
            if let problem = currentProblem {
                analysisResult = generateProblemAnalysis(for: problem)
                generateRecommendedExercises(for: problem)
            }
            
            isLoading = false
        } catch {
            errorMessage = "处理数学问题失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 执行学习步骤
    func executeLearningStep(_ step: LearningStep) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 模拟步骤执行过程
            try await Task.sleep(nanoseconds: UInt64(step.duration * 1_000_000_000))
            
            // 模拟用户反馈
            let feedback = mockDataProvider.simulateFeedback(for: step)
            userFeedback.append(feedback)
            
            // 更新进度
            currentStepIndex = min(currentStepIndex + 1, learningPath.count - 1)
            updateLearningProgress()
            
            isLoading = false
        } catch {
            errorMessage = "执行学习步骤失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 收集用户反馈
    func collectUserFeedback(_ feedback: UserFeedback) async {
        userFeedback.append(feedback)
        
        // 根据反馈生成路径调整建议
        let adjustment = mockDataProvider.generatePathAdjustment(for: feedback)
        pathOptimizationSuggestions.append(adjustment)
        
        // 如果反馈评分较低，立即显示优化建议
        if feedback.rating < 3.0 {
            showPathOptimization = true
        }
    }
    
    /// 应用路径调整
    func applyPathAdjustment(_ adjustment: PathAdjustment) async {
        isLoading = true
        
        do {
            // 创建新的学习步骤
            let newStep = createLearningStep(for: adjustment)
            
            // 应用调整
            if let insertionPoint = adjustment.insertionPoint {
                // 插入新步骤
                let insertIndex = min(insertionPoint, learningPath.count)
                learningPath.insert(newStep, at: insertIndex)
                
                // 更新当前步骤索引
                if currentStepIndex >= insertIndex {
                    currentStepIndex += 1
                }
            } else if let removalPoint = adjustment.removalPoint {
                // 移除步骤
                if removalPoint < learningPath.count {
                    learningPath.remove(at: removalPoint)
                    
                    // 更新当前步骤索引
                    if currentStepIndex >= removalPoint {
                        currentStepIndex = max(0, currentStepIndex - 1)
                    }
                }
            }
            
            // 标记调整已应用
            var updatedAdjustment = adjustment
            updatedAdjustment = PathAdjustment(
                id: adjustment.id,
                strategy: adjustment.strategy,
                reason: adjustment.reason,
                confidence: adjustment.confidence,
                expectedImpact: adjustment.expectedImpact,
                insertionPoint: adjustment.insertionPoint,
                removalPoint: adjustment.removalPoint,
                applied: true
            )
            
            // 更新调整列表
            if let index = currentAdjustments.firstIndex(where: { $0.id == adjustment.id }) {
                currentAdjustments[index] = updatedAdjustment
            } else {
                currentAdjustments.append(updatedAdjustment)
            }
            
            // 移除已应用的优化建议
            pathOptimizationSuggestions.removeAll { $0.id == adjustment.id }
            
            updateLearningProgress()
            isLoading = false
        } catch {
            errorMessage = "应用路径调整失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 分析反馈并调整路径
    func analyzeFeedbackAndAdjustPath() async {
        guard !userFeedback.isEmpty else { return }
        
        // 分析最近的反馈
        let recentFeedback = Array(userFeedback.suffix(3))
        let averageRating = recentFeedback.map { $0.rating }.reduce(0, +) / Double(recentFeedback.count)
        
        // 如果平均评分较低，生成优化建议
        if averageRating < 3.5 {
            let adjustment = mockDataProvider.generatePathAdjustment(for: recentFeedback.last!)
            pathOptimizationSuggestions.append(adjustment)
            showPathOptimization = true
        }
    }
    
    /// 快照当前路径
    func snapshotCurrentPath() {
        let metrics = PathMetrics(
            totalSteps: learningPath.count,
            estimatedDuration: learningPath.reduce(0) { $0 + $1.duration },
            difficulty: Double(learningPath.map { $0.difficulty }.reduce(0, +)) / Double(learningPath.count),
            engagement: calculateEngagement(),
            effectiveness: calculateEffectiveness()
        )
        
        let snapshot = PathSnapshot(
            steps: learningPath,
            metrics: metrics,
            adjustments: currentAdjustments,
            version: pathHistory.count + 1
        )
        
        pathHistory.append(snapshot)
    }
    
    /// 回退到之前的路径
    func revertToPreviousPath() async {
        guard pathHistory.count > 1 else { return }
        
        let previousSnapshot = pathHistory[pathHistory.count - 2]
        learningPath = previousSnapshot.steps
        currentAdjustments = previousSnapshot.adjustments
        currentStepIndex = 0
        pathHistory.removeLast()
        updateLearningProgress()
    }
    
    /// 预测最优路径
    func predictOptimalPath() async {
        isLoading = true
        
        do {
            // 模拟AI预测过程
            try await Task.sleep(nanoseconds: 3_000_000_000) // 3秒
            
            if let student = currentStudent {
                let optimalPath = mockDataProvider.generateDynamicPath(for: student)
                
                // 添加一些优化步骤
                var enhancedPath = optimalPath
                let allSteps = mockDataProvider.getMockLearningSteps()
                
                // 根据学生特点添加个性化步骤
                if student.learningStyle == .visual {
                    enhancedPath.insert(allSteps[8], at: 2) // 可视化图表
                }
                if student.learningStyle == .auditory {
                    enhancedPath.insert(allSteps[9], at: 2) // 音频讲解
                }
                
                learningPath = enhancedPath
                currentStepIndex = 0
                updateLearningProgress()
            }
            
            isLoading = false
        } catch {
            errorMessage = "预测最优路径失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 生成学习报告
    func generateReport() async -> String {
        guard let student = currentStudent else { return "无学生数据" }
        
        let totalTime = learningPath.reduce(0) { $0 + $1.duration }
        let averageRating = userFeedback.isEmpty ? 0 : userFeedback.map { $0.rating }.reduce(0, +) / Double(userFeedback.count)
        let adjustmentsCount = currentAdjustments.count
        
        return """
        学习报告
        
        学生信息：
        - 姓名：\(student.name)
        - 年级：\(student.grade)
        - 学习类型：\(student.studentType.rawValue)
        - 学习风格：\(student.learningStyle.rawValue)
        
        学习统计：
        - 总学习时间：\(Int(totalTime / 60))分钟
        - 学习步骤数：\(learningPath.count)
        - 平均反馈评分：\(String(format: "%.1f", averageRating))
        - 路径调整次数：\(adjustmentsCount)
        
        学习效果：
        - 完成度：\(String(format: "%.1f%%", learningProgress?.completionPercentage ?? 0))
        - 当前步骤：\(currentStepIndex + 1)/\(learningPath.count)
        
        优化建议：
        \(generateOptimizationSummary())
        """
    }
    
    // MARK: - Private Methods
    
    private func updateLearningProgress() {
        let totalSteps = learningPath.count
        let completedSteps = currentStepIndex
        let currentStepProgress = 0.5 // 模拟当前步骤进度
        let overallProgress = totalSteps > 0 ? Double(completedSteps) / Double(totalSteps) : 0
        let timeSpent = learningPath.prefix(completedSteps).reduce(0) { $0 + $1.duration }
        let estimatedTimeRemaining = learningPath.suffix(from: completedSteps).reduce(0) { $0 + $1.duration }
        
        learningProgress = LearningProgress(
            currentStepIndex: currentStepIndex,
            completedSteps: completedSteps,
            totalSteps: totalSteps,
            currentStepProgress: currentStepProgress,
            overallProgress: overallProgress,
            timeSpent: timeSpent,
            estimatedTimeRemaining: estimatedTimeRemaining
        )
    }
    
    private func generateProblemAnalysis(for problem: MathProblem) -> ProblemAnalysis {
        return ProblemAnalysis(
            problemType: problem.topic,
            difficulty: problem.difficulty,
            keyConcepts: problem.tags,
            solutionSteps: problem.solution.components(separatedBy: "\n"),
            commonMistakes: ["计算错误", "概念混淆", "步骤遗漏"],
            tips: ["仔细审题", "按步骤解题", "检查答案"],
            relatedTopics: ["基础运算", "应用题"],
            estimatedTime: TimeInterval(problem.difficulty * 60)
        )
    }
    
    private func generateRecommendedExercises(for problem: MathProblem) {
        let allProblems = mockDataProvider.getMockMathProblems()
        let relatedProblems = allProblems.filter { $0.topic == problem.topic && $0.id != problem.id }
        
        recommendedExercises = relatedProblems.prefix(3).map { problem in
            MathExercise(
                title: problem.title,
                content: problem.content,
                difficulty: problem.difficulty,
                topic: problem.topic,
                solution: problem.solution,
                explanation: problem.explanation
            )
        }
    }
    
    private func createLearningStep(for adjustment: PathAdjustment) -> LearningStep {
        let allSteps = mockDataProvider.getMockLearningSteps()
        
        switch adjustment.strategy {
        case .addConceptExplanation:
            return allSteps[2] // 概念讲解
        case .addVisualAid:
            return allSteps[8] // 可视化图表
        case .addAudioExplanation:
            return allSteps[9] // 音频讲解
        case .addInteractiveDemo:
            return allSteps[3] // 交互演示
        case .addGamification:
            return allSteps[10] // 游戏化
        case .addRealWorldExample:
            return allSteps[11] // 实际应用
        case .addPeerLearning:
            return allSteps[12] // 同伴学习
        case .addReviewSession:
            return allSteps[13] // 复习巩固
        case .addExtensionActivity:
            return allSteps[14] // 拓展活动
        case .addPracticeDrill:
            return allSteps[4] // 基础练习
        default:
            return allSteps[2] // 默认概念讲解
        }
    }
    
    private func calculateEngagement() -> Double {
        let engagementFeedback = userFeedback.filter { $0.type == .engagement }
        guard !engagementFeedback.isEmpty else { return 0.7 }
        
        let averageRating = engagementFeedback.map { $0.rating }.reduce(0, +) / Double(engagementFeedback.count)
        return averageRating / 5.0
    }
    
    private func calculateEffectiveness() -> Double {
        let comprehensionFeedback = userFeedback.filter { $0.type == .comprehension }
        guard !comprehensionFeedback.isEmpty else { return 0.7 }
        
        let averageRating = comprehensionFeedback.map { $0.rating }.reduce(0, +) / Double(comprehensionFeedback.count)
        return averageRating / 5.0
    }
    
    private func generateOptimizationSummary() -> String {
        guard !pathOptimizationSuggestions.isEmpty else { return "暂无优化建议" }
        
        return pathOptimizationSuggestions.map { suggestion in
            "- \(suggestion.strategy.rawValue)：\(suggestion.reason)"
        }.joined(separator: "\n")
    }
    
    // MARK: - Timer Management
    
    func startPathOptimizationTimer() {
        pathOptimizationTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.analyzeFeedbackAndAdjustPath()
            }
        }
    }
    
    func stopPathOptimizationTimer() {
        pathOptimizationTimer?.invalidate()
        pathOptimizationTimer = nil
    }
    
    deinit {
        // 注意：在deinit中调用MainActor隔离的方法需要特殊处理
        // 这里我们暂时注释掉，因为Timer会在对象释放时自动失效
        // stopPathOptimizationTimer()
    }
} 