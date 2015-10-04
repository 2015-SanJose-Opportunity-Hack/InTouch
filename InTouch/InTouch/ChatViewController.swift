//
//  ChatViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red:0.14, green:0.22, blue:0.51, alpha:1)]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

        // Do any additional setup after loading the view.
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
