//
//  MyTeamViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class MyTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var team: Team = Team()
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.players.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! MyTeamTableViewCell
        
        cell.redCard?.isHidden = team.players[indexPath.row].redCard == false
        cell.pName?.text = team.players[indexPath.row].name
        cell.pRole?.text = team.players[indexPath.row].role
        cell.pOvr?.text = String(team.players[indexPath.row].rating)
        cell.pStam?.text = String(team.players[indexPath.row].stamina)
        return cell
    }
    
    @IBAction func closeView(_ sender: Any) {
        navigationController?.popViewController(animated: false)
        //self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.assignbackground(self.view!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
