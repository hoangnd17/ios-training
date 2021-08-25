//
//  ViewController.swift
//  lesson14
//
//  Created by Đại Nguyễn  on 8/18/21.
//

import UIKit

class Less14ViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    
    var doubleTap : Bool! = false

    let kRotationAnimationKey = "rotationAnimation"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func rotate(_ sender: Any) {
        if (doubleTap) {
            logo.rotate()
            doubleTap = false
        } else {
            stopRotatingView(view: self.logo)
            doubleTap = true
        }
    }
    
    
    func stopRotatingView(view: UIView) {
        if view.layer.animation(forKey: kRotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    }
    
}

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
}
