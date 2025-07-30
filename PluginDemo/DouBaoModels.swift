import Foundation

// MARK: - 学生类型和学习风格
enum StudentType: String, CaseIterable, Codable {
    case beginner = "初学者"
    case intermediate = "中等生"
    case advanced = "优秀生"
    case struggling = "困难生"
    case adaptive = "自适应型"
    
    var description: String {
        switch self {
        case .beginner: return "需要基础概念讲解"
        case .intermediate: return "需要解题技巧指导"
        case .advanced: return "需要拓展思维训练"
        case .struggling: return "需要错题专项训练"
        case .adaptive: return "根据表现动态调整"
        }
    }
}

enum LearningStyle: String, CaseIterable, Codable {
    case visual = "视觉型"
    case auditory = "听觉型"
    case kinesthetic = "动觉型"
    case reading = "阅读型"
    case mixed = "混合型"
    case adaptive = "自适应型"
    
    var description: String {
        switch self {
        case .visual: return "喜欢图表、视频"
        case .auditory: return "喜欢音频、讲解"
        case .kinesthetic: return "喜欢动手、实验"
        case .reading: return "喜欢文字、阅读"
        case .mixed: return "多种风格结合"
        case .adaptive: return "根据内容动态调整"
        }
    }
}

enum Subject: String, CaseIterable, Codable {
    case math = "数学"
    case chinese = "语文"
    case english = "英语"
    case physics = "物理"
    case chemistry = "化学"
    case biology = "生物"
}

// MARK: - 学生画像模型
struct DouBaoStudentProfile: Identifiable, Codable {
    let id: String
    let name: String
    let age: Int
    let grade: String
    let studentType: StudentType
    let learningStyle: LearningStyle
    let subjects: [Subject]
    let strengths: [String]
    let weaknesses: [String]
    let learningGoals: [String]
    let preferences: [String: String]
    let adaptability: Double // 适应能力 (0-1)
    let feedbackSensitivity: Double // 反馈敏感度 (0-1)
    let learningPace: Double // 学习节奏 (0-1)
    
    init(
        id: String = UUID().uuidString,
        name: String,
        age: Int,
        grade: String,
        studentType: StudentType,
        learningStyle: LearningStyle,
        subjects: [Subject],
        strengths: [String],
        weaknesses: [String],
        learningGoals: [String],
        preferences: [String: String],
        adaptability: Double = 0.7,
        feedbackSensitivity: Double = 0.8,
        learningPace: Double = 0.6
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.grade = grade
        self.studentType = studentType
        self.learningStyle = learningStyle
        self.subjects = subjects
        self.strengths = strengths
        self.weaknesses = weaknesses
        self.learningGoals = learningGoals
        self.preferences = preferences
        self.adaptability = max(0, min(1, adaptability))
        self.feedbackSensitivity = max(0, min(1, feedbackSensitivity))
        self.learningPace = max(0, min(1, learningPace))
    }
}

// MARK: - 学习步骤模型
struct LearningStep: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let type: StepType
    let duration: TimeInterval
    let difficulty: Int // 1-5
    let requiredCapabilities: [String]
    let expectedOutcome: String
    let isOptional: Bool
    let dependencies: [String] // 依赖的其他步骤ID
    let completionRate: Double // 完成率 (0-1)
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        type: StepType,
        duration: TimeInterval,
        difficulty: Int,
        requiredCapabilities: [String] = [],
        expectedOutcome: String,
        isOptional: Bool = false,
        dependencies: [String] = [],
        completionRate: Double = 0.0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.duration = duration
        self.difficulty = max(1, min(5, difficulty))
        self.requiredCapabilities = requiredCapabilities
        self.expectedOutcome = expectedOutcome
        self.isOptional = isOptional
        self.dependencies = dependencies
        self.completionRate = max(0, min(1, completionRate))
    }
}

enum StepType: String, CaseIterable, Codable {
    case conceptExplanation = "概念讲解"
    case problemAnalysis = "题目分析"
    case practiceExercise = "练习训练"
    case visualAid = "可视化辅助"
    case audioExplanation = "音频讲解"
    case interactiveDemo = "交互演示"
    case peerLearning = "同伴学习"
    case gamification = "游戏化"
    case realWorldExample = "实际应用"
    case reviewSession = "复习环节"
    case extensionActivity = "拓展活动"
    case assessment = "评估测试"
    
    var icon: String {
        switch self {
        case .conceptExplanation: return "book.fill"
        case .problemAnalysis: return "magnifyingglass"
        case .practiceExercise: return "pencil.and.outline"
        case .visualAid: return "chart.bar.fill"
        case .audioExplanation: return "speaker.wave.2.fill"
        case .interactiveDemo: return "hand.tap.fill"
        case .peerLearning: return "person.2.fill"
        case .gamification: return "gamecontroller.fill"
        case .realWorldExample: return "globe"
        case .reviewSession: return "arrow.clockwise"
        case .extensionActivity: return "star.fill"
        case .assessment: return "checkmark.circle.fill"
        }
    }
}

// MARK: - 路径调整策略
enum PathAdjustmentStrategy: String, CaseIterable, Codable {
    case addConceptExplanation = "增加概念讲解"
    case addPracticeDrill = "增加练习环节"
    case addVisualAid = "增加可视化辅助"
    case addAudioExplanation = "增加音频讲解"
    case addInteractiveDemo = "增加交互演示"
    case addPeerLearning = "增加同伴学习"
    case addGamification = "增加游戏化元素"
    case addRealWorldExample = "增加实际应用"
    case addReviewSession = "增加复习环节"
    case addExtensionActivity = "增加拓展活动"
    case removeRedundantStep = "移除冗余步骤"
    case simplifyComplexStep = "简化复杂步骤"
    case accelerateProgress = "加速进度"
    case slowDownForMastery = "放慢节奏"
    
    var description: String {
        return self.rawValue
    }
}

struct PathAdjustment: Identifiable, Codable {
    let id: String
    let strategy: PathAdjustmentStrategy
    let reason: String
    let confidence: Double // 0-1
    let expectedImpact: String
    let insertionPoint: Int?
    let removalPoint: Int?
    let timestamp: Date
    let applied: Bool
    
    init(
        id: String = UUID().uuidString,
        strategy: PathAdjustmentStrategy,
        reason: String,
        confidence: Double,
        expectedImpact: String,
        insertionPoint: Int? = nil,
        removalPoint: Int? = nil,
        applied: Bool = false
    ) {
        self.id = id
        self.strategy = strategy
        self.reason = reason
        self.confidence = max(0, min(1, confidence))
        self.expectedImpact = expectedImpact
        self.insertionPoint = insertionPoint
        self.removalPoint = removalPoint
        self.timestamp = Date()
        self.applied = applied
    }
}

// MARK: - 用户反馈模型
struct UserFeedback: Identifiable, Codable {
    let id: String
    let type: FeedbackType
    let content: String
    let rating: Double // 1-5
    let timestamp: Date
    let context: String
    let emotionalState: EmotionalState?
    
    init(
        id: String = UUID().uuidString,
        type: FeedbackType,
        content: String,
        rating: Double,
        context: String,
        emotionalState: EmotionalState? = nil
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.rating = max(1, min(5, rating))
        self.timestamp = Date()
        self.context = context
        self.emotionalState = emotionalState
    }
}

enum FeedbackType: String, CaseIterable, Codable {
    case comprehension = "理解程度"
    case engagement = "参与度"
    case difficulty = "难度感受"
    case satisfaction = "满意度"
    case frustration = "挫折感"
    case confusion = "困惑程度"
    case interest = "兴趣程度"
    case confidence = "自信心"
    
    var description: String {
        return self.rawValue
    }
}

enum EmotionalState: String, CaseIterable, Codable {
    case excited = "兴奋"
    case confused = "困惑"
    case frustrated = "挫折"
    case bored = "无聊"
    case confident = "自信"
    case anxious = "焦虑"
    case curious = "好奇"
    case satisfied = "满意"
    
    var emoji: String {
        switch self {
        case .excited: return "😊"
        case .confused: return "😕"
        case .frustrated: return "😤"
        case .bored: return "😴"
        case .confident: return "😎"
        case .anxious: return "😰"
        case .curious: return "🤔"
        case .satisfied: return "😌"
        }
    }
}

// MARK: - 路径快照模型
struct PathSnapshot: Identifiable, Codable {
    let id: String
    let timestamp: Date
    let steps: [LearningStep]
    let metrics: PathMetrics
    let adjustments: [PathAdjustment]
    let version: Int
    
    init(
        id: String = UUID().uuidString,
        steps: [LearningStep],
        metrics: PathMetrics,
        adjustments: [PathAdjustment] = [],
        version: Int = 1
    ) {
        self.id = id
        self.timestamp = Date()
        self.steps = steps
        self.metrics = metrics
        self.adjustments = adjustments
        self.version = version
    }
}

struct PathMetrics: Codable {
    let totalSteps: Int
    let estimatedDuration: TimeInterval
    let difficulty: Double // 1-5
    let engagement: Double // 0-1
    let effectiveness: Double // 0-1
    
    init(
        totalSteps: Int,
        estimatedDuration: TimeInterval,
        difficulty: Double,
        engagement: Double,
        effectiveness: Double
    ) {
        self.totalSteps = totalSteps
        self.estimatedDuration = estimatedDuration
        self.difficulty = max(1, min(5, difficulty))
        self.engagement = max(0, min(1, engagement))
        self.effectiveness = max(0, min(1, effectiveness))
    }
}

// MARK: - 学习记录模型
struct DouBaoLearningRecord: Identifiable, Codable {
    let id: String
    let studentId: String
    let sessionType: SessionType
    let subject: Subject
    let topic: String
    let duration: TimeInterval
    let score: Double?
    let difficulty: Int
    let completionRate: Double
    let timestamp: Date
    let metadata: [String: String]
    let feedback: UserFeedback?
    let pathAdjustments: [PathAdjustment]?
    let effectiveness: Double?
    
    init(
        id: String = UUID().uuidString,
        studentId: String,
        sessionType: SessionType,
        subject: Subject,
        topic: String,
        duration: TimeInterval,
        score: Double? = nil,
        difficulty: Int,
        completionRate: Double,
        metadata: [String: String] = [:],
        feedback: UserFeedback? = nil,
        pathAdjustments: [PathAdjustment]? = nil,
        effectiveness: Double? = nil
    ) {
        self.id = id
        self.studentId = studentId
        self.sessionType = sessionType
        self.subject = subject
        self.topic = topic
        self.duration = duration
        self.score = score
        self.difficulty = max(1, min(5, difficulty))
        self.completionRate = max(0, min(1, completionRate))
        self.timestamp = Date()
        self.metadata = metadata
        self.feedback = feedback
        self.pathAdjustments = pathAdjustments
        self.effectiveness = effectiveness
    }
}

enum SessionType: String, CaseIterable, Codable {
    case mathProblem = "数学解题"
    case learningPath = "学习路径"
    case tutoringSession = "AI辅导"
    case practiceExercise = "练习训练"
    case assessment = "评估测试"
    case pathOptimization = "路径优化"
    
    var description: String {
        return self.rawValue
    }
}

// MARK: - 数学问题模型
struct MathProblem: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let imageData: Data?
    let difficulty: Int
    let subject: Subject
    let topic: String
    let solution: String
    let explanation: String
    let tags: [String]
    
    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        imageData: Data? = nil,
        difficulty: Int,
        subject: Subject,
        topic: String,
        solution: String,
        explanation: String,
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.imageData = imageData
        self.difficulty = max(1, min(5, difficulty))
        self.subject = subject
        self.topic = topic
        self.solution = solution
        self.explanation = explanation
        self.tags = tags
    }
}

// MARK: - 学习进度模型
struct LearningProgress: Codable {
    let currentStepIndex: Int
    let completedSteps: Int
    let totalSteps: Int
    let currentStepProgress: Double // 0-1
    let overallProgress: Double // 0-1
    let timeSpent: TimeInterval
    let estimatedTimeRemaining: TimeInterval
    
    var completionPercentage: Double {
        return overallProgress * 100
    }
    
    var isCompleted: Bool {
        return overallProgress >= 1.0
    }
}

// MARK: - 问题分析结果
struct ProblemAnalysis: Codable {
    let problemType: String
    let difficulty: Int
    let keyConcepts: [String]
    let solutionSteps: [String]
    let commonMistakes: [String]
    let tips: [String]
    let relatedTopics: [String]
    let estimatedTime: TimeInterval
}

// MARK: - 数学练习模型
struct MathExercise: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let difficulty: Int
    let topic: String
    let solution: String
    let explanation: String
    let isCompleted: Bool
    let score: Double?
    
    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        difficulty: Int,
        topic: String,
        solution: String,
        explanation: String,
        isCompleted: Bool = false,
        score: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.difficulty = max(1, min(5, difficulty))
        self.topic = topic
        self.solution = solution
        self.explanation = explanation
        self.isCompleted = isCompleted
        self.score = score
    }
} 