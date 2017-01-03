	//
//  FruitTableViewController.swift
//  shoptest5
//
//  Created by NguyenHai on 11/30/16.
//  Copyright © 2016 NguyenHai. All rights reserved.
//

import UIKit

class BranchProducts: UITableViewController {
 
    var receiveString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let entry = places2[indexPath.row]
        cell.textLabel?.text = entry.Model
        if let checkedUrl = URL(string: entry.imageLink) {
            cell.imageView?.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl, imageView: cell.imageView!)
        }
        //cell.imageView?.image = UIImage(named: object["image"]!)


        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return receiveString
    }
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row) at session number \(indexPath.section).")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        // Get the new view controller using segue.destinationViewController.
        //        // Pass the selected object to the new view controller.
        if segue.identifier == "show2" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let nextViewController = segue.destination as? TableViewControllerForCell{
                    //
                    nextViewController.receiveString2 =  places2[indexPath.row].Model
                    nextViewController.navigationItem.leftItemsSupplementBackButton = true
                    
                }
            }
        }
    }
    class Entry {
        let Model : String
        let imageLink : String
        
        init(Model : String, imageLink : String) {
            self.Model = Model
            self.imageLink = imageLink
        }
    }
    var places2 = [Entry]()
    func loadMysql()  {
        print("Name=\(receiveString)")
        var url = URLRequest(url: URL(string: "http://oslophone.com/server/BranchProducts.php")!)
        url.httpMethod = "POST"
        let postString = "Name=\(receiveString)"
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
                                self.places2.append(Entry(Model: key["Model"] as! String, imageLink: key["imageLink"] as! String))
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
