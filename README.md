# 插件式架构演示项目

本项目完整实现了 READMEDemo.md 中描述的两个插件式架构场景：

1. **客户端用户行为追踪系统 (UserActionTracker)**
2. **大模型处理管道系统 (LLMProcessingPipeline)**

## 项目架构

### 技术栈
- **架构模式**: MVVM-C (Model-View-ViewModel-Coordinator)
- **依赖注入**: Swinject
- **UI 框架**: UIKit + Anchorage (Auto Layout)
- **语言**: Swift 5.0+

### 目录结构

```
PluginDemo/
├── UserActionTracker/           # 场景一：用户行为追踪
│   ├── UserAction.swift         # 行为定义和插件协议
│   ├── UserActionTracker.swift  # 宿主系统
│   ├── FirebaseAnalyticsPlugin.swift
│   ├── AppsFlyerPlugin.swift
│   └── ABTestPlugin.swift       # A/B测试插件
├── LLMPipeline/                 # 场景二：LLM处理管道
│   ├── Models/                  # 数据模型
│   ├── Protocols/               # 插件协议
│   ├── Core/                    # 核心管道系统
│   ├── Services/                # 服务层
│   └── Plugins/                 # 插件实现
│       ├── Bank/                # 银行客户插件
│       └── School/              # 学校客户插件
├── MVVM/                        # MVVM-C 架构组件
│   ├── ViewModels/
│   ├── ViewControllers/
│   └── Coordinators/
├── DI/                          # 依赖注入配置
├── Services/                    # 服务协议
└── Tests/                       # 测试代码
```

## 场景一：用户行为追踪系统

### 核心组件

- **UserActionTracker**: 宿主系统，负责事件分发
- **ActionTrackerPlugin**: 插件契约协议
- **UserAction**: 用户行为枚举定义
- **ActionContext**: 上下文信息传递

### 扩展点

1. **事件过滤** (`shouldTrack`): 插件选择处理的事件类型
2. **事件转换** (`transform`): 插件修改或丰富事件数据
3. **事件处理** (`track`): 插件执行实际的追踪逻辑

### 插件实现

- **FirebaseAnalyticsPlugin**: 模拟 Firebase 分析
- **AppsFlyerPlugin**: 模拟 AppsFlyer 归因追踪
- **ABTestPlugin**: A/B 测试数据注入

## 场景二：LLM 处理管道系统

### 核心组件

- **LLMProcessingPipeline**: 宿主系统，管理请求处理流程
- **LLMPlugin**: 插件契约协议
- **LLMContext**: 贯穿整个管道的上下文对象
- **CoreLLMService**: 核心 LLM 服务接口

### 处理阶段

1. **认证与授权** (`authenticate`)
2. **请求预处理** (`processRequest`)
3. **核心 LLM 调用**
4. **响应后处理** (`processResponse`)
5. **审计与日志** (`audit`)

### 银行客户插件

- **HmacAuthPlugin**: HMAC 签名认证
- **PiiRedactionPlugin**: PII 信息脱敏
- **FinancialGuardrailPlugin**: 金融内容安全检查
- **SecureAuditPlugin**: 安全审计日志

### 学校客户插件

- **ApiKeyAuthPlugin**: API Key 认证
- **QuotaControlPlugin**: 使用配额管理
- **EducationalPromptInjectorPlugin**: 教育提示词注入
- **ContentSafetyFilterPlugin**: 内容安全过滤

## 使用方法

### 运行演示

1. 打开 Xcode 项目
2. 运行应用
3. 在主界面点击不同按钮体验功能：
   - **购买商品**: 触发购买事件追踪
   - **浏览页面**: 触发页面浏览追踪
   - **自定义事件**: 触发自定义事件追踪
   - **LLM 管道演示**: 进入 LLM 处理管道演示页面

### 查看日志

应用启动时会自动运行测试，在 Xcode 控制台可以看到详细的插件执行日志。

## 架构优势

### 解耦与可扩展性
- 业务逻辑与具体实现完全分离
- 新增功能只需添加插件，无需修改核心代码
- 插件可独立开发、测试和部署

### 可组合性
- 通过不同插件组合满足不同客户需求
- 插件执行顺序可配置
- 支持插件间数据传递和协作

### 面向协议设计
- 所有服务都基于协议定义
- 便于单元测试和模拟
- 支持依赖注入和控制反转

## 扩展示例

### 添加新的追踪插件

```swift
class CustomAnalyticsPlugin: ActionTrackerPlugin {
    let pluginId = "com.myapp.custom"
    
    func track(action: UserAction, context: ActionContext) {
        // 自定义追踪逻辑
    }
}

// 注册插件
UserActionTracker.shared.register(plugin: CustomAnalyticsPlugin())
```

### 添加新的 LLM 插件

```swift
class CustomLLMPlugin: LLMPlugin {
    let pluginId = "com.custom.plugin"
    let priority = 50
    
    func processRequest(context: LLMContext) async throws {
        // 自定义请求处理逻辑
    }
}

// 注册插件
pipeline.register(plugin: CustomLLMPlugin())
```

## 测试

项目包含完整的测试代码，验证：
- 插件注册和执行
- 错误处理机制
- 不同场景的端到端流程

运行测试：应用启动时自动执行，或手动调用 `PluginArchitectureTests.runAllTests()`

## 安全特性

### 银行令牌认证
银行客户场景使用简化的令牌认证机制：

- **认证方式**: 银行令牌验证
- **令牌格式**: `BANK_TOKEN_*` 前缀
- **客户类型**: 支持普通、VIP、企业客户
- **安全验证**: 令牌格式和有效性检查

#### 支持的令牌类型
- `BANK_TOKEN_DEMO_001`: 普通客户
- `BANK_TOKEN_VIP_002`: VIP客户
- `BANK_TOKEN_CORP_003`: 企业客户

### PII 数据脱敏
自动识别和脱敏敏感信息：
- 身份证号码
- 银行卡号
- 手机号码
- 邮箱地址
- 中文姓名

### 合规审计
- 自动记录所有银行业务请求
- 添加合规声明和风险提示
- 生成审计日志用于监管报告

## 新增场景：AI 能力组合平台

### 🤖 场景概述

基于大模型的能力，app 提供了多种多样的功能，如数学出题、解题、水印、图片生成、深度思考、网络搜索、音视频通话、OCR 等能力。通过插件式架构，可以对能力/服务进行灵活组合，为不同业务方提供定制化的功能组合。

### 🎓 智慧教育平台专项场景

#### 场景1：智能学习助手
**完整学习闭环：智能出题 → 拍照识别 → 解答分析 → 错题收集 → 学习周报 → 一对一讲解**

**涉及能力组合：**
- 🧮 **智能出题**: 数学出题能力 (`mathProblemGeneration`)
- 📷 **拍照识别**: OCR识别能力 (`ocr`)
- 🔍 **智能解答**: 数学解题能力 (`mathProblemSolving`)
- 📊 **错题分析**: 数据分析能力 (`dataAnalysis`)
- 📋 **学习周报**: 文本摘要能力 (`textSummary`)
- 🎥 **一对一讲解**: 音视频通话能力 (`videoCall`)

**业务价值：**
- 个性化出题，针对学生薄弱环节
- 智能识别手写题目，提高学习效率
- 详细解题步骤，培养逻辑思维
- 错题自动收集，形成个人知识图谱
- 周报分析学习趋势，指导学习方向
- 真人讲解疑难问题，提升学习效果

#### 场景2：互动故事推荐
**个性化内容生态：用户画像 → 故事推荐 → 个性化生成 → 语音合成 → 智能交互**

**涉及能力组合：**
- 👤 **用户画像**: 用户画像分析 (`userProfiling`)
- 🎯 **内容推荐**: 智能推荐算法 (`contentRecommendation`)
- ✍️ **故事生成**: 创意内容生成 (`storyGeneration`)
- 🎵 **语音合成**: 文本转语音 (`tts`)
- 💬 **智能交互**: 对话交互能力 (`dialogueInteraction`)

**业务价值：**
- 基于年龄、兴趣、识字量构建精准用户画像
- 智能推荐适合的故事内容和难度
- 动态生成个性化故事情节
- 高质量语音合成，提供沉浸式体验
- 智能对话引导，培养想象力和表达能力

### 🏗️ 架构设计

#### 核心组件

1. **AICapabilityProtocol**: 定义 AI 能力插件的统一接口
2. **AICapabilityManager**: 管理所有 AI 能力插件的宿主系统
3. **BusinessConfiguration**: 业务方配置，定义启用的能力和配额限制

#### 支持的 AI 能力

**基础能力：**
- 🧮 **数学能力**: 数学出题、数学解题
- 🤔 **深度思考**: 多维度分析和思考
- 📄 **内容处理**: OCR识别、翻译、文本摘要
- 🎨 **图像处理**: 图片生成、图片水印
- 🌐 **网络服务**: 网络搜索、音视频通话

**教育专用能力：**
- 📊 **数据分析**: 学习行为分析、错题统计
- 👤 **用户画像**: 学习偏好、能力评估
- 🎯 **内容推荐**: 个性化内容匹配
- 🎵 **语音合成**: 高质量TTS，支持情感表达
- 💬 **对话交互**: 智能问答、引导式对话
- ✍️ **故事生成**: 创意内容生成、情节设计

### 🎯 业务场景演示

#### 1. 智慧教育平台（新增专项场景）
- **启用能力**: 全套教育能力（16种）
- **场景1组合**: 数学出题 → OCR识别 → 数学解题 → 数据分析 → 文本摘要 → 音视频通话
- **场景2组合**: 用户画像 → 内容推荐 → 故事生成 → 语音合成 → 对话交互
- **教育价值**: 个性化学习、智能辅导、互动体验、全程跟踪

#### 2. 内容创作场景
- **启用能力**: 图片生成、图片水印、深度思考、文本摘要、翻译、网络搜索
- **能力组合**: 深度思考 + 图片生成（创意策划和视觉设计）

#### 3. 企业办公场景
- **启用能力**: 全部能力
- **能力组合**: 网络搜索 + 深度思考 + 文本摘要（市场调研和分析报告）

#### 4. 个人用户场景
- **启用能力**: 文本摘要、翻译、网络搜索、OCR
- **配额限制**: 基础套餐，有使用次数限制

### 🔧 技术特性

#### 插件竞争机制
- 多个插件可以支持同一种能力（如 NetworkCapabilityPlugin 和 MultimediaCapabilityPlugin 都支持视频通话）
- 通过优先级自动选择最合适的插件

#### 动态能力发现
- 自动发现业务方可用的能力
- 智能推荐能力组合方案
- 实时统计插件覆盖率

#### 面向协议设计
- 统一的 AICapabilityPlugin 协议
- 标准化的输入输出格式
- 灵活的元数据传递机制

### 📊 演示输出

运行应用时，控制台将输出详细的演示日志，包括：

```
🤖 AICapabilityManager: 初始化完成
✅ AICapabilityManager: 注册插件 com.ai.math - 数学能力引擎
   支持能力: 数学出题, 数学解题
✅ AICapabilityManager: 注册插件 com.ai.education - 智慧教育引擎
   支持能力: 数据分析, 用户画像
🏢 AICapabilityManager: 注册业务配置 smart_edu_001 - 智慧教育平台
   启用能力: 数学出题, 数学解题, OCR识别, 数据分析, 文本摘要, 音视频通话, 用户画像, 内容推荐, 故事生成, 文本转语音, 对话交互

🎓 智慧教育平台场景演示
📚 场景1：智能学习助手
🔄 执行步骤：智能出题
   ✅ 执行成功 - 处理时间: 0.500秒
🔄 执行步骤：拍照识别题目
   ✅ 执行成功 - 处理时间: 0.800秒
🔄 执行步骤：学习数据分析
   ✅ 执行成功 - 处理时间: 1.000秒

📖 场景2：互动故事推荐
🔄 执行步骤：构建用户画像
   ✅ 执行成功 - 处理时间: 0.800秒
🔄 执行步骤：语音合成
   🎭 AdvancedTTSPlugin: 开始高级语音合成 (优先级更高)
   ✅ 执行成功 - 处理时间: 1.000秒
```

## 总结

本项目展示了插件式架构在三个不同场景中的应用：

1. **用户行为追踪系统**: 展示了插件在数据处理管道中的应用
2. **LLM 处理管道**: 展示了插件在业务流程中的分层处理
3. **AI 能力组合平台**: 展示了插件在服务组合和业务定制中的应用

### 🎓 智慧教育场景亮点

**技术创新：**
- **插件竞争机制**: 多个插件支持同一能力，自动选择最优实现（如高级TTS vs普通TTS）
- **能力组合编排**: 复杂业务流程的智能编排和执行
- **个性化配置**: 基于业务方需求的灵活能力组合

**教育价值：**
- **场景1**: 完整学习闭环，从出题到讲解的全流程AI辅助
- **场景2**: 个性化内容生态，培养阅读兴趣和想象力
- **数据驱动**: 基于学习数据的智能分析和个性化推荐

**架构优势：**
- **高扩展性**: 新增教育能力只需实现插件接口
- **业务隔离**: 不同教育场景可独立配置和优化
- **服务复用**: 基础能力可在多个教育场景中复用

体现了"定义契约，分离关注，动态组合"的核心思想，通过清晰的扩展点设计和面向协议的实现，实现了高度可扩展和可维护的系统架构，特别适合教育场景中复杂的AI能力组合需求。
