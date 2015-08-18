//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Asitha Rodrigo on 25/05/2015.
//  Copyright (c) 2015 Twig. All rights reserved.
//

import UIKit
import HealthKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var usdaItem:USDAItem?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorisationForHealthStore()

        // Do any additional setup after loading the view.
        if usdaItem != nil {
            textView.attributedText = createAttributedString(usdaItem!)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func usdaItemDidComplete(notification: NSNotification) {
        println("usdaItemDidComplete in DetailViewController")
        usdaItem = notification.object as? USDAItem
        
        if self.isViewLoaded() && self.view.window != nil {
            textView.attributedText = createAttributedString(usdaItem!)
        }
    }

    @IBAction func eatItButtonPressed(sender: UIBarButtonItem) {
    }
    
    func createAttributedString(usdaItem: USDAItem) -> NSAttributedString {
        
        var itemAttributedString = NSMutableAttributedString()
        
        // Paragraph styles
        var centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = NSTextAlignment.Center
        centeredParagraphStyle.lineSpacing = 10.0
        
        var leftAlignedParagrahStyle = NSMutableParagraphStyle()
        leftAlignedParagrahStyle.alignment = NSTextAlignment.Left
        centeredParagraphStyle.lineSpacing = 20.0
        
        // Attributes dictionaries
        var titleAttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(22.0),
            NSParagraphStyleAttributeName: centeredParagraphStyle]
        
        var styleFirstWordAttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(22.0),
            NSParagraphStyleAttributeName: leftAlignedParagrahStyle]
        
        var style1AttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAlignedParagrahStyle]
        
        var style2AttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAlignedParagrahStyle]
        
        
        
        //Attributed string for title
        let titleString = NSAttributedString(string: "\(usdaItem.name)\n", attributes: titleAttributesDictionary)
        itemAttributedString.appendAttributedString(titleString)

        
        //Attrributed string for calcium
        let calciumTitleString = NSAttributedString(string: "Calcium ", attributes: styleFirstWordAttributesDictionary)
        let calciumBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.calcium as NSString).floatValue) + "mg\n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(calciumTitleString)
        itemAttributedString.appendAttributedString(calciumBodyString)
        
        //Attributed string for carbohydrate
        let carbohydrateTitleString = NSAttributedString(string: "Carbohydrate ", attributes: styleFirstWordAttributesDictionary)
        let carbohydateBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.carbohydrate as NSString).floatValue) + "g\n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(carbohydrateTitleString)
        itemAttributedString.appendAttributedString(carbohydateBodyString)
        
        //Attributed string for cholesterol
        let cholesterolTitleString = NSAttributedString(string: "Choelsterol ", attributes: styleFirstWordAttributesDictionary)
        let cholesterolBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.cholesterol as NSString).floatValue) + "mg\n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(cholesterolTitleString)
        itemAttributedString.appendAttributedString(cholesterolBodyString)
        
        //Attributed string for Energy
        let energyTitleString = NSAttributedString(string: "Energy ", attributes: styleFirstWordAttributesDictionary)
        let energyBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.energy as NSString).floatValue) + "kcal\n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(energyTitleString)
        itemAttributedString.appendAttributedString(energyBodyString)
        
        //Attributed string for FAT
        let fatTotalTitleString = NSAttributedString(string: "Total Fat ", attributes: styleFirstWordAttributesDictionary)
        let fatTotalBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.fatTotal as NSString).floatValue) + "g\n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(fatTotalTitleString)
        itemAttributedString.appendAttributedString(fatTotalBodyString)
        
        //Attributed string for Protein
        let proteinTitleString = NSAttributedString(string: "Protein ", attributes: styleFirstWordAttributesDictionary)
        let proteinBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.protein as NSString).floatValue) + "g\n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(proteinTitleString)
        itemAttributedString.appendAttributedString(proteinBodyString)
        
        //Attributed string for Sugar
        let sugarTitleString = NSAttributedString(string: "Sugar ", attributes: styleFirstWordAttributesDictionary)
        let sugarBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.sugar as NSString).floatValue) + "g\n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(sugarTitleString)
        itemAttributedString.appendAttributedString(sugarBodyString)
        
        //Attributed string for VitaminC
        let vitaminCTitleString = NSAttributedString(string: "Vitamin C ", attributes: styleFirstWordAttributesDictionary)
        let vitaminCBodyString = NSAttributedString(string: String(format: "%.2f", (usdaItem.sugar as NSString).floatValue) + "mg\n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(vitaminCTitleString)
        itemAttributedString.appendAttributedString(vitaminCBodyString)
        
        return itemAttributedString
    }
    
    func requestAuthorisationForHealthStore() {
        
        let dataTypesToWrite = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC)
        ]
        
        let dataTypesToRead = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar),
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC)
            ]
        var store: HealthStoreConstant = HealthStoreConstant()
        store.healthStore?.requestAuthorizationToShareTypes(NSSet(array: dataTypesToWrite) as Set<NSObject>, readTypes: NSSet(array: dataTypesToRead) as Set<NSObject>, completion: { (success, error) -> Void in
            if success {
                println("User completed authorisation request")
            } else {
                println("User canceled authorisation request \(error)")
            }
        })
    }
    
    func saveFoodItem (foodItem: USDAItem) {
        if HKHealthStore.isHealthDataAvailable() {
            let timeFoodWasEntered = NSDate()
            
            let foodMetaData = [
                HKMetadataKeyFoodType : foodItem.name,
                "HKBrandName" : "USDAItem",
                "HKFoodTypeID" : foodItem.idValue
            ]
            
            let energyUnit = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue:(foodItem.energy as NSString).doubleValue)
            let calories = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed), quantity: energyUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
            
            let calciumUnit = HKQuantity(unit: HKUnit.gramUnitWithMetricPrefix(HKMetricPrefix.Milli), doubleValue: (foodItem.calcium as NSString).doubleValue)
            let calcium = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium), quantity: calciumUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
            
            let carboHydrateUnit = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: (foodItem.carbohydrate as NSString).doubleValue)
            let carbohydrates = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates), quantity: carboHydrateUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
            
            let fatTotalUnit = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: (foodItem.fatTotal as NSString).doubleValue)
            let fatTotal = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal), quantity: fatTotalUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
            
            let proteinUnit = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: (foodItem.protein as NSString).doubleValue)
            let protein = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein), quantity: proteinUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
            
            
            
        }
    }
}
