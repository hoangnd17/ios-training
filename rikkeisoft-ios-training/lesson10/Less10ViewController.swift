//
//  ViewController.swift
//  lesson10
//
//  Created by Đại Nguyễn  on 8/14/21.
//

import UIKit

class Less10ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var artistTb: UITableView!
    
    var listSearch : [Artist] = [Artist]()

    var results: [Artist] = [Artist]()
    var elementName: String = String()
    var currentValue: Artist = Artist( area: Area())
    var targetElement: String = "artist"
    
    var checkSearch = 0
    let targetList = Set<String>([ "area", "life-span>", "alias-list>", "tag-list", "tag"])

    override func viewDidLoad() {
        super.viewDidLoad()

        artistTb.delegate = self
        artistTb.dataSource = self
        
        artistTb.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "ArtistTableViewCell")
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        parseXML()
    }
    func parseXML() {
        
        guard let url = URL(string: "http://musicbrainz.org/ws/2/artist?query=artist:key_word&limit=20")
        else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                print(self.results.count)
            }
        }
        task.resume()
    }
}

extension Less10ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkSearch == 0 {
            return results.count
        } else {
            return listSearch.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model = Artist(area: Area())
        if checkSearch == 1 {
            model = listSearch[indexPath.row]
        } else {
            model = results[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as! ArtistTableViewCell
        cell.name.text = model.name
        cell.Country.text = model.country
        cell.Ambi.text = model.disambiguation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension Less10ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        checkSearch = 1
        listSearch.removeAll()
        if (searchBar.text == "") {
            listSearch.removeAll()
        } else {
            for i in results {
                if i.name.contains(searchBar.text!) {
                    listSearch.append(i)
                }
            }
            
        }
        print(listSearch.count)
        
        artistTb.reloadData()
        view.reloadInputViews()

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        checkSearch = 0
        searchBar.text = ""
        artistTb.reloadData()
        view.reloadInputViews()
    }
}


extension Less10ViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "artist" {
            targetElement = "artist"
            if let id = attributeDict["id"] {
                currentValue.id = id
            }
            if let type = attributeDict["type"] {
                currentValue.type = type
            }
        }
        if self.targetList.contains(elementName) {
            targetElement = "non artist"
        }
        self.elementName = elementName

    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.elementName == "name" && self.targetElement == "artist" {
            currentValue.name = string
        }
        if self.elementName == "country" {
            currentValue.country = string
        }
        if self.elementName == "disambiguation" {
            currentValue.disambiguation = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "artist" {
            results.append(currentValue)
            currentValue = Artist(area: Area())
        }
    }
}

struct Artist {
    var id: String = ""
    var type: String = ""
    var name: String = ""
    var sort_name: String = ""
    var gender: String = ""
    var country: String = ""
    var disambiguation: String = ""
    var area: Area
}

struct Area {
    var id: String = ""
    var type: String = ""
    var name: String = ""
    var sort_name: String = ""
}

