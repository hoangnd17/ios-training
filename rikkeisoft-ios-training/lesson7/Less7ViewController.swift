//
//  ViewController.swift
//  lesson7
//
//  Created by Đại Nguyễn  on 8/11/21.
//

import UIKit

class Less7ViewController: UIViewController {

    @IBOutlet weak var viewHello: UIView!
    
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewHello.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideView)))
    }
    
    @objc func hideView() {
        img.isHidden = !img.isHidden
    }
}

