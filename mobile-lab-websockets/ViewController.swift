//
//  ViewController.swift
//  mobile-lab-websockets
//
//  Created by Sebastian Buys on 2/20/18.
//  Copyright © 2018 Sebastian Buys. All rights reserved.
//

import UIKit
import Starscream


// Create an enumeration for direction commands.

// An enumeration defines a common type for a group of related values and enables you to work with those values in a type-safe way within your code.

// In this example we also map the enumeration values to the number exact codes we need send to the server for each direction.

// In this case it not only
enum DirectionCode: String {
    case up = "0"
    case right = "1"
    case down = "2"
    case left = "3"
}

let playerId = "sebastian";

class ViewController: UIViewController, WebSocketDelegate {
    
    var socket: WebSocket?
    
    // Button actions connected from storyboard
    @IBAction func didTapUp(_ sender: UIButton) {
        sendDirectionMessage(.up)
    }
    
    @IBAction func didTapRight(_ sender: UIButton) {
        sendDirectionMessage(.right)
    }
    
    @IBAction func didTapDown(_ sender: UIButton) {
        sendDirectionMessage(.down)
    }
    
    @IBAction func didTapLeft(_ sender: UIButton) {
        sendDirectionMessage(.left)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let urlString = "ws://162.243.47.128:1024/"
        //let urlString = "ws://10.0.0.20:1024/"
        let urlString = "ws://websockets.mobilelabclass.com:1024/"
    
        // Create WebSocket
        socket = WebSocket(url: URL(string: urlString)!)
        
        // Assign WebSocket delegate to self
        socket?.delegate = self
        
        // Connect
        socket?.connect()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // WebSocket delegate methods
    func websocketDidConnect(socket: WebSocketClient) {
        print("✅ Connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("🛑 Disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        // print("⬇️ websocket did receive message:", text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        // print("<<< Received data:", data)
    }
    
    func sendMessage(_ message: String) {
        let message = "\(playerId), \(message)"
        socket?.write(string: message) {
            // This is a completion block.
            // We can write custom code here that will run once the message is sent.
            print("⬆️ sent message to server: ", message)
        }
    }
    
    func sendDirectionMessage(_ code: DirectionCode) {
        // Get the raw string value from the DirectionCode enum
        // that we created at the top of this program.
        sendMessage(code.rawValue)
    }
    
    
    @objc func willResignActive() {
        print("💡 Application will resign active. Disconnecting socket.")
        socket?.disconnect()
    }
    
    @objc func didBecomeActive() {
        print("💡 Application did become active. Connecting socket.")
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

