//
//  ViewController.swift
//  lesson8
//
//  Created by Đại Nguyễn  on 8/11/21.
//

import UIKit

class OneViewController: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var fb: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var avatar: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Save info"
    }
    
    @IBAction func photo(_ sender: Any) {
        presentPhotoPicker()
    }
    @IBAction func camera(_ sender: Any) {
        alertCameraError()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let firstName = firstName.text,
              let lastName = lastName.text,
              let fb = fb.text,
              let phone = phone.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !fb.isEmpty,
              !phone.isEmpty
        else {
            alertUserLoginError()
            return
        }
        
        guard let age = age.text,
              !age.isEmpty,
              age.isStringAnInt() == true
        else {
            alertAgeError()
            return
        }
        
        guard let ava = avatar.image else {
            return
        }
        
        let imgData = ava.jpegData(compressionQuality: 1)
        
        UserDefaults.standard.set(imgData, forKey: "avatar")
        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
        UserDefaults.standard.set(age, forKey: "age")
        UserDefaults.standard.set(fb, forKey: "fb")
        UserDefaults.standard.set(phone, forKey: "phone")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TwoViewController") as! UIViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.title = "Info"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error", message: "Fill all data", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func alertAgeError() {
        let alert = UIAlertController(title: "Error", message: "Age must be a number", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func alertCameraError() {
        let alert = UIAlertController(title: "Error", message: "Nothing for you", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
}

extension OneViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.avatar.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension String
{
    func isStringAnInt() -> Bool {
        
        if let _ = Int(self) {
            return true
        }
        return false
    }
}
