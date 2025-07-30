import Foundation
import Combine

@MainActor
final class DouBaoTutoringViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentSession: TutoringSession?
    @Published var conversationHistory: [TutoringMessage] = []
    @Published var interactionHistory: [InteractionRecord] = []
    @Published var currentMode: TutoringMode = .questionAnswer
    @Published var sessionProgress: SessionProgress?
    @Published var aiResponse: AIResponse?
    @Published var learningInsights: [LearningInsight] = []
    @Published var interactionOptimizations: [InteractionOptimization] = []
    @Published var realTimeFeedback: RealTimeFeedback?
    @Published var isProcessing: Bool = false
    @Published var isOptimizing: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentStudent: DouBaoStudentProfile?
    
    // MARK: - Private Properties
    private let mockDataProvider: DouBaoMockDataProvider
    private var cancellables = Set<AnyCancellable>()
    private var optimizationTimer: Timer?
    
    // MARK: - Initialization
    init(mockDataProvider: DouBaoMockDataProvider = DouBaoMockDataProviderImpl()) {
        self.mockDataProvider = mockDataProvider
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // 监听对话历史变化，自动分析学习洞察
        $conversationHistory
            .sink { [weak self] history in
                if history.count % 3 == 0 && !history.isEmpty {
                    Task { @MainActor in
                        await self?.generateLearningInsights()
                    }
                }
            }
            .store(in: &cancellables)
        
        // 监听交互历史，自动触发优化
        $interactionHistory
            .sink { [weak self] history in
                if !history.isEmpty {
                    Task { @MainActor in
                        await self?.analyzeRealTimeFeedback()
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
            isLoading = false
        } catch {
            errorMessage = "加载学生数据失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 开始辅导会话
    func startTutoringSession(mode: TutoringMode) async {
        guard let student = currentStudent else { return }
        
        isLoading = true
        
        do {
            // 创建新的辅导会话
            let session = TutoringSession(
                id: UUID().uuidString,
                studentId: student.id,
                mode: mode,
                startTime: Date(),
                status: .active
            )
            
            currentSession = session
            currentMode = mode
            
            // 生成欢迎消息
            let welcomeMessage = generateWelcomeMessage(for: student, mode: mode)
            let aiMessage = TutoringMessage(
                id: UUID().uuidString,
                content: welcomeMessage,
                sender: .ai,
                timestamp: Date(),
                messageType: .welcome
            )
            
            conversationHistory.append(aiMessage)
            updateSessionProgress()
            isLoading = false
        } catch {
            errorMessage = "开始辅导会话失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 发送消息
    func sendMessage(_ message: String) async {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isProcessing = true
        
        do {
            // 添加用户消息到历史
            let userMessage = TutoringMessage(
                id: UUID().uuidString,
                content: message,
                sender: .student,
                timestamp: Date(),
                messageType: .question
            )
            
            conversationHistory.append(userMessage)
            
            // 记录交互
            let interaction = InteractionRecord(
                type: .messageSent,
                content: message,
                timestamp: Date(),
                context: "学生提问"
            )
            interactionHistory.append(interaction)
            
            // 模拟AI处理时间
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5秒
            
            // 生成AI响应
            let aiResponse = await generateAIResponse(for: message)
            
            // 添加AI消息到历史
            let aiMessage = TutoringMessage(
                id: UUID().uuidString,
                content: aiResponse.content,
                sender: .ai,
                timestamp: Date(),
                messageType: aiResponse.messageType
            )
            
            conversationHistory.append(aiMessage)
            updateSessionProgress()
            isProcessing = false
        } catch {
            errorMessage = "发送消息失败: \(error.localizedDescription)"
            isProcessing = false
        }
    }
    
    /// 切换辅导模式
    func switchTutoringMode(_ mode: TutoringMode) async {
        currentMode = mode
        
        // 生成模式切换提示
        let modeMessage = generateModeSwitchMessage(mode: mode)
        let aiMessage = TutoringMessage(
            id: UUID().uuidString,
            content: modeMessage,
            sender: .ai,
            timestamp: Date(),
            messageType: .system
        )
        
        conversationHistory.append(aiMessage)
    }
    
    /// 生成练习题目
    func generatePracticeQuestions() async {
        guard let student = currentStudent else { return }
        
        isProcessing = true
        
        do {
            // 模拟生成题目过程
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2秒
            
            // 根据学生特点生成题目
            let questions = generateQuestions(for: student)
            let questionText = questions.map { "\($0.number). \($0.content)" }.joined(separator: "\n")
            
            let aiMessage = TutoringMessage(
                id: UUID().uuidString,
                content: "好的，我为你准备了以下练习题目：\n\n\(questionText)\n\n请尝试解答，我会根据你的答案给出详细指导。",
                sender: .ai,
                timestamp: Date(),
                messageType: .practice
            )
            
            conversationHistory.append(aiMessage)
            isProcessing = false
        } catch {
            errorMessage = "生成练习题目失败: \(error.localizedDescription)"
            isProcessing = false
        }
    }
    
    /// 分析学生回答
    func analyzeStudentResponse(_ response: String) async {
        isProcessing = true
        
        do {
            // 模拟分析过程
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5秒
            
            // 分析回答质量
            let analysis = analyzeResponseQuality(response)
            
            // 生成反馈
            let feedback = generateResponseFeedback(analysis: analysis)
            
            let aiMessage = TutoringMessage(
                id: UUID().uuidString,
                content: feedback,
                sender: .ai,
                timestamp: Date(),
                messageType: .feedback
            )
            
            conversationHistory.append(aiMessage)
            
            // 记录交互
            let interaction = InteractionRecord(
                type: .responseAnalyzed,
                content: response,
                timestamp: Date(),
                context: "回答分析"
            )
            interactionHistory.append(interaction)
            
            isProcessing = false
        } catch {
            errorMessage = "分析学生回答失败: \(error.localizedDescription)"
            isProcessing = false
        }
    }
    
    /// 生成学习洞察
    func generateLearningInsights() async {
        guard !conversationHistory.isEmpty else { return }
        
        // 分析对话历史，生成学习洞察
        let insights = analyzeConversationHistory()
        learningInsights.append(contentsOf: insights)
    }
    
    /// 结束辅导会话
    func endTutoringSession() async {
        guard var session = currentSession else { return }
        
        session.status = .completed
        session.endTime = Date()
        currentSession = session
        
        // 生成结束消息
        let endMessage = generateEndMessage()
        let aiMessage = TutoringMessage(
            id: UUID().uuidString,
            content: endMessage,
            sender: .ai,
            timestamp: Date(),
            messageType: .system
        )
        
        conversationHistory.append(aiMessage)
        
        // 生成会话总结
        await generateSessionSummary()
    }
    
    // MARK: - 动态交互优化方法
    
    /// 分析实时反馈
    func analyzeRealTimeFeedback() async {
        guard !interactionHistory.isEmpty else { return }
        
        // 分析最近的交互记录
        let recentInteractions = Array(interactionHistory.suffix(5))
        
        // 检测学习状态
        let learningState = detectLearningState(from: recentInteractions)
        
        // 生成实时反馈
        realTimeFeedback = RealTimeFeedback(
            learningState: learningState,
            engagement: calculateEngagement(),
            comprehension: calculateComprehension(),
            suggestions: generateRealTimeSuggestions(for: learningState)
        )
        
        // 如果检测到问题，生成优化建议
        if learningState == .confused || learningState == .frustrated {
            await generateInteractionOptimization()
        }
    }
    
    /// 生成交互优化
    func generateInteractionOptimization() async {
        guard let feedback = realTimeFeedback else { return }
        
        isOptimizing = true
        
        do {
            // 根据学习状态生成优化策略
            let optimization = generateOptimizationStrategy(for: feedback.learningState)
            interactionOptimizations.append(optimization)
            
            // 自动应用优化
            await applyInteractionAdjustment(optimization.adjustment)
            
            isOptimizing = false
        } catch {
            errorMessage = "生成交互优化失败: \(error.localizedDescription)"
            isOptimizing = false
        }
    }
    
    /// 应用交互调整
    func applyInteractionAdjustment(_ adjustment: InteractionAdjustment) async {
        // 根据调整类型修改AI响应风格
        switch adjustment {
        case .changeTone(let tone):
            // 改变AI语调
            break
        case .adjustPace(let factor):
            // 调整响应速度
            break
        case .addVisualAid(let content):
            // 添加可视化内容
            break
        case .simplifyLanguage:
            // 简化语言
            break
        case .addExamples(let count):
            // 添加示例
            break
        case .addEncouragement:
            // 添加鼓励
            break
        default:
            break
        }
        
        // 记录调整
        let interaction = InteractionRecord(
            type: .adjustmentApplied,
            content: adjustment.description,
            timestamp: Date(),
            context: "交互优化"
        )
        interactionHistory.append(interaction)
    }
    
    /// 跟踪交互有效性
    func trackInteractionEffectiveness() async {
        // 分析交互历史，评估有效性
        let effectiveness = calculateInteractionEffectiveness()
        
        // 更新会话进度
        updateSessionProgress()
    }
    
    /// 预测最优交互
    func predictOptimalInteraction() async {
        guard let student = currentStudent else { return }
        
        isLoading = true
        
        do {
            // 模拟AI预测过程
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2秒
            
            // 根据学生特点预测最优交互方式
            let optimalInteraction = predictOptimalInteraction(for: student)
            
            // 应用预测的交互方式
            await applyInteractionAdjustment(optimalInteraction)
            
            isLoading = false
        } catch {
            errorMessage = "预测最优交互失败: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 适应学生情绪
    func adaptToStudentMood() async {
        guard let feedback = realTimeFeedback else { return }
        
        // 根据学习状态调整AI响应
        let moodAdjustment = generateMoodAdjustment(for: feedback.learningState)
        await applyInteractionAdjustment(moodAdjustment)
    }
    
    /// 优化响应风格
    func optimizeResponseStyle() async {
        guard let student = currentStudent else { return }
        
        // 根据学生特点优化响应风格
        let styleAdjustment = generateStyleAdjustment(for: student)
        await applyInteractionAdjustment(styleAdjustment)
    }
    
    // MARK: - Private Methods
    
    private func updateSessionProgress() {
        let totalMessages = conversationHistory.count
        let studentMessages = conversationHistory.filter { $0.sender == .student }.count
        let aiMessages = conversationHistory.filter { $0.sender == .ai }.count
        let sessionDuration = currentSession?.startTime.timeIntervalSinceNow ?? 0
        
        sessionProgress = SessionProgress(
            totalMessages: totalMessages,
            studentMessages: studentMessages,
            aiMessages: aiMessages,
            sessionDuration: abs(sessionDuration),
            currentMode: currentMode,
            learningInsights: learningInsights.count,
            optimizations: interactionOptimizations.count
        )
    }
    
    private func generateWelcomeMessage(for student: DouBaoStudentProfile, mode: TutoringMode) -> String {
        let modeDescription = mode.description
        let studentName = student.name
        
        return """
        你好 \(studentName)！👋
        
        我是你的AI学习助手，很高兴为你提供\(modeDescription)服务。
        
        我可以：
        • 回答你的学习问题
        • 提供个性化指导
        • 生成练习题目
        • 分析你的学习进度
        • 根据你的反馈调整教学方式
        
        请告诉我你想学习什么，或者有什么问题需要帮助？
        """
    }
    
    private func generateModeSwitchMessage(mode: TutoringMode) -> String {
        return "已切换到\(mode.description)模式。现在我可以为你提供更专业的\(mode.description)服务。"
    }
    
    private func generateEndMessage() -> String {
        return """
        今天的辅导会话即将结束。
        
        总结一下我们的学习成果：
        • 我们进行了 \(conversationHistory.filter { $0.sender == .student }.count) 次问答
        • 生成了 \(learningInsights.count) 个学习洞察
        • 应用了 \(interactionOptimizations.count) 次交互优化
        
        希望今天的学习对你有帮助！下次再见！👋
        """
    }
    
    private func generateAIResponse(for message: String) async -> AIResponse {
        // 模拟AI响应生成
        let responseContent = generateResponseContent(for: message)
        let messageType = determineMessageType(for: message)
        
        return AIResponse(
            content: responseContent,
            messageType: messageType,
            confidence: Double.random(in: 0.8...0.95),
            processingTime: 1.5
        )
    }
    
    private func generateResponseContent(for message: String) -> String {
        // 根据消息内容生成响应
        if message.contains("题目") || message.contains("问题") {
            return "这是一个很好的问题！让我来详细解释一下..."
        } else if message.contains("练习") || message.contains("作业") {
            return "好的，我来为你准备一些练习题目..."
        } else if message.contains("不懂") || message.contains("不明白") {
            return "我理解你的困惑，让我用更简单的方式来解释..."
        } else {
            return "谢谢你的提问！让我来回答这个问题..."
        }
    }
    
    private func determineMessageType(for message: String) -> MessageType {
        if message.contains("练习") || message.contains("作业") {
            return .practice
        } else if message.contains("不懂") || message.contains("不明白") {
            return .explanation
        } else {
            return .answer
        }
    }
    
    private func generateQuestions(for student: DouBaoStudentProfile) -> [PracticeQuestion] {
        return [
            PracticeQuestion(number: 1, content: "请解释一下分数的基本概念", difficulty: 2),
            PracticeQuestion(number: 2, content: "计算：3/4 + 1/2 = ?", difficulty: 3),
            PracticeQuestion(number: 3, content: "应用题：小明有12个苹果，分给4个朋友，每人分几个？", difficulty: 4)
        ]
    }
    
    private func analyzeResponseQuality(_ response: String) -> ResponseAnalysis {
        // 简单的回答质量分析
        let wordCount = response.components(separatedBy: .whitespaces).count
        let hasKeywords = response.contains("因为") || response.contains("所以") || response.contains("因此")
        let hasNumbers = response.rangeOfCharacter(from: .decimalDigits) != nil
        
        let quality = min(5.0, Double(wordCount) / 10.0 + (hasKeywords ? 1.0 : 0.0) + (hasNumbers ? 1.0 : 0.0))
        
        return ResponseAnalysis(
            quality: quality,
            completeness: Double(wordCount) / 20.0,
            accuracy: Double.random(in: 0.6...0.9),
            suggestions: generateQualitySuggestions(quality: quality)
        )
    }
    
    private func generateResponseFeedback(analysis: ResponseAnalysis) -> String {
        if analysis.quality >= 4.0 {
            return "回答得很好！你的思路清晰，表达准确。继续保持！"
        } else if analysis.quality >= 3.0 {
            return "回答不错，但还可以更详细一些。建议多解释一下推理过程。"
        } else {
            return "回答需要改进。建议：\n1. 更仔细地审题\n2. 写出完整的解题步骤\n3. 检查计算过程"
        }
    }
    
    private func analyzeConversationHistory() -> [LearningInsight] {
        let insights = [
            LearningInsight(
                type: .comprehension,
                title: "理解能力分析",
                description: "你在概念理解方面表现良好，但在应用题方面需要加强",
                confidence: 0.85,
                recommendations: ["多做应用题练习", "注意审题技巧"]
            ),
            LearningInsight(
                type: .engagement,
                title: "学习参与度",
                description: "你的学习积极性很高，能够主动提问和思考",
                confidence: 0.9,
                recommendations: ["继续保持这种学习态度", "可以尝试更深入的问题"]
            )
        ]
        
        return insights
    }
    
    private func generateSessionSummary() async {
        // 生成会话总结
        let summary = SessionSummary(
            duration: sessionProgress?.sessionDuration ?? 0,
            totalMessages: sessionProgress?.totalMessages ?? 0,
            learningInsights: learningInsights.count,
            keyTopics: extractKeyTopics(),
            recommendations: generateSessionRecommendations()
        )
        
        // 这里可以将总结保存到数据库或发送给用户
    }
    
    private func detectLearningState(from interactions: [InteractionRecord]) -> LearningState {
        // 根据交互记录检测学习状态
        let recentMessages = interactions.filter { $0.type == .messageSent }
        
        if recentMessages.contains(where: { $0.content.contains("不懂") || $0.content.contains("不明白") }) {
            return .confused
        } else if recentMessages.contains(where: { $0.content.contains("太难") || $0.content.contains("不会") }) {
            return .frustrated
        } else if recentMessages.contains(where: { $0.content.contains("明白了") || $0.content.contains("懂了") }) {
            return .confident
        } else {
            return .neutral
        }
    }
    
    private func calculateEngagement() -> Double {
        // 计算学习参与度
        let recentMessages = conversationHistory.suffix(10)
        let studentMessages = recentMessages.filter { $0.sender == .student }.count
        return Double(studentMessages) / Double(recentMessages.count)
    }
    
    private func calculateComprehension() -> Double {
        // 计算理解程度
        let feedbackMessages = conversationHistory.filter { $0.messageType == .feedback }
        let positiveFeedback = feedbackMessages.filter { $0.content.contains("很好") || $0.content.contains("不错") }.count
        return feedbackMessages.isEmpty ? 0.7 : Double(positiveFeedback) / Double(feedbackMessages.count)
    }
    
    private func generateRealTimeSuggestions(for state: LearningState) -> [String] {
        switch state {
        case .confused:
            return ["让我用更简单的方式解释", "我们可以从基础概念开始", "需要我提供更多示例吗？"]
        case .frustrated:
            return ["不要着急，我们可以慢慢来", "让我调整一下难度", "休息一下再继续？"]
        case .confident:
            return ["很好！我们可以尝试更有挑战性的问题", "你的理解很到位", "继续保持这种学习状态"]
        case .neutral:
            return ["有什么问题随时问我", "我们可以深入探讨这个话题", "需要更多练习吗？"]
        }
    }
    
    private func generateOptimizationStrategy(for state: LearningState) -> InteractionOptimization {
        let adjustment: InteractionAdjustment
        
        switch state {
        case .confused:
            adjustment = .simplifyLanguage
        case .frustrated:
            adjustment = .addEncouragement
        case .confident:
            adjustment = .addExamples(2)
        case .neutral:
            adjustment = .changeTone(to: .friendly)
        }
        
        return InteractionOptimization(
            trigger: .comprehensionGap(level: 0.3),
            adjustment: adjustment,
            expectedOutcome: "改善学习体验",
            confidence: 0.8
        )
    }
    
    private func calculateInteractionEffectiveness() -> Double {
        // 计算交互有效性
        let recentInteractions = interactionHistory.suffix(10)
        let positiveInteractions = recentInteractions.filter { $0.type == .adjustmentApplied }.count
        return Double(positiveInteractions) / Double(recentInteractions.count)
    }
    
    private func predictOptimalInteraction(for student: DouBaoStudentProfile) -> InteractionAdjustment {
        // 根据学生特点预测最优交互方式
        switch student.learningStyle {
        case .visual:
            return .addVisualAid("图表说明")
        case .auditory:
            return .addAudioExplanation
        case .kinesthetic:
            return .addExamples(3)
        default:
            return .changeTone(to: .encouraging)
        }
    }
    
    private func generateMoodAdjustment(for state: LearningState) -> InteractionAdjustment {
        switch state {
        case .confused:
            return .simplifyLanguage
        case .frustrated:
            return .addEncouragement
        case .confident:
            return .changeTone(to: .enthusiastic)
        case .neutral:
            return .changeTone(to: .friendly)
        }
    }
    
    private func generateStyleAdjustment(for student: DouBaoStudentProfile) -> InteractionAdjustment {
        switch student.learningStyle {
        case .visual:
            return .addVisualAid("可视化内容")
        case .auditory:
            return .addAudioExplanation
        case .kinesthetic:
            return .addExamples(2)
        default:
            return .changeTone(to: .encouraging)
        }
    }
    
    private func generateQualitySuggestions(quality: Double) -> [String] {
        if quality < 3.0 {
            return ["更仔细地审题", "写出完整的解题步骤", "检查计算过程"]
        } else if quality < 4.0 {
            return ["可以更详细一些", "多解释推理过程", "注意表达清晰"]
        } else {
            return ["继续保持", "可以尝试更深入的问题", "很好的学习态度"]
        }
    }
    
    private func extractKeyTopics() -> [String] {
        // 从对话历史中提取关键话题
        return ["分数运算", "应用题", "数学概念"]
    }
    
    private func generateSessionRecommendations() -> [String] {
        return [
            "建议多做分数相关的练习",
            "可以尝试更复杂的应用题",
            "注意审题和计算准确性"
        ]
    }
}

// MARK: - 辅助模型

struct TutoringSession {
    let id: String
    let studentId: String
    let mode: TutoringMode
    let startTime: Date
    var endTime: Date?
    var status: SessionStatus
}

enum TutoringMode: String, CaseIterable, Codable {
    case questionAnswer = "问答模式"
    case guidedLearning = "引导模式"
    case practiceDrill = "练习模式"
    case reviewSession = "复习模式"
    case examPreparation = "备考模式"
    case adaptiveTutoring = "自适应辅导"
    case collaborative = "协作模式"
    
    var description: String {
        return self.rawValue
    }
}

enum SessionStatus {
    case active
    case paused
    case completed
}

struct TutoringMessage {
    let id: String
    let content: String
    let sender: MessageSender
    let timestamp: Date
    let messageType: MessageType
}

enum MessageSender {
    case student
    case ai
}

enum MessageType {
    case question
    case answer
    case explanation
    case practice
    case feedback
    case welcome
    case system
}

struct AIResponse {
    let content: String
    let messageType: MessageType
    let confidence: Double
    let processingTime: TimeInterval
}

struct InteractionRecord {
    let type: InteractionType
    let content: String
    let timestamp: Date
    let context: String
}

enum InteractionType {
    case messageSent
    case responseAnalyzed
    case adjustmentApplied
    case modeSwitched
}

struct SessionProgress {
    let totalMessages: Int
    let studentMessages: Int
    let aiMessages: Int
    let sessionDuration: TimeInterval
    let currentMode: TutoringMode
    let learningInsights: Int
    let optimizations: Int
}

struct LearningInsight {
    let type: InsightType
    let title: String
    let description: String
    let confidence: Double
    let recommendations: [String]
}

enum InsightType {
    case comprehension
    case engagement
    case progress
    case difficulty
}

struct InteractionOptimization {
    let trigger: InteractionTrigger
    let adjustment: InteractionAdjustment
    let expectedOutcome: String
    let confidence: Double
}

enum InteractionTrigger {
    case comprehensionGap(level: Double)
    case engagementDrop(level: Double)
    case frustrationDetected
    case confusionIndicated
    case interestIncrease
    case masteryAchieved
    case timePressure
    case learningStyleMismatch
}

enum InteractionAdjustment {
    case changeTone(to: CommunicationTone)
    case adjustPace(by: Double)
    case addVisualAid(String)
    case addAudioExplanation
    case simplifyLanguage
    case addExamples(Int)
    case changeApproach(to: TeachingApproach)
    case addEncouragement
    case provideHints(Int)
    case createBreak
    
    var description: String {
        switch self {
        case .changeTone(let tone):
            return "改变语调为\(tone.rawValue)"
        case .adjustPace(let factor):
            return "调整节奏\(factor > 1 ? "加快" : "放慢")"
        case .addVisualAid(let content):
            return "添加可视化内容：\(content)"
        case .addAudioExplanation:
            return "添加音频讲解"
        case .simplifyLanguage:
            return "简化语言表达"
        case .addExamples(let count):
            return "添加\(count)个示例"
        case .changeApproach(let approach):
            return "改变教学方式为\(approach.rawValue)"
        case .addEncouragement:
            return "添加鼓励"
        case .provideHints(let count):
            return "提供\(count)个提示"
        case .createBreak:
            return "创建休息时间"
        }
    }
}

enum CommunicationTone: String {
    case friendly = "友好"
    case encouraging = "鼓励"
    case enthusiastic = "热情"
    case patient = "耐心"
    case professional = "专业"
}

enum TeachingApproach: String {
    case stepByStep = "逐步引导"
    case exampleBased = "示例教学"
    case problemSolving = "问题解决"
    case interactive = "互动教学"
    case visual = "可视化教学"
}

struct RealTimeFeedback {
    let learningState: LearningState
    let engagement: Double
    let comprehension: Double
    let suggestions: [String]
}

enum LearningState {
    case confused
    case frustrated
    case confident
    case neutral
}

struct PracticeQuestion {
    let number: Int
    let content: String
    let difficulty: Int
}

struct ResponseAnalysis {
    let quality: Double
    let completeness: Double
    let accuracy: Double
    let suggestions: [String]
}

struct SessionSummary {
    let duration: TimeInterval
    let totalMessages: Int
    let learningInsights: Int
    let keyTopics: [String]
    let recommendations: [String]
} 