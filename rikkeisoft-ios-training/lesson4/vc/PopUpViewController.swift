//
//  PopUpViewController.swift
//  lesson4
//
//  Created by Đại Nguyễn  on 8/10/21.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var codeTextt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func register(_ sender: Any) {
        if codeTextt.text == "1234" {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as! UIViewController
            
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }
}
