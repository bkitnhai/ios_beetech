//
//  iphoneTableViewController.swift
//  shoptest5
//
//  Created by NguyenHai on 11/30/16.
//  Copyright © 2016 NguyenHai. All rights reserved.
//

import UIKit

class MainCategories: UITableViewController {

    var TableData:Array< String > = Array < String >()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMysql()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return TableData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = TableData[indexPath.row]
        
        return cell
    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        // Get the new view controller using segue.destinationViewController.
        //        // Pass the selected object to the new view controller.
        if segue.identifier == "show" {
          if let indexPath = self.tableView.indexPathForSelectedRow {
            if let nextViewController = segue.destination as? BranchProducts{
                //
                nextViewController.receiveString =  TableData[indexPath.row]
                nextViewController.navigationItem.leftItemsSupplementBackButton = true
                
            }
          }
        }
    }
    func loadMysql(){
        print("hello")
        let url = URL(string: "http://oslophone.com/server/CategoryParse.php")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]] {
                            
                            let responseMessage = jsonResult[0]["Name"] as? String
                            for key in jsonResult {
                                self.TableData.append(key["Name"] as! String)
                            }
                            
                            //print(responseMessage!)
                            
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

}
