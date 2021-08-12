//
//  SecondViewController.swift
//  lesson8
//
//  Created by Đại Nguyễn  on 8/11/21.
//

import UIKit

class TwoViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var fb: UILabel!
    
    
    @IBOutlet weak var age: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()


        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house.fill"), style: .done, target: self, action: #selector(goCountry))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let name = (UserDefaults.standard.value(forKey: "name")) as? String,
              let fb = (UserDefaults.standard.value(forKey: "fb")) as? String,
              let age = (UserDefaults.standard.value(forKey: "age")) as? String
        else {
            return
        }
        self.name.text = name
        self.fb.text = fb
        self.age.text = age
        
        if let imgData = (UserDefaults.standard.value(forKey: "avatar")) as? NSData
        {
            if let image = UIImage(data: imgData as Data)
            {
                self.avatar.image = image
                UserDefaults.standard.removeObject(forKey: "avatar")
            }
        }
    }
    
    
    @objc private func goCountry() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CountryViewController") as! UIViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.title = "Country"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
