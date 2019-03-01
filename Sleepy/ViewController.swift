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
    
    private var host: String?
    private var port: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadService), name: NSNotification.Name("configUpdate"), object: nil)
        self.reloadService()
    }
    
    @objc
    func reloadService() {
        let defaults = UserDefaults.standard
        self.host = defaults.string(forKey: "host")
        self.port = defaults.integer(forKey: "port")
    }
    
    @objc
    @IBAction
    func sleep(sender: UIButton) {
        guard let host = self.host, let port = self.port else {
            let view = MessageView.viewFromNib(layout: .statusLine)
            view.configureTheme(.error)
            view.configureDropShadow()
            view.configureContent(body: "请先点击右上角配置")
            view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
            SwiftMessages.show(view: view)
            return
        }
        
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        self.socket = socket
        do {
            socket.autoDisconnectOnClosedReadStream = false
            try socket.connect(toHost: host, onPort: UInt16(port))
            socket.write("*".data(using: .ascii)!, withTimeout: 10, tag: 0)
            socket.readData(toLength: 1, withTimeout: 10, tag: 0)
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
            view.configureTheme(backgroundColor: UIColor(red: 35.0/255, green: 212.0/255, blue: 186.0/255, alpha: 1), foregroundColor: .white)
            view.configureDropShadow()
            view.configureContent(body: "Mac 已经睡着啦👍")
            view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
            SwiftMessages.show(view: view)
        }
        sock.disconnect()
    }
    
    func socket(_ sock: GCDAsyncSocket, shouldTimeoutReadWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(body: "Mac 响应超时，请重试🧐")
        view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        SwiftMessages.show(view: view)
        return -1
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.ping.isEnabled = true
        if let error = err as NSError? {
            let code = error.code
            switch code {
            case 7: // socket closed by remote
                let view = MessageView.viewFromNib(layout: .statusLine)
                view.configureTheme(.error)
                view.configureDropShadow()
                view.configureContent(body: "Mac 连接不成功")
                view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
                SwiftMessages.show(view: view)
                break
            case 4: // read operation timeout
                break
            default:
                let view = MessageView.viewFromNib(layout: .statusLine)
                view.configureTheme(.error)
                view.configureDropShadow()
                view.configureContent(body: "服务端意外地关闭了连接")
                view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
                SwiftMessages.show(view: view)
                break
            }
          
            return
        }
        self.socket = nil
    }
    
   

}

