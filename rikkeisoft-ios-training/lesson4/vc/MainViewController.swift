//
//  MainViewController.swift
//  lesson4
//
//  Created by Đại Nguyễn  on 8/10/21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func toHome(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UIViewController
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @IBAction func toSetting(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Setting", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingViewController") as! UIViewController
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}
