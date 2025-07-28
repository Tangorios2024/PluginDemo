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
        btn.setTitle("购买按钮", for: .normal)
        btn.backgroundColor = .blue
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchaseButton.addTarget(self, action: #selector(purchaseAction), for: .touchUpInside)
        
        view.addSubview(purchaseButton)
        
        purchaseButton.centerXAnchor == view.centerXAnchor
        purchaseButton.centerYAnchor == view.centerYAnchor
        purchaseButton.sizeAnchors == CGSize(width: 200, height: 64)
    }
    
    @objc func purchaseAction() {
        UserActionTracker.shared.track(.purchase(itemId: "SKU123", price: 9.99))
    }

}

