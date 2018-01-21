//
//  ViewController.swift
//  CountyList
//
//  Created by Raghvendra on 21/01/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate {
    
    var fectchedCountry = [Country]()

    @IBOutlet weak var countryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryTableView.dataSource = self
        ParseData()
        searchBar()
        // Do any additional setup after loading the view, typically from a nib.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fectchedCountry.count
    }
    
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = fectchedCountry[indexPath.row].countryName
        cell?.detailTextLabel?.text = fectchedCountry[indexPath.row].capitalName
        return cell!
    }
    
    func searchBar()
    {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Country", "Capital"]
        self.countryTableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            ParseData()
        }else{
            if searchBar.selectedScopeButtonIndex == 0 {
                fectchedCountry = fectchedCountry.filter({ (country) -> Bool in
                    return country.countryName.lowercased().contains(searchText.lowercased())
                })
            }
            else{
                fectchedCountry = fectchedCountry.filter({ (country) -> Bool in
                    return country.capitalName.lowercased().contains(searchText.lowercased())
                })
            }
        }
        self.countryTableView.reloadData()
    }
    

    func ParseData(){
        
        fectchedCountry = []
        let url = "https://restcountries.eu/rest/v1/all"
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with : request){ (data, response , error) in
            
            if error != nil{
                print(error?.localizedDescription ?? "Error from API call")
        }
            else{
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    
                   
                    for eachFetchedCountry in fetchedData{
                        
                        let eachCountry  = eachFetchedCountry as! [String: Any]
                        let countryName = eachCountry["name"] as! String
                        let capitalName = eachCountry["capital"] as! String
                        self.fectchedCountry.append(Country(countryName: countryName, capitalName: capitalName))
                    }
                    DispatchQueue.main.async {
                        self.countryTableView.reloadData()
                    }
                    
                }catch{
                    print("Error in parsing JSON")
                }
                
            }

        }
        task.resume()
}
}

class Country{
    var countryName : String
    var capitalName : String
    
    init(countryName : String, capitalName : String) {
        self.countryName = countryName
        self.capitalName = capitalName
    }
}

