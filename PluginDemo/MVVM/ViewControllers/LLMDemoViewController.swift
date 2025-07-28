//
//  LLMDemoViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Anchorage

/// LLM 处理管道演示页面
final class LLMDemoViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "LLM 处理管道演示"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bankButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("银行客户场景", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private lazy var schoolButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("学校客户场景", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private lazy var resultTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 14)
        textView.isEditable = false
        textView.text = "点击上方按钮开始演示..."
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, bankButton, schoolButton, resultTextView])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Properties
    
    private let bankPipeline: LLMProcessingPipeline
    private let schoolPipeline: LLMProcessingPipeline
    
    // MARK: - Initialization
    
    init() {
        // 创建核心 LLM 服务
        let coreLLMService = MockCoreLLMService()
        
        // 创建银行客户管道
        self.bankPipeline = LLMProcessingPipeline(coreLLMService: coreLLMService)
        
        // 创建学校客户管道
        self.schoolPipeline = LLMProcessingPipeline(coreLLMService: coreLLMService)
        
        super.init(nibName: nil, bundle: nil)
        
        setupPipelines()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "LLM 管道演示"
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        stackView.topAnchor == view.safeAreaLayoutGuide.topAnchor + 20
        stackView.leadingAnchor == view.leadingAnchor + 20
        stackView.trailingAnchor == view.trailingAnchor - 20
        stackView.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - 20
        
        titleLabel.heightAnchor == 50
        bankButton.heightAnchor == 50
        schoolButton.heightAnchor == 50
    }
    
    private func setupActions() {
        bankButton.addTarget(self, action: #selector(bankButtonTapped), for: .touchUpInside)
        schoolButton.addTarget(self, action: #selector(schoolButtonTapped), for: .touchUpInside)
    }
    
    private func setupPipelines() {
        // 配置银行客户管道
        bankPipeline.register(plugin: BankTokenAuthPlugin())
        bankPipeline.register(plugin: PiiRedactionPlugin())
        bankPipeline.register(plugin: FinancialGuardrailPlugin())
        bankPipeline.register(plugin: SecureAuditPlugin())

        // 配置学校客户管道
        schoolPipeline.register(plugin: ApiKeyAuthPlugin())
        schoolPipeline.register(plugin: QuotaControlPlugin())
        schoolPipeline.register(plugin: EducationalPromptInjectorPlugin())
        schoolPipeline.register(plugin: ContentSafetyFilterPlugin())
    }
    
    // MARK: - Actions
    
    @objc private func bankButtonTapped() {
        Task {
            await demonstrateBankScenario()
        }
    }
    
    @objc private func schoolButtonTapped() {
        Task {
            await demonstrateSchoolScenario()
        }
    }
    
    // MARK: - Demo Methods
    
    private func demonstrateBankScenario() async {
        updateResultText("🏦 开始银行客户场景演示...\n\n")

        // 创建银行客户配置
        let bankClient = ClientProfile(
            clientId: "bank_001",
            clientType: .bank,
            name: "Demo Bank",
            configuration: [
                "security_level": "high",
                "compliance_required": true
            ]
        )

        // 演示三种不同类型的银行客户
        let scenarios = [
            ("普通客户", "BANK_TOKEN_DEMO_001", "我想了解一下定期存款的利率是多少？"),
            ("VIP客户", "BANK_TOKEN_VIP_002", "我是张三，身份证号码是123456789012345678，银行卡号是6222021234567890123，想咨询一下理财产品的收益率如何？手机号是13812345678"),
            ("企业客户", "BANK_TOKEN_CORP_003", "我们公司需要办理企业贷款，请问有什么产品推荐？")
        ]

        for (customerType, token, prompt) in scenarios {
            appendResultText("👤 \(customerType)场景：\n")
            appendResultText("🔑 令牌：\(token)\n")
            appendResultText("📝 咨询内容：\(prompt)\n\n")

            let bankRequest = LLMRequest(
                prompt: prompt,
                metadata: [
                    "bank_token": token
                ]
            )

            // 处理请求
            let result = await bankPipeline.process(request: bankRequest, for: bankClient)

            switch result {
            case .success(let response):
                appendResultText("✅ 处理成功！\n")
                appendResultText("📄 响应内容：\n\(response.content.prefix(200))...\n\n")

                // 显示关键的处理信息
                if let authMethod = response.metadata["auth_method"] {
                    appendResultText("🔐 认证方式：\(authMethod)\n")
                }
                if let piiRedacted = response.metadata["pii_processed"] as? Bool, piiRedacted {
                    appendResultText("🛡️ PII信息已脱敏处理\n")
                }
                if let complianceAdded = response.metadata["compliance_notice_added"] as? Bool, complianceAdded {
                    appendResultText("📋 已添加合规声明\n")
                }
                appendResultText("\n")

            case .failure(let error):
                appendResultText("❌ 处理失败：\(error.localizedDescription)\n\n")
            }

            appendResultText("-" * 30 + "\n\n")
        }

        appendResultText("🏦 银行客户场景演示完成\n")
        appendResultText("=" * 50 + "\n\n")
    }
    
    private func demonstrateSchoolScenario() async {
        updateResultText("🎓 开始学校客户场景演示...\n\n")
        
        // 创建学校客户配置
        let schoolClient = ClientProfile(
            clientId: "school_001",
            clientType: .school,
            name: "Demo University",
            configuration: [
                "education_level": "university",
                "content_filter": "enabled"
            ]
        )
        
        // 创建学生请求
        let schoolRequest = LLMRequest(
            prompt: "请解释一下量子力学的基本原理，我在学习中遇到了困难",
            metadata: [
                "api_key": "school_demo_key_123"
            ]
        )
        
        appendResultText("📝 请求内容：\(schoolRequest.prompt)\n\n")
        
        // 处理请求
        let result = await schoolPipeline.process(request: schoolRequest, for: schoolClient)
        
        switch result {
        case .success(let response):
            appendResultText("✅ 处理成功！\n")
            appendResultText("📄 响应内容：\n\(response.content)\n\n")
            appendResultText("📊 元数据：\(response.metadata)\n\n")
        case .failure(let error):
            appendResultText("❌ 处理失败：\(error.localizedDescription)\n\n")
        }
        
        appendResultText("🎓 学校客户场景演示完成\n")
        appendResultText("=" * 50 + "\n\n")
    }
    
    // MARK: - Helper Methods
    
    private func updateResultText(_ text: String) {
        DispatchQueue.main.async {
            self.resultTextView.text = text
            self.scrollToBottom()
        }
    }
    
    private func appendResultText(_ text: String) {
        DispatchQueue.main.async {
            self.resultTextView.text += text
            self.scrollToBottom()
        }
    }
    
    private func scrollToBottom() {
        let bottom = NSMakeRange(resultTextView.text.count - 1, 1)
        resultTextView.scrollRangeToVisible(bottom)
    }
    

}

// MARK: - String Extension

private extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
