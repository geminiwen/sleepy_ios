//
//  Settings.swift
//  Sleepy
//
//  Created by Gemini Wen on 2019/3/1.
//  Copyright © 2019 geminiwen.com. All rights reserved.
//

import UIKit
import SwiftMessages

class SettingViewController: UIViewController {
    
    @IBOutlet
    var hostField: UITextField!
    
    @IBOutlet
    var portField: UITextField!
 
    @IBAction
    func save(sender: Any) {
        guard let host = self.hostField.text else {
            showError("主机不能为空")
            return
        }
        
        guard let portString = self.portField.text else {
            showError("端口号不能为空")
            return
        }
        
        guard let port = Int(portString) else {
            showError("端口号必须是整数")
            return
        }
        
        guard port > 0, port < 65536 else {
            showError("端口号不合法")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(host, forKey: "host")
        defaults.set(port, forKey: "port")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: "configUpdate"), object: nil, userInfo: nil)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func showError(_ message: String) {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        SwiftMessages.show(view: view)
        return
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        let host = defaults.string(forKey: "host")
        let port = defaults.integer(forKey: "port")
        
        self.hostField.text = host
        self.portField.text = String(port)
        
    }
}
