//
//  ViewController.swift
//  lesson3
//
//  Created by Đại Nguyễn  on 8/9/21.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var clickBtn: UIButton!
    // less 3
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeButton(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SecondViewController") as! UIViewController
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}

