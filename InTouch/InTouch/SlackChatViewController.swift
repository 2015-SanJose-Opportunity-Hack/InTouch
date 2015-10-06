//
//  slackChatViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/4/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class SlackChatViewController: SLKTextViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bounces = true
        self.keyboardPanningEnabled = true
        self.inverted = true
        
//        self.tableView.registerClass(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.textView.placeholder = "Type something..."
        self.textView.placeholderColor = UIColor(red:0, green:0.6, blue:0.89, alpha:1)
        self.textView.layer.borderColor = UIColor(red:0, green:0.6, blue:0.89, alpha:1).CGColor
        self.textView.pastableMediaTypes = SLKPastableMediaType.None
        self.rightButton.setTitle("Post", forState: UIControlState.Normal)
        
        self.textInputbar.autoHideRightButton = false
        self.textInputbar.maxCharCount = 140
        self.textInputbar.counterStyle = SLKCounterStyle.Split
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

}
