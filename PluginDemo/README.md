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

## 总结

本项目展示了插件式架构在两个不同场景中的应用，体现了"定义契约，分离关注，动态组合"的核心思想。通过清晰的扩展点设计和面向协议的实现，实现了高度可扩展和可维护的系统架构。
