//
//  ViewController.swift
//  mobile-lab-websockets
//
//  Created by Sebastian Buys on 2/20/18.
//  Copyright © 2018 Sebastian Buys. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var socket: WebSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create WebSocket
        socket = WebSocket(url: URL(string: "ws://10.0.0.20:8080/")!)
        
        // Assign WebSocket delegate to self
        socket?.delegate = self
        
        // Connect
        socket?.connect()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("--- viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // WebSocket delegate methods
    func websocketDidConnect(socket: WebSocketClient) {
        print(">>> websocket did connect")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(">>> websocket did disconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(">>> websocket did receive message:", text)
        messageLabel.text = text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = dateFormatter.string(from: Date())
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(">>> websocket did receive data:", data)
    }
    
    @objc func willResignActive() {
        print(">>> Application will resign active. Disconnecting socket.")
        socket?.disconnect()
    }
    
    @objc func didBecomeActive() {
        print(">>> Application did become active. Connecting socket.")
        socket?.connect()
    }
}

// Some helpers using extensions
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

