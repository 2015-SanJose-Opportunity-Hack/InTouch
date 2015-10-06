//
//  ChatViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var slackChatViewController:SlackChatViewController!
    var receivedMessages = ["Bruno doesn't seem to be getting better.","No. I'm also feeling a bit under the weather today. Can you take him?","Thanks so much."]
    var sentMessages = ["Did you take him to the vet?","Sure.","I will call you before I leave work."]
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red:0.14, green:0.22, blue:0.51, alpha:1)]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

        self.slackChatViewController = SlackChatViewController()
        self.slackChatViewController.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 49.5)
        self.slackChatViewController.tableView.estimatedRowHeight = 80
        self.slackChatViewController.tableView.rowHeight = UITableViewAutomaticDimension
        self.slackChatViewController.tableView.delegate = self
        self.slackChatViewController.tableView.dataSource = self
        self.slackChatViewController.tableView.registerClass(ConversationBubbleTableViewCell.self, forCellReuseIdentifier: "ConversationBubbleTableViewCell")
        self.slackChatViewController.tableView.contentInset.top = 6
        self.view.addSubview(self.slackChatViewController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationBubbleTableViewCell") as! ConversationBubbleTableViewCell
        if (indexPath.row % 2 == 0){
            cell.messageLabel.text = self.receivedMessages[indexPath.row / 2]
            cell.bubbleView.backgroundColor = UIColor(red:0, green:0.6, blue:0.89, alpha:1)
        }
        else{
            cell.messageLabel.text = self.sentMessages[indexPath.row / 2]
            cell.bubbleView.backgroundColor = UIColor(red:0.14, green:0.22, blue:0.51, alpha:1)
        }
        cell.transform = self.slackChatViewController.tableView.transform
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sentMessages.count + self.receivedMessages.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
