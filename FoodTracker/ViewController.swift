//
//  ViewController.swift
//  FoodTracker
//
//  Created by Asitha Rodrigo on 24/05/2015.
//  Copyright (c) 2015 Twig. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    let kAppID = "7941af57"
    let kAppKey = "29cd4f53f2c9a0e182d92d110b0ebd60"
    
    var searchController: UISearchController!
    var suggestedSearchFoods:[String] = []
    var filteredSuggestedSearchFoods:[String] = []
    
    var scopeButtonTitles = ["Recommended", "Seach Results", "Saved"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44)
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
        
        self.searchController.searchBar.delegate = self
        
        self.definesPresentationContext = true
        
        self.suggestedSearchFoods = ["apple", "bagel", "bannana", "beer", "bread", "carrots", "cheddar cheese", "chicken breast", "chilli with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustart", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark - UITableView DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        var foodName: String
        
        if self.searchController.active {
            foodName = filteredSuggestedSearchFoods[indexPath.row]
        }
        else {
            foodName = suggestedSearchFoods[indexPath.row]
        }
        
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.active {
            return self.filteredSuggestedSearchFoods.count
        } else {
            return self.suggestedSearchFoods.count
        }
    }

    // Mark - UISearchResults Updating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchString = self.searchController.searchBar.text
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
        self.tableView.reloadData()
    
    }
    
    func filterContentForSearch (searchText: String, scope: Int) {
    
        self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food: String) -> Bool in
            var foodMatch = food.rangeOfString(searchText)
            return foodMatch != nil
        })
    }
    
    // Mark - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        makeRequest(searchBar.text)
    }
    
    func makeRequest (searchString: String) {

     //How to make an HTTP Get Request.
        
//        let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppID)&appKey=\(kAppKey)")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//            var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(stringData)
//            println(response)
//            println(error)
//        })
//        
//        task.resume()
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var params = [
            "appId" : kAppID,
            "appKey": kAppKey,
            "fields": ["item_name", "brand_name", "keywords", "usda_fields"],
            "limit": "50",
            "query": searchString,
            "filters": ["exists": ["usda_fields": true]]   ]
        var error: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
//            var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(stringData)
            var conversionErr: NSError?
            var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionErr) as? NSDictionary
            println(jsonDictionary)
            
            if conversionErr != nil {
                println(conversionErr!.localizedDescription)
                let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error in Parsing \(errorString)")
                
            } else {
                if jsonDictionary != nil {
                    
                } else {
                    let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error Could not Parse JSON \(errorString)")
                }
            }
        })
        task.resume()
    }
}

