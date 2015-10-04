//
//  AccountViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    var parentVC:TasksTableViewController!
    var scrollView:TPKeyboardAvoidingScrollView!
    var logoutButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissButton = UIBarButtonItem(image: UIImage(named: "dismissBarButtonIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "dismissButtonTapped")
        self.navigationItem.leftBarButtonItem = dismissButton

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red:0.14, green:0.22, blue:0.51, alpha:1)]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

        self.scrollView = TPKeyboardAvoidingScrollView(frame: self.view.frame)
        
        self.logoutButton = UIButton(frame: CGRectZero)
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.logoutButton.layer.cornerRadius = 6
        self.logoutButton.clipsToBounds = true
        self.logoutButton.setTitle("Logout", forState: UIControlState.Normal)
        self.logoutButton.titleLabel?.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        self.logoutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.logoutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.logoutButton.setBackgroundImage((UIApplication.sharedApplication().delegate as! AppDelegate)
            .imageWithColor(((UIApplication.sharedApplication().delegate as! AppDelegate).window?.tintColor)!), forState: UIControlState.Normal)
        self.logoutButton.setBackgroundImage((UIApplication.sharedApplication().delegate as! AppDelegate)
            .imageWithColor(((UIApplication.sharedApplication().delegate as! AppDelegate).window?.tintColor)!.darkerColor()), forState: UIControlState.Highlighted)
        self.logoutButton.showsTouchWhenHighlighted = false
        self.logoutButton.addTarget(self, action: "logoutButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(self.logoutButton)
        
        let viewsDictionary = ["logoutButton":self.logoutButton]
        let metricsDictionary = ["sideMargin":30]
        
        let centerConstraint = NSLayoutConstraint(item: self.logoutButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(centerConstraint)
        
        let logoutButtonHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sideMargin-[logoutButton]-sideMargin-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=140-[logoutButton(50)]->=0-|", options: [NSLayoutFormatOptions.AlignAllLeft,NSLayoutFormatOptions.AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        
        self.scrollView.addConstraints(logoutButtonHConstraints)
        self.scrollView.addConstraints(verticalConstraints)
        
        self.view.addSubview(self.scrollView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dismissButtonTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func logoutButtonTapped(){
        PFUser.logOutInBackgroundWithBlock({(error) -> Void in
            self.dismissViewControllerAnimated(true, completion: {
                self.parentVC.performSegueWithIdentifier("presentLoginDialog", sender: self.parentVC)
            })
        })
    }
    
}
