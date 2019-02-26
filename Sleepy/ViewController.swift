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
    
    @IBOutlet
    var ping: UIButton!
    
    var socket: GCDAsyncSocket?
    
    @objc
    @IBAction
    func sleep(sender: UIButton) {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        self.socket = socket
        let port = UInt16(8999)
        do {
            socket.autoDisconnectOnClosedReadStream = false
            try socket.connect(toHost: "192.168.100.90", onPort: port)
            socket.write("*".data(using: .ascii)!, withTimeout: -1, tag: 0)
            socket.readData(toLength: 1, withTimeout: -1, tag: 0)
            self.ping.isEnabled = false
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
        let response = String(data: data, encoding: .ascii)
        if response == "*" {
            let view = MessageView.viewFromNib(layout: .statusLine)
            view.configureTheme(.success)
            view.configureDropShadow()
            view.configureContent(body: "mac 已经睡着啦👍")
            view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
            SwiftMessages.show(view: view)
        }
        sock.disconnect()
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.ping.isEnabled = true
        guard err == nil else {
            let view = MessageView.viewFromNib(layout: .statusLine)
            view.configureTheme(.error)
            view.configureDropShadow()
            view.configureContent(body: "服务端意外地关闭了连接")
            view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
            SwiftMessages.show(view: view)
            return
        }
        self.socket = nil
    }
    
   

}

