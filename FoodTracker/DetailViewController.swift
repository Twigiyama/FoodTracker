//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Asitha Rodrigo on 25/05/2015.
//  Copyright (c) 2015 Twig. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var usdaItem:USDAItem?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return itemAttributedString
    }
}
