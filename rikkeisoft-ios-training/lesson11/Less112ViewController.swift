//
//  Less112ViewController.swift
//  lesson11
//
//  Created by Đại Nguyễn  on 8/16/21.
//

import UIKit

struct One {
    var name: String = ""
    var des: String = ""
}

class Less112ViewController: UIViewController {
    
    @IBOutlet weak var tb: UITableView!
    
    var res: [One] = [One]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        res.append(contentsOf: [
            One(name: "Hello world", des: "This is many things for you to learn\nYou need to do some things to play\nLet do it"),
            One(name: "C++", des: "This is many things for you to learn\nYou need to do some things to play\nLet do it This is many things for you to learn\nYou need to do some things to\nplay Let do it")
        ])
        tb.delegate = self
        tb.dataSource = self
        
        tb.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
    }
    
}

extension Less112ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.name.text = res[indexPath.row].name
        cell.des.text = res[indexPath.row].des
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
