//
//  ViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/6/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.assignbackground(self.view);
        //let x = CreateViewController.loadJSON(fileURL: "gameData")
        AppUsers.clearData()
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginAction(_ sender: AnyObject) {
        let username = usernameField.text;
        let password = passwordField.text;
        if(username == "" || password == "") {
            return;
        }
        if let userData = AppUsers.validateUserCredentials(uname: username!, password: password!){
            let profileView = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController;
            profileView.userData = userData;
            navigationController?.setViewControllers([profileView], animated: false);
        } else {
            print("There is an issue")
        }
        
    }

    @IBAction func GoToCreate(_ sender: AnyObject) {
        let createView = storyboard?.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController;
        navigationController?.pushViewController(createView, animated: false);
    }
    
    static func assignbackground(_ view: UIView){
        let background = UIImage(named: "background")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        imageView.addSubview(tintView)
        
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }}

