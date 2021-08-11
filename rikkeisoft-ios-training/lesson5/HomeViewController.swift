//
//  HomeViewController.swift
//  lesson5
//
//  Created by Đại Nguyễn  on 8/11/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bookTb: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(systemName: "arrowshape.turn.up.backward")
        self.navigationController?.navigationBar.backIndicatorImage = img
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = img
        navigationItem.backButtonTitle = " "
        
        bookTb.delegate = self
        bookTb.dataSource = self
        
        bookTb.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: "BookTableViewCell")
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as! UIViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.title = "Book Detail"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
