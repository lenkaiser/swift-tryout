//
//  TableViewController.swift
//  SwiftTryout
//
//  Created by Leone Keijzer on 16/03/15.
//  Copyright (c) 2015 LenCode. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, APIControllerProtocol {
    var api = APIController()
    var tableData = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //Get all Foize products
        api.delegate = self
        api.searchItunesFor("Foize")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    
    let kCellIdentifier: String = "SearchResultCell"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        let rowData:NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        //Set text labels
        cell.textLabel?.text = rowData["trackName"] as? NSString
        let formattedPrice:NSString = rowData["formattedPrice"] as NSString
        cell.detailTextLabel?.text = formattedPrice
    
        //Get image
        let urlString:NSString = rowData["artworkUrl100"] as NSString
        let imgURL:NSURL? = NSURL(string: urlString)
        let imgData = NSData(contentsOfURL: imgURL!)
        cell.imageView?.image = UIImage(data: imgData!)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var rowData:NSDictionary = self.tableData[indexPath.row] as NSDictionary
        var name:String = rowData["trackName"] as String
        var formattedPrice:String = rowData["formattedPrice"] as String
        
        var alert:UIAlertView = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("Ok")
        alert.show()
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - APIControllerProtocol
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr:NSArray = results["results"] as NSArray
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableData = resultsArr
            self.tableView.reloadData()
        })
    }

}
