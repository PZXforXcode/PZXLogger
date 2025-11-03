//
//  ViewController.swift
//  PZXLogger
//
//  Created by 彭祖鑫 on 2025/11/3.
//

import UIKit

class ViewController: UIViewController {

    private let simulateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("打印新日志", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        return btn
    }()

    private let clearButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("清空日志", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
        PZXLogInfo("写入数据: 54 4C 11 00 02 02 09 1E")
        PZXLogDebug("指令--0x0209--8 bytes")
        PZXLogError("蓝牙连接异常")
        PZXLogWarn("信号强度过低")

        let stack = UIStackView(arrangedSubviews: [simulateButton, clearButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        simulateButton.addTarget(self, action: #selector(simulateTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 导出日志（压缩所有日志）
        PZXLogger.exportLog(from: self)
        
        // 主动清理所有日志
        // PZXLogger.shared.clearAllLogs()
    }
    
    @objc private func simulateTapped() {
        PZXLogInfo("写入数据: 12 34 56 78 90 AB CD EF")
        PZXLogDebug("模拟指令--0x0301--16 bytes")
        PZXLogWarn("模拟警告：电池电量偏低")
        PZXLogError("模拟错误：蓝牙断开，请重连")
    }

    @objc private func clearTapped() {
        PZXLogger.clearAllLogs()
    }


}



