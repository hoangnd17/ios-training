//
//  NextViewController.swift
//  telling_bot
//
//  Created by Đại Nguyễn  on 9/14/21.
//

import UIKit

class NextViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let items = ["one", "two", "three", "four", "five"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set visual state
        if self.navigationController?.viewControllers[1] is NextViewController {
            if let vc = self.navigationController?.viewControllers.first as? TellingViewController {
                vc.setVisualState(state: ["screen": "next", "items": self.items])
            }
        }
    }
    
    func highlightItem(item: String) {
        
        guard let itemIndex = self.items.firstIndex(of: item),
              let cell = self.tableView.cellForRow(at: IndexPath(row: itemIndex, section: 0))
        else {
            return
        }
        
        cell.setHighlighted(true, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            cell.setHighlighted(false, animated: true)
        }
    }
}

extension NextViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as UITableViewCell
        cell.textLabel?.text = item
        
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        
        if let vc = self.navigationController?.viewControllers.first as? TellingViewController { 
            vc.selectItem(item: item)
        }
    }
}
