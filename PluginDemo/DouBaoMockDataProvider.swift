import Foundation

// MARK: - Mock数据提供者协议
protocol DouBaoMockDataProvider {
    func getMockStudents() -> [DouBaoStudentProfile]
    func getMockMathProblems() -> [MathProblem]
    func getMockLearningSteps() -> [LearningStep]
    func getMockUserFeedback() -> [UserFeedback]
    func getMockPathAdjustments() -> [PathAdjustment]
    func generateDynamicPath(for student: DouBaoStudentProfile) -> [LearningStep]
    func simulateFeedback(for step: LearningStep) -> UserFeedback
    func generatePathAdjustment(for feedback: UserFeedback) -> PathAdjustment
}

// MARK: - Mock数据提供者实现
class DouBaoMockDataProviderImpl: DouBaoMockDataProvider {
    
    // MARK: - 学生数据
    func getMockStudents() -> [DouBaoStudentProfile] {
        return [
            DouBaoStudentProfile(
                name: "小明",
                age: 12,
                grade: "六年级",
                studentType: .adaptive,
                learningStyle: .mixed,
                subjects: [.math, .chinese, .english],
                strengths: ["逻辑思维", "空间想象", "记忆力好"],
                weaknesses: ["计算粗心", "应用题理解", "注意力不集中"],
                learningGoals: ["提高数学成绩", "培养解题思维", "增强学习兴趣"],
                preferences: [
                    "学习方式": "喜欢动画和图表",
                    "难度偏好": "适中",
                    "学习时间": "下午",
                    "奖励方式": "游戏化"
                ],
                adaptability: 0.8,
                feedbackSensitivity: 0.9,
                learningPace: 0.7
            ),
            DouBaoStudentProfile(
                name: "小红",
                age: 11,
                grade: "五年级",
                studentType: .struggling,
                learningStyle: .visual,
                subjects: [.math, .chinese],
                strengths: ["艺术感", "创造力"],
                weaknesses: ["数学基础", "逻辑推理", "计算能力"],
                learningGoals: ["提高数学基础", "建立学习信心"],
                preferences: [
                    "学习方式": "喜欢画画和颜色",
                    "难度偏好": "简单",
                    "学习时间": "上午",
                    "奖励方式": "表扬"
                ],
                adaptability: 0.6,
                feedbackSensitivity: 0.7,
                learningPace: 0.5
            ),
            DouBaoStudentProfile(
                name: "小强",
                age: 13,
                grade: "七年级",
                studentType: .advanced,
                learningStyle: .kinesthetic,
                subjects: [.math, .physics, .chemistry],
                strengths: ["动手能力", "实验思维", "创新思维"],
                weaknesses: ["理论记忆", "文字表达"],
                learningGoals: ["拓展数学思维", "培养创新能力"],
                preferences: [
                    "学习方式": "喜欢动手实验",
                    "难度偏好": "挑战",
                    "学习时间": "晚上",
                    "奖励方式": "成就感"
                ],
                adaptability: 0.9,
                feedbackSensitivity: 0.8,
                learningPace: 0.8
            ),
            DouBaoStudentProfile(
                name: "小丽",
                age: 12,
                grade: "六年级",
                studentType: .beginner,
                learningStyle: .auditory,
                subjects: [.math, .english],
                strengths: ["语言能力", "听力理解"],
                weaknesses: ["数学思维", "空间想象"],
                learningGoals: ["建立数学基础", "培养学习习惯"],
                preferences: [
                    "学习方式": "喜欢听讲解",
                    "难度偏好": "基础",
                    "学习时间": "下午",
                    "奖励方式": "音乐"
                ],
                adaptability: 0.5,
                feedbackSensitivity: 0.6,
                learningPace: 0.4
            )
        ]
    }
    
    // MARK: - 数学问题数据
    func getMockMathProblems() -> [MathProblem] {
        return [
            MathProblem(
                title: "分数加法",
                content: "计算：1/3 + 2/5 = ?",
                difficulty: 2,
                subject: .math,
                topic: "分数运算",
                solution: "1/3 + 2/5 = 5/15 + 6/15 = 11/15",
                explanation: "首先找到最小公倍数15，然后通分计算",
                tags: ["分数", "加法", "通分"]
            ),
            MathProblem(
                title: "一元一次方程",
                content: "解方程：2x + 3 = 7",
                difficulty: 3,
                subject: .math,
                topic: "方程",
                solution: "2x + 3 = 7\n2x = 7 - 3\n2x = 4\nx = 2",
                explanation: "通过移项和系数化1来解方程",
                tags: ["方程", "移项", "系数化1"]
            ),
            MathProblem(
                title: "几何面积",
                content: "一个长方形的长是8cm，宽是6cm，求面积",
                difficulty: 1,
                subject: .math,
                topic: "几何",
                solution: "面积 = 长 × 宽 = 8 × 6 = 48cm²",
                explanation: "长方形的面积等于长乘以宽",
                tags: ["几何", "长方形", "面积"]
            ),
            MathProblem(
                title: "百分比计算",
                content: "某商品原价100元，打8折后是多少元？",
                difficulty: 2,
                subject: .math,
                topic: "百分比",
                solution: "100 × 0.8 = 80元",
                explanation: "打8折就是原价乘以0.8",
                tags: ["百分比", "折扣", "乘法"]
            ),
            MathProblem(
                title: "应用题",
                content: "小明有12个苹果，给了小红3个，又给了小强2个，还剩几个？",
                difficulty: 1,
                subject: .math,
                topic: "应用题",
                solution: "12 - 3 - 2 = 7个",
                explanation: "用总数减去给出的苹果数量",
                tags: ["应用题", "减法", "生活"]
            )
        ]
    }
    
    // MARK: - 学习步骤数据
    func getMockLearningSteps() -> [LearningStep] {
        return [
            // 基础步骤
            LearningStep(
                title: "拍照识别题目",
                description: "使用OCR技术识别数学题目",
                type: .problemAnalysis,
                duration: 30,
                difficulty: 1,
                expectedOutcome: "准确识别题目内容"
            ),
            LearningStep(
                title: "分析题目类型",
                description: "识别题目属于哪种类型",
                type: .problemAnalysis,
                duration: 60,
                difficulty: 2,
                expectedOutcome: "明确题目类型和解题思路"
            ),
            LearningStep(
                title: "概念讲解",
                description: "讲解相关数学概念",
                type: .conceptExplanation,
                duration: 180,
                difficulty: 2,
                expectedOutcome: "理解相关概念"
            ),
            LearningStep(
                title: "解题步骤演示",
                description: "详细演示解题过程",
                type: .interactiveDemo,
                duration: 240,
                difficulty: 3,
                expectedOutcome: "掌握解题方法"
            ),
            LearningStep(
                title: "基础练习",
                description: "完成基础练习题",
                type: .practiceExercise,
                duration: 300,
                difficulty: 2,
                expectedOutcome: "巩固基础知识"
            ),
            LearningStep(
                title: "技巧总结",
                description: "总结解题技巧和要点",
                type: .conceptExplanation,
                duration: 120,
                difficulty: 2,
                expectedOutcome: "掌握解题技巧"
            ),
            LearningStep(
                title: "拓展练习",
                description: "完成难度更高的练习题",
                type: .practiceExercise,
                duration: 360,
                difficulty: 4,
                expectedOutcome: "提升解题能力"
            ),
            LearningStep(
                title: "效果评估",
                description: "评估学习效果",
                type: .assessment,
                duration: 180,
                difficulty: 3,
                expectedOutcome: "了解掌握程度"
            ),
            
            // 辅助步骤
            LearningStep(
                title: "可视化图表",
                description: "通过图表理解概念",
                type: .visualAid,
                duration: 90,
                difficulty: 1,
                expectedOutcome: "直观理解概念"
            ),
            LearningStep(
                title: "音频讲解",
                description: "听音频讲解概念",
                type: .audioExplanation,
                duration: 120,
                difficulty: 1,
                expectedOutcome: "听觉理解概念"
            ),
            LearningStep(
                title: "游戏化练习",
                description: "通过游戏练习",
                type: .gamification,
                duration: 240,
                difficulty: 2,
                expectedOutcome: "趣味性学习"
            ),
            LearningStep(
                title: "实际应用",
                description: "联系实际生活应用",
                type: .realWorldExample,
                duration: 150,
                difficulty: 3,
                expectedOutcome: "理解实际应用"
            ),
            LearningStep(
                title: "同伴讨论",
                description: "与同伴讨论解题思路",
                type: .peerLearning,
                duration: 180,
                difficulty: 2,
                expectedOutcome: "交流学习心得"
            ),
            LearningStep(
                title: "复习巩固",
                description: "复习已学内容",
                type: .reviewSession,
                duration: 200,
                difficulty: 2,
                expectedOutcome: "巩固学习成果"
            ),
            LearningStep(
                title: "拓展活动",
                description: "参与拓展学习活动",
                type: .extensionActivity,
                duration: 300,
                difficulty: 4,
                expectedOutcome: "拓展知识面"
            )
        ]
    }
    
    // MARK: - 用户反馈数据
    func getMockUserFeedback() -> [UserFeedback] {
        return [
            UserFeedback(
                type: .comprehension,
                content: "概念讲解很清楚，容易理解",
                rating: 4.5,
                context: "分数加法概念讲解",
                emotionalState: .satisfied
            ),
            UserFeedback(
                type: .difficulty,
                content: "题目有点难，需要更多练习",
                rating: 2.0,
                context: "一元一次方程练习",
                emotionalState: .frustrated
            ),
            UserFeedback(
                type: .engagement,
                content: "游戏化练习很有趣，想继续",
                rating: 5.0,
                context: "几何面积游戏练习",
                emotionalState: .excited
            ),
            UserFeedback(
                type: .confusion,
                content: "步骤太多，记不住",
                rating: 1.5,
                context: "复杂应用题解题",
                emotionalState: .confused
            ),
            UserFeedback(
                type: .interest,
                content: "实际应用例子很生动",
                rating: 4.0,
                context: "百分比实际应用",
                emotionalState: .curious
            ),
            UserFeedback(
                type: .confidence,
                content: "掌握了方法，有信心",
                rating: 4.5,
                context: "解题技巧总结",
                emotionalState: .confident
            ),
            UserFeedback(
                type: .satisfaction,
                content: "整体学习体验很好",
                rating: 4.0,
                context: "完整学习过程",
                emotionalState: .satisfied
            ),
            UserFeedback(
                type: .frustration,
                content: "重复练习太无聊",
                rating: 1.0,
                context: "基础练习环节",
                emotionalState: .bored
            )
        ]
    }
    
    // MARK: - 路径调整数据
    func getMockPathAdjustments() -> [PathAdjustment] {
        return [
            PathAdjustment(
                strategy: .addConceptExplanation,
                reason: "用户反馈概念理解困难",
                confidence: 0.85,
                expectedImpact: "提高概念理解程度",
                insertionPoint: 2
            ),
            PathAdjustment(
                strategy: .addVisualAid,
                reason: "视觉型学习者需要图表辅助",
                confidence: 0.9,
                expectedImpact: "增强可视化理解",
                insertionPoint: 3
            ),
            PathAdjustment(
                strategy: .addGamification,
                reason: "用户反馈练习环节枯燥",
                confidence: 0.8,
                expectedImpact: "提高学习兴趣",
                insertionPoint: 5
            ),
            PathAdjustment(
                strategy: .addPracticeDrill,
                reason: "用户反馈需要更多练习",
                confidence: 0.75,
                expectedImpact: "巩固学习效果",
                insertionPoint: 6
            ),
            PathAdjustment(
                strategy: .simplifyComplexStep,
                reason: "用户反馈步骤过于复杂",
                confidence: 0.7,
                expectedImpact: "降低学习难度",
                removalPoint: 4
            ),
            PathAdjustment(
                strategy: .addRealWorldExample,
                reason: "用户对实际应用感兴趣",
                confidence: 0.85,
                expectedImpact: "增强学习动机",
                insertionPoint: 7
            ),
            PathAdjustment(
                strategy: .slowDownForMastery,
                reason: "用户学习节奏较慢",
                confidence: 0.8,
                expectedImpact: "确保充分掌握",
                insertionPoint: nil
            ),
            PathAdjustment(
                strategy: .addPeerLearning,
                reason: "用户需要交流讨论",
                confidence: 0.7,
                expectedImpact: "促进深度思考",
                insertionPoint: 8
            )
        ]
    }
    
    // MARK: - 动态路径生成
    func generateDynamicPath(for student: DouBaoStudentProfile) -> [LearningStep] {
        let allSteps = getMockLearningSteps()
        
        // 根据学生类型生成基础路径
        var basePath: [LearningStep] = []
        
        switch student.studentType {
        case .beginner:
            basePath = [
                allSteps[0], // 拍照识别
                allSteps[2], // 概念讲解
                allSteps[3], // 解题步骤演示
                allSteps[4], // 基础练习
                allSteps[5], // 技巧总结
                allSteps[7]  // 效果评估
            ]
        case .intermediate:
            basePath = [
                allSteps[0], // 拍照识别
                allSteps[1], // 分析题目类型
                allSteps[3], // 解题步骤演示
                allSteps[5], // 技巧总结
                allSteps[4], // 基础练习
                allSteps[7]  // 效果评估
            ]
        case .advanced:
            basePath = [
                allSteps[0], // 拍照识别
                allSteps[1], // 分析题目类型
                allSteps[3], // 解题步骤演示
                allSteps[6], // 拓展练习
                allSteps[13], // 拓展活动
                allSteps[7]  // 效果评估
            ]
        case .struggling:
            basePath = [
                allSteps[0], // 拍照识别
                allSteps[2], // 概念讲解
                allSteps[8], // 可视化图表
                allSteps[3], // 解题步骤演示
                allSteps[4], // 基础练习
                allSteps[12], // 复习巩固
                allSteps[7]  // 效果评估
            ]
        case .adaptive:
            // 自适应型根据学习风格调整
            basePath = generateAdaptivePath(for: student, allSteps: allSteps)
        }
        
        return basePath
    }
    
    private func generateAdaptivePath(for student: DouBaoStudentProfile, allSteps: [LearningStep]) -> [LearningStep] {
        var path = [
            allSteps[0], // 拍照识别
            allSteps[1], // 分析题目类型
        ]
        
        // 根据学习风格添加特定步骤
        switch student.learningStyle {
        case .visual:
            path.append(allSteps[8]) // 可视化图表
        case .auditory:
            path.append(allSteps[9]) // 音频讲解
        case .kinesthetic:
            path.append(allSteps[11]) // 实际应用
        case .reading:
            path.append(allSteps[2]) // 概念讲解
        case .mixed:
            path.append(allSteps[8]) // 可视化图表
            path.append(allSteps[9]) // 音频讲解
        case .adaptive:
            // 根据学生偏好动态选择
            if student.preferences["学习方式"]?.contains("动画") == true {
                path.append(allSteps[8]) // 可视化图表
            }
            if student.preferences["学习方式"]?.contains("讲解") == true {
                path.append(allSteps[9]) // 音频讲解
            }
        }
        
        path.append(allSteps[3]) // 解题步骤演示
        path.append(allSteps[4]) // 基础练习
        path.append(allSteps[5]) // 技巧总结
        path.append(allSteps[7]) // 效果评估
        
        return path
    }
    
    // MARK: - 反馈模拟
    func simulateFeedback(for step: LearningStep) -> UserFeedback {
        let feedbackTypes: [FeedbackType] = [.comprehension, .engagement, .difficulty, .satisfaction]
        let emotionalStates: [EmotionalState] = [.excited, .satisfied, .confused, .frustrated, .curious]
        
        let randomType = feedbackTypes.randomElement() ?? .satisfaction
        let randomEmotion = emotionalStates.randomElement()
        let randomRating = Double.random(in: 1.0...5.0)
        
        let feedbackContent = generateFeedbackContent(for: step, type: randomType, rating: randomRating)
        
        return UserFeedback(
            type: randomType,
            content: feedbackContent,
            rating: randomRating,
            context: step.title,
            emotionalState: randomEmotion
        )
    }
    
    private func generateFeedbackContent(for step: LearningStep, type: FeedbackType, rating: Double) -> String {
        let contents: [FeedbackType: [String]] = [
            .comprehension: [
                "概念讲解很清楚，容易理解",
                "步骤说明很详细，学得很明白",
                "有些地方还是不太懂",
                "完全理解了，很有收获"
            ],
            .engagement: [
                "很有趣，想继续学习",
                "参与度很高，很投入",
                "有点无聊，想换其他内容",
                "互动性很强，很喜欢"
            ],
            .difficulty: [
                "难度适中，刚刚好",
                "有点简单，想要挑战",
                "太难了，需要更多帮助",
                "难度递增合理"
            ],
            .satisfaction: [
                "整体体验很好",
                "学习效果不错",
                "还可以，但还有改进空间",
                "非常满意这次学习"
            ]
        ]
        
        let typeContents = contents[type] ?? ["学习体验不错"]
        return typeContents.randomElement() ?? "学习体验不错"
    }
    
    // MARK: - 路径调整生成
    func generatePathAdjustment(for feedback: UserFeedback) -> PathAdjustment {
        let adjustments: [PathAdjustmentStrategy] = [
            .addConceptExplanation,
            .addVisualAid,
            .addGamification,
            .addPracticeDrill,
            .simplifyComplexStep,
            .addRealWorldExample,
            .slowDownForMastery,
            .addPeerLearning
        ]
        
        let randomStrategy = adjustments.randomElement() ?? .addConceptExplanation
        let randomConfidence = Double.random(in: 0.6...0.95)
        let randomInsertionPoint = Int.random(in: 1...5)
        
        let reason = generateAdjustmentReason(for: feedback, strategy: randomStrategy)
        let expectedImpact = generateExpectedImpact(for: randomStrategy)
        
        return PathAdjustment(
            strategy: randomStrategy,
            reason: reason,
            confidence: randomConfidence,
            expectedImpact: expectedImpact,
            insertionPoint: randomInsertionPoint
        )
    }
    
    private func generateAdjustmentReason(for feedback: UserFeedback, strategy: PathAdjustmentStrategy) -> String {
        switch strategy {
        case .addConceptExplanation:
            return "用户反馈概念理解困难"
        case .addVisualAid:
            return "视觉型学习者需要图表辅助"
        case .addGamification:
            return "用户反馈练习环节枯燥"
        case .addPracticeDrill:
            return "用户反馈需要更多练习"
        case .simplifyComplexStep:
            return "用户反馈步骤过于复杂"
        case .addRealWorldExample:
            return "用户对实际应用感兴趣"
        case .slowDownForMastery:
            return "用户学习节奏较慢"
        case .addPeerLearning:
            return "用户需要交流讨论"
        default:
            return "优化学习体验"
        }
    }
    
    private func generateExpectedImpact(for strategy: PathAdjustmentStrategy) -> String {
        switch strategy {
        case .addConceptExplanation:
            return "提高概念理解程度"
        case .addVisualAid:
            return "增强可视化理解"
        case .addGamification:
            return "提高学习兴趣"
        case .addPracticeDrill:
            return "巩固学习效果"
        case .simplifyComplexStep:
            return "降低学习难度"
        case .addRealWorldExample:
            return "增强学习动机"
        case .slowDownForMastery:
            return "确保充分掌握"
        case .addPeerLearning:
            return "促进深度思考"
        default:
            return "优化学习效果"
        }
    }
} 