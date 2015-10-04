//
//  TasksTableViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    var tasks:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "InTouch"
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addButtonTapped")
        self.navigationItem.rightBarButtonItem = addButton
        
        let accountButton = UIBarButtonItem(image: UIImage(named: "accountBarButtonIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "accountButtonTapped")
        self.navigationItem.leftBarButtonItem = accountButton
        
        self.tableView.registerClass(TaskCardTableViewCell.self, forCellReuseIdentifier: "TaskCardTableViewCell")
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.top = 7
        self.tableView.contentInset.bottom = 7
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadTasks", forControlEvents: UIControlEvents.ValueChanged)

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red:0.14, green:0.22, blue:0.51, alpha:1)]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

        
        
        if (PFUser.currentUser() != nil){
            self.loadTasks()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil){
            print("currentUser doesn't exist")
            self.performSegueWithIdentifier("presentLoginDialog", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCardTableViewCell") as! TaskCardTableViewCell
        if (indexPath.row % 2 == 0){
            cell.cardView.backgroundColor = UIColor(red:0.14, green:0.22, blue:0.51, alpha:1)
            cell.cardView.layer.borderColor = UIColor(red:0.14, green:0.22, blue:0.51, alpha:1).CGColor
        }
        let task = self.tasks[indexPath.row]
        cell.taskNameLabel.text = task["name"] as? String
        var constraintModifierString = ""
        if (task["constraintType"] as? String == "Time"){
            cell.mainConstraintLabel.text = task["constraintTime"] as? String
            let modifierString = task["maxDelayedMinutes"]
            constraintModifierString = "\(modifierString)-minute response window"
        }
        else{
            let constraintActivityNumber = task["constraintActivity"] as? Int
            cell.mainConstraintLabel.text = "\(constraintActivityNumber!) MINS"
            let modifierString = task["maxSlackedMinutes"]
            constraintModifierString = "\(modifierString)-minute tolerance"
        }
        let triggerArray = task["constraintTriggers"] as! [String]
        var triggersString = ""
        for trigger in triggerArray{
            triggersString += trigger
            if (triggerArray.indexOf(trigger) < triggerArray.count - 1){
                triggersString += ", "
            }
        }
        cell.rangeAndTriggerLabel.text = "\(constraintModifierString)\n\(triggersString) if no response."
        return cell
    }

    func addButtonTapped(){
        self.performSegueWithIdentifier("showNewTask", sender: self)
    }
    
    func accountButtonTapped(){
        self.performSegueWithIdentifier("showAccount", sender: self)
    }
    
    func loadTasks(){
        let taskQuery = PFQuery(className: "Task")
        if (PFUser.currentUser()!["role"] as! String == "caregiver"){
            taskQuery.whereKey("caregiver", equalTo: PFUser.currentUser()!)
        }
        else{
            taskQuery.whereKey("elder", equalTo: PFUser.currentUser()!)
        }
        taskQuery.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
            if (error == nil){
                self.tasks = objects!
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                self.refreshControl?.endRefreshing()
            }
            else{
                print(error)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showNewTask"){
            let destinationVC = segue.destinationViewController as! NewTaskNavigationViewController
            let newTaskVC = destinationVC.childViewControllers[0] as! NewTaskViewController
            newTaskVC.parentVC = self
        }
        else if (segue.identifier == "showAccount"){
            let destinationVC = segue.destinationViewController as! UINavigationController
            let accountVC = destinationVC.childViewControllers[0] as! AccountViewController
            accountVC.parentVC = self
        }
    }
    
}
