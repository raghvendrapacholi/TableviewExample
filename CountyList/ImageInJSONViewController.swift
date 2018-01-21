//
//  ImageInJSONViewController.swift
//  CountyList
//
//  Created by Raghvendra on 21/01/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

class ImageInJSONViewController : UIViewController,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var dobArray = [String]()
    var imgURLArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
     DownlaodJSONData()
    }
    
    func DownlaodJSONData() {
        let url = "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors"
//        var request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error?.localizedDescription)
            }
            else{
                do{
                    let responseData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    if let actorArray = responseData.value(forKey: "actors") as? NSArray{
                        for actor in actorArray{
                            if let actorDict = actor as? NSDictionary{
                                if let name = actorDict.value(forKey: "name"){
                                    self.nameArray.append(name as! String)
                                  }
                                if let dob = actorDict.value(forKey: "dob"){
                                    self.dobArray.append(dob as! String)
                                }
                                if let img = actorDict.value(forKey: "image"){
                                    self.imgURLArray.append(img as! String)
                                }
                                print(self.nameArray)
                                print(self.dobArray)
                                print(self.imgURLArray)
                                
                                }
                            }
                        
                        
                        }
                }catch{
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                }
            
            })
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.dobLabel.text = dobArray[indexPath.row]
        
        let imgURL = NSURL(string: imgURLArray[indexPath.row])
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.imgView.image = UIImage(data: data as! Data)
        }
        
        return cell
    }
}
