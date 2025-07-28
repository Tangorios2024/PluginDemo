//
//  ViewController.swift
//  PluginDemo
//
//  Created by Tangorios on 2025/7/28.
//

import UIKit
import Anchorage

class ViewController: UIViewController {

    lazy var purchaseButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("购买商品", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 8
        return btn
    }()

    lazy var viewScreenButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("浏览页面", for: .normal)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 8
        return btn
    }()

    lazy var customEventButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("自定义事件", for: .normal)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 8
        return btn
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [purchaseButton, viewScreenButton, customEventButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupActions()

        // 追踪页面浏览
        UserActionTracker.shared.track(.viewScreen(name: "MainViewController"), from: self, userId: "user123")
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)

        stackView.centerXAnchor == view.centerXAnchor
        stackView.centerYAnchor == view.centerYAnchor
        stackView.widthAnchor == 250
        stackView.heightAnchor == 220
    }

    private func setupActions() {
        purchaseButton.addTarget(self, action: #selector(purchaseAction), for: .touchUpInside)
        viewScreenButton.addTarget(self, action: #selector(viewScreenAction), for: .touchUpInside)
        customEventButton.addTarget(self, action: #selector(customEventAction), for: .touchUpInside)
    }

    @objc func purchaseAction() {
        UserActionTracker.shared.track(.purchase(productId: "SKU123", value: 9.99), from: self, userId: "user123")
    }

    @objc func viewScreenAction() {
        UserActionTracker.shared.track(.viewScreen(name: "ProductDetailViewController"), from: self, userId: "user123")
    }

    @objc func customEventAction() {
        let properties = [
            "category": "engagement",
            "source": "main_screen"
        ]
        UserActionTracker.shared.track(.custom(name: "feature_interaction", properties: properties), from: self, userId: "user123")
    }

}

