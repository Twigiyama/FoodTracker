//
//  ViewController.swift
//  FoodTracker
//
//  Created by Asitha Rodrigo on 24/05/2015.
//  Copyright (c) 2015 Twig. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    let kAppID = "7941af57"
    let kAppKey = "29cd4f53f2c9a0e182d92d110b0ebd60"
    
    var searchController: UISearchController!
    var suggestedSearchFoods:[String] = []
    var filteredSuggestedSearchFoods:[String] = []
    
    var apiSearchForFoods: [(name:String, idValue: String)] = []
    
    var favoritedUSDAItems:[USDAItem] = []
    
    var filteredFavoritedUSDAItems: [USDAItem] = []
    
    var scopeButtonTitles = ["Recommended", "Seach Results", "Saved"]
    
    var jsonReponse: NSDictionary!
    
    var dataController = DataController()
    

    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailVCSegue" {
            if sender != nil {
                let detailVC = segue.destinationViewController as! DetailViewController
                detailVC.usdaItem = sender as? USDAItem
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark - UITableView DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        var foodName: String
        
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if selectedScopeButtonIndex == 0 {
            if self.searchController.active {
                foodName = filteredSuggestedSearchFoods[indexPath.row]
            }
            else {
                foodName = suggestedSearchFoods[indexPath.row]
            }
            
        } else if selectedScopeButtonIndex == 1 {
            
            foodName = apiSearchForFoods[indexPath.row].name
            
        } else {
            
            if self.searchController.active {
                foodName = self.filteredFavoritedUSDAItems[indexPath.row].name
            }
            else {
                foodName = self.favoritedUSDAItems[indexPath.row].name
            }
            
        }
        

        
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }
    
    //Mark - UTTableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if selectedScopeButtonIndex == 0 {
            
            var searchFoodName: String
            
            if self.searchController.active {
                
                searchFoodName = filteredSuggestedSearchFoods[indexPath.row]
                
            }
            
            else {
                
                searchFoodName = suggestedSearchFoods[indexPath.row]
            }
            
            self.searchController.searchBar.selectedScopeButtonIndex = 1
            makeRequest(searchFoodName)
            
            
        }
        else if selectedScopeButtonIndex == 1 {
            self.performSegueWithIdentifier("toDetailVCSegue", sender: nil)
            let idValue = apiSearchForFoods[indexPath.row].idValue
            dataController.saveUSDAItemForID(idValue, json: jsonReponse)
 
            
        }
        
        else  if selectedScopeButtonIndex == 2 {
            if self.searchController.active {
                let usdaItem = filteredFavoritedUSDAItems[indexPath.row]
                self.performSegueWithIdentifier("toDetailVCSegue", sender: usdaItem)
            }
            
            else {
                let usdaItem = favoritedUSDAItems[indexPath.row]
                self.performSegueWithIdentifier("toDetailVCSegue", sender: usdaItem)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if selectedScopeButtonIndex == 0 {
            if self.searchController.active {
                return self.filteredSuggestedSearchFoods.count
            } else {
                return self.suggestedSearchFoods.count
            }
        } else if selectedScopeButtonIndex == 1 {
            return self.apiSearchForFoods.count
        }
        else {
            if self.searchController.active {
                return self.filteredFavoritedUSDAItems.count
            }
            
            else {
              return self.favoritedUSDAItems.count
            }
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
        
        if scope == 0 {
            
            
            self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food: String) -> Bool in
                var foodMatch = food.rangeOfString(searchText)
                return foodMatch != nil
            })
            
        }
            
        else if scope == 2 {
            self.filteredFavoritedUSDAItems = self.favoritedUSDAItems.filter({ (foodItem: USDAItem) -> Bool in
                var stringMatch = foodItem.name.rangeOfString(searchText)
                return stringMatch != nil
            })
        }
        
        else {
            
        }

    }
    
    // Mark - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchController.searchBar.selectedScopeButtonIndex = 1
        makeRequest(searchBar.text)
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.tableView.reloadData()
        
        if selectedScope == 2 {
            requestFavoritedUSDAItems()
        }
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
                    self.jsonReponse = jsonDictionary!
                    self.apiSearchForFoods = DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                } else {
                    let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error Could not Parse JSON \(errorString)")
                }
            }
        })
        task.resume()
    }
    
    // Set up CoreData
    func requestFavoritedUSDAItems() {
        let fetchRequest = NSFetchRequest(entityName: "USDAItem")
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        self.favoritedUSDAItems = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [USDAItem]
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //Mark - NSNotificationCenter
    
    func usdaItemDidComplete(notification: NSNotification) {
        
        println("usdaItemDidComplete in ViewController")
        requestFavoritedUSDAItems()
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if selectedScopeButtonIndex == 2 {
            self.tableView.reloadData()
        }
    }
}

