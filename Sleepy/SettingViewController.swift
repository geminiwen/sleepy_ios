//
//  Settings.swift
//  Sleepy
//
//  Created by Gemini Wen on 2019/3/1.
//  Copyright © 2019 geminiwen.com. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
 
    @IBAction
    func save(sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
