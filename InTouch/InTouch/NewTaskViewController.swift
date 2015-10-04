//
//  NewTaskViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class NewTaskViewController: XLFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissButton = UIBarButtonItem(image: UIImage(named: "dismissBarButtonIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "dismissButtonTapped")
        self.navigationItem.leftBarButtonItem = dismissButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonTapped")
        self.navigationItem.rightBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func doneButtonTapped(){
        print("doneButtonTapped")
    }
    
    func dismissButtonTapped(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
