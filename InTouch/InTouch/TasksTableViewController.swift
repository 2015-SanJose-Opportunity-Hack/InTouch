//
//  TasksTableViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "InTouch"
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addButtonTapped")
        self.navigationItem.rightBarButtonItem = addButton
        
        let accountButton = UIBarButtonItem(image: UIImage(named: "accountBarButtonIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "accountButtonTapped")
        self.navigationItem.leftBarButtonItem = accountButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func addButtonTapped(){
        self.performSegueWithIdentifier("showNewTask", sender: self)
    }
    
    func accountButtonTapped(){
        self.performSegueWithIdentifier("showAccount", sender: self)
    }

}
