//
//  APIController.swift
//  SwiftTryout
//
//  Created by Leone Keijzer on 16/03/15.
//  Copyright (c) 2015 LenCode. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class APIController {
    var delegate:APIControllerProtocol?
    
    init() {
        
    }
    
    func searchItunesFor(searchTerm: String) {
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                println("download completed")
                if error != nil {
                    println("error occured >> \(error.localizedDescription)")
                }
                
                var err: NSError?
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if err != nil {
                    println("failed to decode JSON. \(err!.localizedDescription)")
                }
                
                let results:NSArray = jsonResult["results"] as NSArray
                self.delegate?.didReceiveAPIResults(jsonResult)
            })
            
            task.resume()
        }
    }
}