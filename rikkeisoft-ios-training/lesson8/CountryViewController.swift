//
//  CountryViewController.swift
//  lesson8
//
//  Created by Đại Nguyễn  on 8/12/21.
//

import UIKit

struct CountryModel {
    let country: String
    let capital: String
    let popu: String
}

class CountryViewController: UIViewController {
    
    @IBOutlet weak var countryTb: UITableView!
    
    var listData:[CountryModel] = [CountryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        countryTb.delegate = self
        countryTb.dataSource = self
        
        countryTb.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryTableViewCell")
        
        if let country = getPlist(withName: "Country") {
            for i in country {
                listData.append(CountryModel(country: i["Country"]!, capital: i["Capital"]!, popu: i["Population"]!))
            }
        }
        
    }
    
    func getPlist(withName name: String) ->  [[String: String]]?
    {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else {
            return nil
        }
        return plist
    }

}


extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        cell.country.text = model.country
        cell.capital.text = model.capital
        cell.population.text = model.popu
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}
