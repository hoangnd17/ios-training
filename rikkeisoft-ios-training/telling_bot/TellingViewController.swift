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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAlan()
        
        
        self.setupAlanEventHandler()
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
    
    @IBAction func next(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NextViewController") as! UIViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.title = "Next"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func setupAlanEventHandler() {
        /// Add an observer to get events
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
        
        // Get the command name string
        if commandString == "navigation" {
            // Get the route name string
            guard let routeString = commandObject["route"] as? String else {
                return
            }
            // Forward command
            if routeString == "next" {
                DispatchQueue.main.async {
                    self.goForward()
                }
            }
            
            // Back command
            else if routeString == "back" {
                DispatchQueue.main.async {
                    self.goBack()
                }
            }
        }
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
}

