//
//  TabBarViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.tabBar.items as [UITabBarItem]!)[0].image = UIImage(named: "tasksTabBarIcon")
        (self.tabBar.items as [UITabBarItem]!)[1].image = UIImage(named: "chatTabBarIcon")
    }
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil){
//            self.performSegueWithIdentifier("presentLoginDialog", sender: self)
        }
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
