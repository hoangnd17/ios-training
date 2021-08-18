//
//  ViewController.swift
//  lesson13
//
//  Created by Đại Nguyễn  on 8/17/21.
//

import UIKit

class Less13ViewController: UIViewController {

    @IBOutlet weak var employTb: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listEmployee: [Employee] = [Employee]()
    var listSearch: [Employee] = [Employee]()

    var checkSearch = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        employTb.delegate = self
        employTb.dataSource = self
        
        employTb.register(UINib(nibName: "EmployTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployTableViewCell")
        
        searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        listEmployee = Employee.getAllEmployee()
    }
    @IBAction func insertData(_ sender: Any) {
        let employee = Employee.insertNewEmployee(id: 1, name: "Đại", fsu: "Hello")
        
        let employee1 = Employee.insertNewEmployee(id: 3, name: "Chibi", fsu: "Hehe")
        let employee2 = Employee.insertNewEmployee(id: 2, name: "Love", fsu: "Ok")
        
        var certificates = Set<Certificate>()
        if let certi1 = Certificate.insertNewCertificate(id: 1, name: "C++") {
            certi1.isOwn = employee
            certificates.insert(certi1)
        }
        if let certi2 = Certificate.insertNewCertificate(id: 2, name: "Swift") {
            certi2.isOwn = employee
            certificates.insert(certi2)
        }
        
        if let certi3 = Certificate.insertNewCertificate(id: 3, name: "Chibi") {
            certi3.isOwn = employee
            certificates.insert(certi3)
        }
        
        employee?.addToHas(certificates as NSSet)
        
        listEmployee = Employee.getAllEmployee()
        employTb.reloadData()
    }
    
    
    @IBAction func fetchData(_ sender: Any) {
        let certi = Certificate.getAllCerti()
        if certi.count == 0 {
            print("Found no certi")
            return
        }
        for i in certi {
            print("Name: \(i.name ?? "")")
        }
        
        view.reloadInputViews()
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        Certificate.deleteAllCerti()
        Employee.deleteAllEmployee()
        
        listEmployee = Employee.getAllEmployee()
        
        checkSearch = 0
        employTb.reloadData()
    }
}


extension Less13ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkSearch == 1 {
            return listSearch.count
        }
        return listEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: Employee?
        if checkSearch == 1 {
            model = listSearch[indexPath.row]
        }
        model = listEmployee[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployTableViewCell", for: indexPath) as! EmployTableViewCell
        cell.id.text = String(model?.id ?? 0)
        cell.name.text = model?.name
        cell.fsu.text = model?.fsu
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: Employee?
        if checkSearch == 1 {
            model = listSearch[indexPath.row]
        }
        model = listEmployee[indexPath.row]

        let count = model?.getAllCertiByEm()
        print(count?.count)
    }
}


extension Less13ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        checkSearch = 1
        listSearch.removeAll()
        if (searchBar.text == "") {
            checkSearch = 0
            listSearch.removeAll()
        } else {
            listSearch = Employee.filterEmployeeByName(name: searchText)
        }
        print(listSearch.count)
        
        employTb.reloadData()
        view.reloadInputViews()

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        employTb.reloadData()
        view.reloadInputViews()
    }
}
