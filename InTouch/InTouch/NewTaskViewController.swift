//
//  NewTaskViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class NewTaskViewController: XLFormViewController {

    var parentVC:TasksTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissButton = UIBarButtonItem(image: UIImage(named: "dismissBarButtonIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "dismissButtonTapped")
        self.navigationItem.leftBarButtonItem = dismissButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonTapped")
        self.navigationItem.rightBarButtonItem = doneButton
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Add Task")
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // Name
        row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title: "Name")
        row.required = true
        section.addFormRow(row)
        
        // Description
        row = XLFormRowDescriptor(tag: "description", rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Reminder")
        row.required = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // Segmented Control
        row = XLFormRowDescriptor(tag: "constraintType", rowType: XLFormRowDescriptorTypeSelectorSegmentedControl, title: "Constraint Type")
        row.selectorOptions = ["Time", "Activity"]
        row.value = "Time"
        row.required = true
        section.addFormRow(row)
        
        // Time Rows
        row = XLFormRowDescriptor(tag: "time", rowType: XLFormRowDescriptorTypeTimeInline, title: "Time")
        row.value = NSDate()
        section.addFormRow(row)
        row.hidden = NSPredicate(format: "($constraintType.value ==[c] 'Activity')")

        row = XLFormRowDescriptor(tag: "timeModifier", rowType: XLFormRowDescriptorTypeSelectorPickerViewInline, title: "Max Delay")
        row.selectorOptions = ["None", "15 minutes", "30 minutes", "45 minutes", "60 minutes"]
        row.value = "None"
        section.addFormRow(row)
        row.hidden = NSPredicate(format: "($constraintType.value ==[c] 'Activity')")
        
        // Activity Rows
        row = XLFormRowDescriptor(tag: "minutesActive", rowType: XLFormRowDescriptorTypeInteger, title: "Minutes Active")
        row.value = 15
        section.addFormRow(row)
        row.hidden = NSPredicate(format: "($constraintType.value ==[c] 'Time')")

        
        row = XLFormRowDescriptor(tag: "activityModifier", rowType: XLFormRowDescriptorTypeSelectorPickerViewInline, title: "Max Slack Cut")
        row.selectorOptions = ["None", "5 minutes", "10 minutes", "15 minutes", "20 minutes", "25 minutes", "30 minutes"]
        row.value = "None"
        section.addFormRow(row)
        row.hidden = NSPredicate(format: "($constraintType.value ==[c] 'Time')")


        // Trigger Section
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)

        // Notification
        row = XLFormRowDescriptor(tag: "notification", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Notification")
        row.value = true
        section.addFormRow(row)

        // SMS
        row = XLFormRowDescriptor(tag: "sms", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "SMS")
        row.value = false
        section.addFormRow(row)

        // Call
        row = XLFormRowDescriptor(tag: "call", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Call")
        row.value = false
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func doneButtonTapped(){
        
        let validationErrors:NSArray = self.formValidationErrors()
        if (validationErrors.count > 0) {
            var errorString = ""
            for error in validationErrors {
                errorString += error.localizedDescription + "\n"
            }
            let alertC = UIAlertController(title: "Error! Please check again.", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alertC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alertC, animated: true, completion: nil)
        }
        else{
            let valuesDictionary = self.formValues()
            let task = PFObject(className: "Task")
            task["name"] = valuesDictionary["name"] as! String
            task["description"] = valuesDictionary["description"] as! String
            task["constraintType"] = valuesDictionary["constraintType"] as! String
            if (task["constraintType"] as! String == "Time"){
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                task["constraintTime"] = dateFormatter.stringFromDate(valuesDictionary["time"] as! NSDate)
                var maxDelayedMinutesString = "0"
                if (valuesDictionary["timeModifier"] as! String != "None"){
                    maxDelayedMinutesString = (valuesDictionary["timeModifier"] as! String).characters.split{$0 == " "}.map(String.init)[0]
                }
                task["maxDelayedMinutes"] = Int(maxDelayedMinutesString)
            }
            else{
                task["constraintActivity"] = valuesDictionary["minutesActive"] as! Int
                var maxSlackedMinutesString = "0"
                if (valuesDictionary["activityModifier"] as! String != "None"){
                    maxSlackedMinutesString = (valuesDictionary["activityModifier"] as! String).characters.split{$0 == " "}.map(String.init)[0]
                }
                task["maxSlackedMinutes"] = Int(maxSlackedMinutesString)
            }
            let triggers:NSMutableArray = []
            if (valuesDictionary["notification"] as! Bool){
                triggers.addObject("notification")
            }
            if (valuesDictionary["sms"] as! Bool){
                triggers.addObject("sms")
            }
            if (valuesDictionary["call"] as! Bool){
                triggers.addObject("call")
            }
            task["constraintTriggers"] = triggers
            task["caregiver"] = PFUser.currentUser()
            task["elder"] = PFUser.currentUser()!["connection"] as! PFUser
            task["responded"] = false
            task.saveInBackgroundWithBlock({(success, error) -> Void in
                self.dismissViewControllerAnimated(true, completion: {() -> Void in
                    self.parentVC.loadTasks()
                })
            })
        }
    }
    
    func dismissButtonTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

class NewTaskNavigationViewController : UINavigationController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
}

