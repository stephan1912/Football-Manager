//
//  MyProfilesViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/29/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class MyProfilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var userTable: UITableView!
    var userList: [UserData] = []
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        
        cell.textLabel?.text = userList[indexPath.row].Username + " - " + userList[indexPath.row].ClubName
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    var selectedIndex: Int = 0
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Football Manager", message: "Esti sigur ca vrei sa stergi profilul?", preferredStyle: UIAlertControllerStyle.alert)
        selectedIndex = indexPath.row
        alert.addAction(UIAlertAction(title: "DA", style: UIAlertActionStyle.default, handler: removeUsers))
        alert.addAction(UIAlertAction(title: "NU", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeUsers(_ sender: Any){
        AppUsers.removeUser(user: userList[selectedIndex])
        userList = AppUsers.getAllUsers()
        userTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.assignbackground(self.view)
        userList = AppUsers.getAllUsers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backToLogin(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController;
        navigationController?.setViewControllers([mainView], animated: false);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
