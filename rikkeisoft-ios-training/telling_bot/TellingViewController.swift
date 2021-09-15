//
//  ViewController.swift
//  telling_bot
//
//  Created by Đại Nguyễn  on 9/13/21.
//

import UIKit
import AlanSDK

class TellingViewController: UIViewController {
    
    private var button: AlanButton!
    
    private var text: AlanText!
    
    private var greetingIsPlayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAlan()
        
        self.setupAlanEventHandler()
        
        self.setupAlanStateHandler()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setVisualState(state: ["screen": "home"])
        
    }
    
    private func setupAlan() {
        // Define the project key
        let config = AlanConfig(key: "6562e1fcf53c9a2d10187a219ed379242e956eca572e1d8b807a3e2338fdd0dc/stage")
        
        //  Init  button, text
        self.button = AlanButton(config: config)
        self.text = AlanText(frame: CGRect.zero)
        
        // add subview
        self.view.addSubview(self.button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.text)
        self.text.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout
        let views = ["button" : self.button!, "text" : self.text!]
        let verticalButton = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0@299)-[button(64)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        let verticalText = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0@299)-[text(64)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        let horizontalButton = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0@299)-[button(64)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        let horizontalText = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[text]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        self.view.addConstraints(verticalButton + verticalText + horizontalButton + horizontalText)
    }
    
    private func goForward() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NextViewController") as! UIViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.title = "Next"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func next(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NextViewController") as! UIViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.title = "Next"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setVisualState(state: [AnyHashable: Any]) {
        self.button.setVisualState(state)
    }
    
    private func setupAlanEventHandler() {
        // Add an observer to get events
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleEvent(_:)), name:NSNotification.Name(rawValue: "kAlanSDKEventNotification"), object:nil)
    }
    
    @objc func handleEvent(_ notification: Notification) {
        
        // Get the user info object with JSON
        guard let userInfo = notification.userInfo,
              let jsonString = userInfo["jsonString"] as? String,
              let jsonData = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
              
              let commandObject = jsonObject["data"] as? [String: Any],
              // Get the command name string
              let commandString = commandObject["command"] as? String
        else {
            return
        }
        
        // navigate
        if commandString == "navigation" {
            // Get the route name string
            guard let routeString = commandObject["route"] as? String else {
                return
            }
            if routeString == "next" {
                DispatchQueue.main.async {
                    self.goForward()
                }
            }
            
            else if routeString == "back" {
                DispatchQueue.main.async {
                    self.goBack()
                }
            }
        }
        // highlight
        else if commandString == "highlight" {
            
            guard let itemString = commandObject["item"] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                self.highlightItem(item: itemString)
            }
        }
    }
    
    private func highlightItem(item: String) {
        if let secondVC = self.navigationController?.viewControllers.last as? NextViewController {
            secondVC.highlightItem(item: item)
        }
    }
    
    func selectItem(item: String) {
        if !self.button.isActive() {
            self.button.activate()
        }
    
        // send data to server
        self.button.callProjectApi("selectItem", withData: ["item": item]) { (_, _) in
            print("callProjectApi was called")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.button.deactivate()
            }
        }
    }
    
    private func setupAlanStateHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleState(_:)), name:NSNotification.Name(rawValue: "kAlanSDKAlanButtonStateNotification"), object:nil)
    }
    
    @objc func handleState(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              /// Get the number value for the Alan button state
              let stateValue = userInfo["onButtonState"] as? NSNumber,
              /// Get the Alan button state
              let buttonState = AlanSDKButtonState.init(rawValue: stateValue.intValue)
        else {
            return
        }
        
        switch buttonState {
        case .online:
            
            if !self.greetingIsPlayed {
                self.greetingIsPlayed = true
                
                DispatchQueue.main.async {
                    self.greeting()
                }
            }
            break
        case .offline:
            break
        case .noPermission:
            break
        case .connecting:
            break
        case .listen:
            break
        case .process:
            break
        case .reply:
            break
        default:
            break
        }
    }
    
    private func greeting() {
        // Check if the Alan button is active
        if !self.button.isActive() {
            self.button.activate()
        }
        
        // Play the greeting text
        self.button.playText("Welcome to the my Swift bot")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.button.deactivate()
        }
    }
}

