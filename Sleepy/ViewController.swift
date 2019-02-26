//
//  ViewController.swift
//  Sleepy
//
//  Created by Gemini Wen on 2019/2/26.
//  Copyright © 2019 geminiwen.com. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import SwiftMessages

class ViewController: UIViewController, GCDAsyncSocketDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc
    @IBAction
    func sleep(sender: UIButton) {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        let port = UInt16(8999)
        do {
            try socket.connect(toHost: "cloud.fengguang.me", onPort: port)
            socket.write("*".data(using: .ascii)!, withTimeout: -1, tag: 0)
            socket.readData(toLength: 1, withTimeout: -1, tag: 0)
        } catch {
            let view = MessageView.viewFromNib(layout: .statusLine)
            view.configureTheme(.error)
            view.configureDropShadow()
            view.configureContent(body: "无法连接到服务器，端口号为 \(port)")
            view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
            SwiftMessages.show(view: view)
            
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        sock.disconnect()
    }

}

