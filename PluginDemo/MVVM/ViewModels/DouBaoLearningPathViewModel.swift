import Foundation
import Combine

@MainActor
final class DouBaoLearningPathViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var studentProfile: DouBaoStudentProfile?
    @Published var learningPath: [LearningStep] = []
    @Published var pathEvolution: [PathSnapshot] = []
    @Published var currentModule: LearningModule?
    @Published var progress: ModuleProgress?
    @Published var recommendations: [ContentRecommendation] = []
    @Published var assessmentResults: [AssessmentResult] = []
    @Published var feedbackMetrics: [FeedbackMetric] = []
    @Published var optimizationSuggestions: [PathAdjustment] = []
    @Published var isPathGenerating: Bool = false
    @Published var isOptimizing: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentStepIndex: Int = 0
    
    // MARK: - Private Properties
    private let mockDataProvider: DouBaoMockDataProvider
    private var cancellables = Set<AnyCancellable>()
    
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
        
        // 监听反馈指标，自动触发路径优化
        $feedbackMetrics
            .sink { [weak self] metrics in
                if !metrics.isEmpty {
                    Task { @MainActor in
                        await self?.analyzePathEffectiveness()
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
            studentProfile = students.first
            
            // 生成初始学习路径
            if let student = studentProfile {
                await generatePersonalizedPath()
            }
            
            isLoading = false
        } catch {
            errorMessage = "加载学生数据失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 分析学习风格
    func analyzeLearningStyle() async {
        guard let student = studentProfile else { return }
        
        // 根据学生偏好分析学习风格
        let styleAnalysis = LearningStyleAnalysis(
            primaryStyle: student.learningStyle,
            secondaryStyle: determineSecondaryStyle(for: student),
            confidence: 0.85,
            recommendations: generateStyleRecommendations(for: student)
        )
        
        // 更新学习路径
        await generatePersonalizedPath()
    }
    
    /// 生成个性化路径
    func generatePersonalizedPath() async {
        guard let student = studentProfile else { return }
        
        isPathGenerating = true
        
        do {
            // 模拟路径生成过程
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2秒
            
            // 根据学习风格生成基础路径
            var basePath = mockDataProvider.generateDynamicPath(for: student)
            
            // 根据学生偏好添加个性化内容
            if student.learningStyle == .visual {
                basePath = addVisualElements(to: basePath)
            }
            if student.learningStyle == .auditory {
                basePath = addAudioElements(to: basePath)
            }
            if student.learningStyle == .kinesthetic {
                basePath = addInteractiveElements(to: basePath)
            }
            
            learningPath = basePath
            currentStepIndex = 0
            updateModuleProgress()
            
            isPathGenerating = false
        } catch {
            errorMessage = "生成个性化路径失败: \(error.localizedDescription)"
            isPathGenerating = false
        }
    }
    
    /// 开始学习模块
    func startLearningModule(_ module: LearningModule) async {
        currentModule = module
        currentStepIndex = 0
        updateModuleProgress()
    }
    
    /// 更新模块进度
    func updateModuleProgress() {
        let totalSteps = learningPath.count
        let completedSteps = currentStepIndex
        let currentStepProgress = 0.5 // 模拟当前步骤进度
        let overallProgress = totalSteps > 0 ? Double(completedSteps) / Double(totalSteps) : 0
        let timeSpent = learningPath.prefix(completedSteps).reduce(0) { $0 + $1.duration }
        let estimatedTimeRemaining = learningPath.suffix(from: completedSteps).reduce(0) { $0 + $1.duration }
        
        progress = ModuleProgress(
            currentStepIndex: currentStepIndex,
            completedSteps: completedSteps,
            totalSteps: totalSteps,
            currentStepProgress: currentStepProgress,
            overallProgress: overallProgress,
            timeSpent: timeSpent,
            estimatedTimeRemaining: estimatedTimeRemaining,
            moduleName: currentModule?.name ?? "学习路径"
        )
    }
    
    /// 获取内容推荐
    func getContentRecommendations() async {
        guard let student = studentProfile else { return }
        
        // 根据学习历史和偏好生成推荐
        let recommendations = generateRecommendations(for: student)
        self.recommendations = recommendations
    }
    
    /// 评估学习效果
    func assessLearningEffect() async {
        // 模拟学习效果评估
        let assessment = AssessmentResult(
            moduleName: "数学基础模块",
            score: Double.random(in: 70...95),
            accuracy: Double.random(in: 0.8...0.95),
            timeSpent: TimeInterval.random(in: 300...1800),
            difficulty: Int.random(in: 1...5),
            feedback: "学习效果良好，建议继续当前路径"
        )
        
        assessmentResults.append(assessment)
    }
    
    /// 调整学习路径
    func adjustLearningPath() async {
        guard !optimizationSuggestions.isEmpty else { return }
        
        // 应用第一个优化建议
        let suggestion = optimizationSuggestions.first!
        await applyOptimization(suggestion)
    }
    
    // MARK: - 动态路径优化方法
    
    /// 收集反馈指标
    func collectFeedbackMetrics() async {
        // 模拟收集反馈指标
        let metrics = [
            FeedbackMetric(type: .comprehension, value: Double.random(in: 0.6...0.9), timestamp: Date()),
            FeedbackMetric(type: .engagement, value: Double.random(in: 0.5...0.8), timestamp: Date()),
            FeedbackMetric(type: .satisfaction, value: Double.random(in: 0.7...0.9), timestamp: Date())
        ]
        
        feedbackMetrics.append(contentsOf: metrics)
    }
    
    /// 分析路径有效性
    func analyzePathEffectiveness() async {
        guard !feedbackMetrics.isEmpty else { return }
        
        // 分析最近的反馈指标
        let recentMetrics = Array(feedbackMetrics.suffix(5))
        let averageComprehension = recentMetrics.filter { $0.type == .comprehension }.map { $0.value }.reduce(0, +) / Double(recentMetrics.filter { $0.type == .comprehension }.count)
        let averageEngagement = recentMetrics.filter { $0.type == .engagement }.map { $0.value }.reduce(0, +) / Double(recentMetrics.filter { $0.type == .engagement }.count)
        
        // 如果效果不佳，生成优化建议
        if averageComprehension < 0.7 || averageEngagement < 0.6 {
            let suggestion = mockDataProvider.generatePathAdjustment(for: UserFeedback(
                type: .comprehension,
                content: "学习效果需要改进",
                rating: averageComprehension * 5,
                context: "路径分析"
            ))
            optimizationSuggestions.append(suggestion)
        }
    }
    
    /// 生成优化建议
    func generateOptimizationSuggestions() async {
        guard let student = studentProfile else { return }
        
        // 根据学生特点和学习效果生成优化建议
        let suggestions = generateOptimizationSuggestions(for: student)
        optimizationSuggestions.append(contentsOf: suggestions)
    }
    
    /// 应用优化
    func applyOptimization(_ suggestion: PathAdjustment) async {
        isOptimizing = true
        
        do {
            // 创建新的学习步骤
            let newStep = createLearningStep(for: suggestion)
            
            // 应用调整
            if let insertionPoint = suggestion.insertionPoint {
                let insertIndex = min(insertionPoint, learningPath.count)
                learningPath.insert(newStep, at: insertIndex)
                
                if currentStepIndex >= insertIndex {
                    currentStepIndex += 1
                }
            }
            
            // 移除已应用的优化建议
            optimizationSuggestions.removeAll { $0.id == suggestion.id }
            
            updateModuleProgress()
            isOptimizing = false
        } catch {
            errorMessage = "应用优化失败: \(error.localizedDescription)"
            isOptimizing = false
        }
    }
    
    /// 跟踪路径演进
    func trackPathEvolution() async {
        // 路径演进已经在setupBindings中通过snapshotCurrentPath实现
    }
    
    /// 预测最优路径
    func predictOptimalPath() async {
        guard let student = studentProfile else { return }
        
        isLoading = true
        
        do {
            // 模拟AI预测过程
            try await Task.sleep(nanoseconds: 3_000_000_000) // 3秒
            
            let optimalPath = mockDataProvider.generateDynamicPath(for: student)
            
            // 添加个性化优化
            var enhancedPath = optimalPath
            let allSteps = mockDataProvider.getMockLearningSteps()
            
            // 根据学习风格添加特定步骤
            if student.learningStyle == .visual {
                enhancedPath.insert(allSteps[8], at: 2) // 可视化图表
            }
            if student.learningStyle == .auditory {
                enhancedPath.insert(allSteps[9], at: 2) // 音频讲解
            }
            
            learningPath = enhancedPath
            currentStepIndex = 0
            updateModuleProgress()
            
            isLoading = false
        } catch {
            errorMessage = "预测最优路径失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 回退到更好的路径
    func revertToBetterPath() async {
        guard pathEvolution.count > 1 else { return }
        
        // 找到效果最好的路径快照
        let bestSnapshot = pathEvolution.max { snapshot1, snapshot2 in
            snapshot1.metrics.effectiveness < snapshot2.metrics.effectiveness
        }
        
        if let bestSnapshot = bestSnapshot {
            learningPath = bestSnapshot.steps
            currentStepIndex = 0
            updateModuleProgress()
        }
    }
    
    // MARK: - Private Methods
    
    private func snapshotCurrentPath() {
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
            adjustments: [],
            version: pathEvolution.count + 1
        )
        
        pathEvolution.append(snapshot)
    }
    
    private func determineSecondaryStyle(for student: DouBaoStudentProfile) -> LearningStyle {
        // 根据学生偏好确定次要学习风格
        if student.preferences["学习方式"]?.contains("图表") == true {
            return .visual
        } else if student.preferences["学习方式"]?.contains("讲解") == true {
            return .auditory
        } else if student.preferences["学习方式"]?.contains("动手") == true {
            return .kinesthetic
        } else {
            return .reading
        }
    }
    
    private func generateStyleRecommendations(for student: DouBaoStudentProfile) -> [String] {
        var recommendations: [String] = []
        
        switch student.learningStyle {
        case .visual:
            recommendations.append("建议使用更多图表和可视化内容")
            recommendations.append("可以尝试思维导图等视觉工具")
        case .auditory:
            recommendations.append("建议增加音频讲解和语音交互")
            recommendations.append("可以尝试朗读和复述学习内容")
        case .kinesthetic:
            recommendations.append("建议增加动手操作和实验环节")
            recommendations.append("可以尝试角色扮演和模拟练习")
        case .reading:
            recommendations.append("建议提供详细的文字说明")
            recommendations.append("可以尝试做笔记和总结")
        case .mixed:
            recommendations.append("建议结合多种学习方式")
            recommendations.append("可以根据内容类型灵活调整")
        case .adaptive:
            recommendations.append("建议根据学习效果动态调整")
            recommendations.append("可以尝试个性化学习路径")
        }
        
        return recommendations
    }
    
    private func addVisualElements(to path: [LearningStep]) -> [LearningStep] {
        let allSteps = mockDataProvider.getMockLearningSteps()
        var enhancedPath = path
        
        // 在适当位置添加可视化元素
        if path.count > 2 {
            enhancedPath.insert(allSteps[8], at: 2) // 可视化图表
        }
        
        return enhancedPath
    }
    
    private func addAudioElements(to path: [LearningStep]) -> [LearningStep] {
        let allSteps = mockDataProvider.getMockLearningSteps()
        var enhancedPath = path
        
        // 在适当位置添加音频元素
        if path.count > 2 {
            enhancedPath.insert(allSteps[9], at: 2) // 音频讲解
        }
        
        return enhancedPath
    }
    
    private func addInteractiveElements(to path: [LearningStep]) -> [LearningStep] {
        let allSteps = mockDataProvider.getMockLearningSteps()
        var enhancedPath = path
        
        // 在适当位置添加交互元素
        if path.count > 2 {
            enhancedPath.insert(allSteps[11], at: 2) // 实际应用
        }
        
        return enhancedPath
    }
    
    private func generateRecommendations(for student: DouBaoStudentProfile) -> [ContentRecommendation] {
        return [
            ContentRecommendation(
                title: "个性化学习路径",
                description: "根据您的学习风格定制的学习计划",
                type: .learningPath,
                difficulty: 3,
                estimatedTime: 1800,
                tags: ["个性化", "自适应"]
            ),
            ContentRecommendation(
                title: "视觉化学习材料",
                description: "丰富的图表和动画内容",
                type: .visualContent,
                difficulty: 2,
                estimatedTime: 900,
                tags: ["视觉", "图表"]
            ),
            ContentRecommendation(
                title: "互动练习",
                description: "动手操作和实验练习",
                type: .interactiveExercise,
                difficulty: 4,
                estimatedTime: 1200,
                tags: ["互动", "实践"]
            )
        ]
    }
    
    private func generateOptimizationSuggestions(for student: DouBaoStudentProfile) -> [PathAdjustment] {
        return [
            PathAdjustment(
                strategy: .addVisualAid,
                reason: "视觉型学习者需要更多图表辅助",
                confidence: 0.9,
                expectedImpact: "提高学习效果和参与度",
                insertionPoint: 2
            ),
            PathAdjustment(
                strategy: .addPracticeDrill,
                reason: "需要更多练习巩固知识点",
                confidence: 0.8,
                expectedImpact: "增强知识掌握程度",
                insertionPoint: 4
            )
        ]
    }
    
    private func createLearningStep(for adjustment: PathAdjustment) -> LearningStep {
        let allSteps = mockDataProvider.getMockLearningSteps()
        
        switch adjustment.strategy {
        case .addVisualAid:
            return allSteps[8] // 可视化图表
        case .addAudioExplanation:
            return allSteps[9] // 音频讲解
        case .addInteractiveDemo:
            return allSteps[3] // 交互演示
        case .addPracticeDrill:
            return allSteps[4] // 基础练习
        case .addGamification:
            return allSteps[10] // 游戏化
        case .addRealWorldExample:
            return allSteps[11] // 实际应用
        default:
            return allSteps[2] // 默认概念讲解
        }
    }
    
    private func calculateEngagement() -> Double {
        let engagementMetrics = feedbackMetrics.filter { $0.type == .engagement }
        guard !engagementMetrics.isEmpty else { return 0.7 }
        
        let averageValue = engagementMetrics.map { $0.value }.reduce(0, +) / Double(engagementMetrics.count)
        return averageValue
    }
    
    private func calculateEffectiveness() -> Double {
        let comprehensionMetrics = feedbackMetrics.filter { $0.type == .comprehension }
        guard !comprehensionMetrics.isEmpty else { return 0.7 }
        
        let averageValue = comprehensionMetrics.map { $0.value }.reduce(0, +) / Double(comprehensionMetrics.count)
        return averageValue
    }
}

// MARK: - 辅助模型

struct LearningStyleAnalysis {
    let primaryStyle: LearningStyle
    let secondaryStyle: LearningStyle
    let confidence: Double
    let recommendations: [String]
}

struct LearningModule {
    let id: String
    let name: String
    let description: String
    let steps: [LearningStep]
    let difficulty: Int
    let estimatedDuration: TimeInterval
}

struct ModuleProgress {
    let currentStepIndex: Int
    let completedSteps: Int
    let totalSteps: Int
    let currentStepProgress: Double
    let overallProgress: Double
    let timeSpent: TimeInterval
    let estimatedTimeRemaining: TimeInterval
    let moduleName: String
}

struct ContentRecommendation {
    let title: String
    let description: String
    let type: RecommendationType
    let difficulty: Int
    let estimatedTime: TimeInterval
    let tags: [String]
}

enum RecommendationType {
    case learningPath
    case visualContent
    case audioContent
    case interactiveExercise
    case practiceTest
    case reviewSession
}

struct AssessmentResult {
    let moduleName: String
    let score: Double
    let accuracy: Double
    let timeSpent: TimeInterval
    let difficulty: Int
    let feedback: String
}

struct FeedbackMetric {
    let type: FeedbackType
    let value: Double
    let timestamp: Date
} 