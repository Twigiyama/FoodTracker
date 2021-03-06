//
//  DataController.swift
//  FoodTracker
//
//  Created by Asitha Rodrigo on 07/06/2015.
//  Copyright (c) 2015 Twig. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let kUSDAItemCompleted = "USDAItemInstanceComplete"

class DataController {
    
    class func jsonAsUSDAIdAndNameSearchResults (json: NSDictionary) -> [(name: String, idValue: String)]{
        
        var usdaItemsSearchResults: [(name: String, idValue: String)] = []
        var searchResult: (name: String, idValue: String)
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as! [AnyObject]
            for itemDictionary in results {
                if itemDictionary["_id"] != nil {
                    if itemDictionary["fields"] != nil {
                            let fieldsDictionary = itemDictionary["fields"] as! NSDictionary
                        if fieldsDictionary["item_name"] != nil {
                            let idValue:String = itemDictionary["_id"]! as! String
                            let name:String = fieldsDictionary["item_name"]! as! String
                            searchResult = (name: name, idValue: idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                    }
                }
            }
        }
        return usdaItemsSearchResults
    }
    
    func saveUSDAItemForID(idValue: String, json: NSDictionary) {
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as! [AnyObject]
            for itemDictionary in results {
                if itemDictionary["_id"] != nil &&
                    itemDictionary["_id"] as! String == idValue {
                        
                        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                        var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                        let itemDictionaryId = itemDictionary["_id"] as! String
                        let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                        requestForUSDAItem.predicate = predicate
                        
                        var error: NSError?
                        
                        var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
                        
                        if items?.count != 0 {
                            // Item already saved so we don't want to save again.
                            println("This item was already saved")
                            let usdaItem = items?[0] as! USDAItem
                            NSNotificationCenter.defaultCenter().postNotificationName(kUSDAItemCompleted, object: usdaItem)
                            return
                        }
                        
                        else {
                            println("Lets save this to CoreData")
                            let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
                            let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                            usdaItem.idValue = itemDictionary["_id"]! as! String
                            
                            usdaItem.dateAdded = NSDate()
                            if itemDictionary["fields"] != nil {
                                let fieldsDictionary = itemDictionary["fields"]! as! NSDictionary
                                if fieldsDictionary["item_name"] != nil {
                                    usdaItem.name = fieldsDictionary["item_name"]! as! String
                                }
                                if fieldsDictionary["usda_fields"] != nil {
                                    let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as! NSDictionary
                                    
                                    //calcium
                                    if usdaFieldsDictionary["CA"] != nil {
                                        let calciumDictionary = usdaFieldsDictionary["CA"]! as! NSDictionary
                                        if calciumDictionary["value"] != nil {
                                            let calciumValue: AnyObject = calciumDictionary["value"]!
                                            usdaItem.calcium = "\(calciumValue)"
                                        }
                                        
                                    }
                                    else {
                                        usdaItem.calcium = "0"
                                    }
                                    
                                    //carbohdrate
                                    if usdaFieldsDictionary["CHOCDF"] != nil {
                                        let carbDictionary = usdaFieldsDictionary["CHOCDF"]! as! NSDictionary
                                        if carbDictionary["value"] != nil {
                                            let carbValue: AnyObject = carbDictionary["value"]!
                                            usdaItem.carbohydrate = "\(carbValue)"
                                        }
                                     
                                    }
                                    else {
                                        usdaItem.carbohydrate = "0"
                                    }
                                    
                                    //fat
                                    if usdaFieldsDictionary["FAT"] != nil {
                                        let fatDictionary = usdaFieldsDictionary["FAT"]! as! NSDictionary
                                        if fatDictionary["value"] != nil {
                                            let fatValue: AnyObject = fatDictionary["value"]!
                                            usdaItem.fatTotal = "\(fatValue)"
                                        }
                                        
                                    }
                                    else {
                                        usdaItem.fatTotal = "0"
                                    }
                                    
                                    //cholesterol
                                    if let cholDictionary:NSDictionary = usdaFieldsDictionary["CHOLE"] as? NSDictionary {
                                        if let cholValue:AnyObject = cholDictionary["value"] {
                                            usdaItem.cholesterol = "\(cholValue)"
                                        }
                                    }
                                    else {
                                        usdaItem.cholesterol = "0"
                                    }
                                    
                                    //protein
                                    if let protDictionary:NSDictionary = usdaFieldsDictionary["PROCNT"] as? NSDictionary {
                                        if let protValue: AnyObject = protDictionary["value"] {
                                            usdaItem.protein = "\(protValue)"
                                        }
                                    }
                                    else {
                                        usdaItem.protein = "0"
                                    }
                                    
                                    //sugar
                                    if let sugarDictionary:NSDictionary = usdaFieldsDictionary["SUGAR"] as? NSDictionary {
                                        if let sugarValue: AnyObject = sugarDictionary["value"] {
                                            usdaItem.sugar = "\(sugarValue)"
                                        }
                                    }
                                    else {
                                        usdaItem.sugar = "0"
                                    }
                                    
                                    //Vitamin C
                                    if let vitcDictionary:NSDictionary = usdaFieldsDictionary["VITC"] as? NSDictionary {
                                        if let vitcValue: AnyObject = vitcDictionary["value"] {
                                            usdaItem.vitaminC = "\(vitcValue)"
                                        }
                                    }
                                    else {
                                        usdaItem.vitaminC = "0"
                                    }
                                    
                                    //Energy
                                    if let energyDictionary:NSDictionary = usdaFieldsDictionary["ENERC_KCAL"] as? NSDictionary {
                                        if let energyValue: AnyObject = energyDictionary["value"] {
                                            usdaItem.energy = "\(energyValue)"
                                        }
                                    }
                                    
                                    else {
                                        usdaItem.energy = "0"
                                    }
                                    
                                    (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                                    NSNotificationCenter.defaultCenter().postNotificationName(kUSDAItemCompleted, object: usdaItem)
                                    
                                    
                                }
                                
                            }
                            
                        }
                        

                }
            }
        }
    }
}