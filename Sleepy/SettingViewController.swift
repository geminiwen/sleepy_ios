//
//  Settings.swift
//  Sleepy
//
//  Created by Gemini Wen on 2019/3/1.
//  Copyright © 2019 geminiwen.com. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet
    var hostField: UITextField!
    
    @IBOutlet
    var portField: UITextField!
 
    @IBAction
    func save(sender: Any) {
        let host = self.hostField.text
        let portString = self.portField.text
        
        self.navigationController?.dismiss(animated: true, completion: nil)
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
