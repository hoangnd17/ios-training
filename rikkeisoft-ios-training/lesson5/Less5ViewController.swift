//
//  ViewController.swift
//  lesson5
//
//  Created by Đại Nguyễn  on 8/10/21.
//

import UIKit

class Less5ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


        title = "IBook"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(goHome)),
            UIBarButtonItem(image: UIImage(systemName: "house.circle"), style: .done, target: self, action: #selector(goHome))
        ]
    }
    
    @objc private func goHome() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as! UIViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.title = "Home"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

