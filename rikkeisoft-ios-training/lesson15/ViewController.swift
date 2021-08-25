//
//  ViewController.swift
//  lesson15
//
//  Created by Đại Nguyễn  on 8/18/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .default, attributes: .concurrent)
        concurrentQueue.async {
            for _ in 1...3 {
                print("concurrentQueue 1")
            }
        }

        concurrentQueue.async {
            for _ in 1...3 {
                print("concurrentQueue 2")
            }
        }

        let serialQueue = DispatchQueue(label: "serialQueue", qos: .default, attributes: .concurrent)
        serialQueue.async {
            for _ in 1...3 {
                print("serialQueue 1")
            }
        }

        serialQueue.async {
            for _ in 1...3 {
                print("serialQueue 2")
            }
        }

    }


}

