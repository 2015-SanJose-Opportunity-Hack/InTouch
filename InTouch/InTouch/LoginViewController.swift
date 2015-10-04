//
//  LoginViewController.swift
//  InTouch
//
//  Created by Chun-Wei Chen on 10/3/15.
//  Copyright © 2015 Chun-Wei Chen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var scrollView:TPKeyboardAvoidingScrollView!
    var usernameTextField:JVFloatLabeledTextField!
    var passwordTextField:JVFloatLabeledTextField!
    var loginButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = TPKeyboardAvoidingScrollView(frame: self.view.frame)
        
        self.usernameTextField = JVFloatLabeledTextField(frame: CGRectZero)
        self.usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.usernameTextField.setPlaceholder("Username", floatingTitle: "Username")
        self.usernameTextField.font = UIFont.systemFontOfSize(20)
        self.usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        self.usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        self.scrollView.addSubview(self.usernameTextField)

        self.passwordTextField = JVFloatLabeledTextField(frame: CGRectZero)
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.setPlaceholder("Password", floatingTitle: "Password")
        self.passwordTextField.font = UIFont.systemFontOfSize(20)
        self.passwordTextField.secureTextEntry = true
        self.scrollView.addSubview(self.passwordTextField)
        
        self.loginButton = UIButton(frame: CGRectZero)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.layer.cornerRadius = 6
        self.loginButton.clipsToBounds = true
        self.loginButton.setTitle("Login", forState: UIControlState.Normal)
        self.loginButton.titleLabel?.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.loginButton.setBackgroundImage((UIApplication.sharedApplication().delegate as! AppDelegate)
            .imageWithColor(((UIApplication.sharedApplication().delegate as! AppDelegate).window?.tintColor)!), forState: UIControlState.Normal)
        self.loginButton.setBackgroundImage((UIApplication.sharedApplication().delegate as! AppDelegate)
            .imageWithColor(((UIApplication.sharedApplication().delegate as! AppDelegate).window?.tintColor)!.darkerColor()), forState: UIControlState.Highlighted)
        self.loginButton.showsTouchWhenHighlighted = false
        self.loginButton.addTarget(self, action: "loginButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(self.loginButton)

        let viewsDictionary = ["usernameTextField":self.usernameTextField, "passwordTextField":self.passwordTextField, "loginButton":self.loginButton]
        let metricsDictionary = ["sideMargin":30]
        
        let centerConstraint = NSLayoutConstraint(item: self.usernameTextField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(centerConstraint)
        
        let usernameTextFieldHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sideMargin-[usernameTextField]-sideMargin-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=140-[usernameTextField(50)]-10-[passwordTextField(50)]-30-[loginButton(50)]->=0-|", options: [NSLayoutFormatOptions.AlignAllLeft,NSLayoutFormatOptions.AlignAllRight], metrics: metricsDictionary, views: viewsDictionary)
        self.scrollView.addConstraints(usernameTextFieldHConstraints)
        self.scrollView.addConstraints(verticalConstraints)
        
        self.view.addSubview(self.scrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "login"){
            print("logging in")
        }
    }
    
    func loginButtonTapped(){
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!, block:{ (user, error) -> Void in
            PFInstallation.currentInstallation()["currentUser"] = PFUser.currentUser()
            PFInstallation.currentInstallation().saveInBackgroundWithBlock({(success, error) -> Void in
                self.performSegueWithIdentifier("login", sender: self)
            })
        })
    }

}
