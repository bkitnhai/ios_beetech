//
//  TableViewControllerForCell.swift
//  shoptest5
//
//  Created by NguyenHai on 12/1/16.
//  Copyright © 2016 NguyenHai. All rights reserved.
//

import UIKit

class TableViewControllerForCell: UITableViewController {
    var receiveString2: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello \(receiveString2)")
        loadMysql()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places2.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellTableViewCell
        let entry = places2[indexPath.row]
        if let checkedUrl = URL(string: entry.imageLink) {
            cell.CellImage.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl, imageView: cell.CellImage)
        }
        cell.headingLabel.text = entry.name
        cell.size.text = entry.size
        cell.color.text = entry.color
        cell.condition.text = entry.condition
        cell.des.text = entry.des
        // Configure the cell...

        return cell
    }
    
    class Entry {
        let name : String
        let color : String
        let size : String
        let model : String
        let price : String
        let condition : String
        let des : String
        let imageLink : String
        init(name : String, color : String, size : String, model : String, price : String, condition : String, des : String, imageLink : String) {
            self.name = name
            self.color = color
            self.size = size
            self.model = model
            self.price = price
            self.condition = condition
            self.des = des
            self.imageLink = imageLink
        }
    }
    var places2 = [Entry]()
    func loadMysql()  {
        print("Model=\(receiveString2)")
        var url = URLRequest(url: URL(string: "http://oslophone.com/server/service.php")!)
        url.httpMethod = "POST"
        let postString = "Model=\(receiveString2)"
       // let postString = "Name=iPhone"
        url.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]] {
                            for key in jsonResult {
                                self.places2.append(
                                    Entry(name: key["Name"] as! String, color: key["Color"] as! String, size: key["Size"] as! String, model: key["Model"] as! String, price: key["Price"] as! String, condition: key["Condition"] as! String, des: key["Description"] as! String, imageLink: key["imageLink"] as! String)
                                )
                            }
                            
                            
                        }
                        DispatchQueue.main.async(execute: {self.do_table_refresh()})
                    } catch {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()
        
    }
    func do_table_refresh()
    {
       self.tableView.reloadData()
        
    }
    //Asynchronously:
    //Create a method with a completion handler to get the image data from your url
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    //Create a method to download the image (start the task)
    func downloadImage(url: URL, imageView : UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
             DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
    }

}
