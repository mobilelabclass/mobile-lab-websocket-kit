//
//  ViewController.swift
//  mobile-lab-websockets
//
//  Created by Sebastian Buys on 2/20/18.
//  Copyright © 2018 Sebastian Buys. All rights reserved.
//

import UIKit
import Starscream    // Socket library


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

let playerIdKey = "PLAYER_ID";


class ViewController: UIViewController, WebSocketDelegate, UITextFieldDelegate {

    // User UserDefaults for simple storage.
    var defaults: UserDefaults!
    
    // Object for managing the web socket.
    var socket: WebSocket?
    

    // Button actions connected from storyboard.
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
    
    // Input text field.
    @IBOutlet weak var playerIdTextField: UITextField!
    
    // Profile image view.
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // URL of web server.
        let urlString = "ws://websockets.mobilelabclass.com:1024/"
    
        // Create a WebSocket.
        socket = WebSocket(url: URL(string: urlString)!)
        
        // Assign WebSocket delegate to self
        socket?.delegate = self
        
        // Connect.
        socket?.connect()
        
        // Assigning notifications to when the app becomes active or inactive.
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    
        // Set delegate for text field to conform to protocol.
        playerIdTextField.delegate = self


        // Init user defaults object for storage.
        defaults = UserDefaults.standard

        // Get USER DEFAULTS data. ////////////
        // If there is a player id saved, set text field.
        if let playerId = defaults.string(forKey: playerIdKey) {
            playerIdTextField.text = playerId
        }
        //////////////////////////////////////
    }


    // Textfield delegate method.
    // Update player id in user defaults when "Done" is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)

        // Check text field is not empty, otherwise save to user defaults.
        if (textField.text?.isEmpty)! {
            presentAlertMessage(message: "Enter Valid Player Id")
            textField.text = defaults.string(forKey: playerIdKey)!
        } else {

            // Set USER DEFAULTS data. ////////////
            defaults.set(textField.text!, forKey: playerIdKey)
            presentAlertMessage(message: "Player Id Saved!")
            //////////////////////////////////////
        }
        
        return false
    }
    

    // Helper method for displaying a alert view.
    func presentAlertMessage(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

    func sendDirectionMessage(_ code: DirectionCode) {
        // Get the raw string value from the DirectionCode enum
        // that we created at the top of this program.
        sendMessage(code.rawValue)
    }

    func sendMessage(_ message: String) {
        // Check if there is a valid player id set.
        guard let playerId = defaults.string(forKey: playerIdKey) else {
            presentAlertMessage(message: "Enter Player Id")
            return
        }

        // Construct server message and write to socket. ///////////
        let message = "\(playerId), \(message)"
        socket?.write(string: message) {
            // This is a completion block.
            // We can write custom code here that will run once the message is sent.
            print("⬆️ sent message to server: ", message)
        }
        ///////////////////////////////////////////////////////////
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

