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
    
    @IBOutlet var titleLabel: UILabel!
    var startingXiPlayers: [Player] = []
    var substitutePlayers: [Player] = []
    var reservedPlayers: [Player] = []
    
    @IBOutlet var selectedLabel: UILabel!
    var selectedPlayer: Player = Player()
    var subStep: Int = 0
    
    @IBOutlet var playersTable: UITableView!
    @IBOutlet var rezBtn: UIButton!
    @IBOutlet var subsBtn: UIButton!
    
    var menu: TeamRoles = TeamRoles.StartingXI
    var shownPlayers: [Player] = []
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownPlayers.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if subStep == 0{
            selectedPlayer = shownPlayers[indexPath.row]
            selectedLabel.text = selectedPlayer.name
            subStep = 1
        }
        else{
            let player2 = shownPlayers[indexPath.row]
            team.changePlayers(player1: selectedPlayer, player2: player2)
            subStep = 0
            selectedLabel.text = ""
            initPlayers()
            playersTable.deselectRow(at: indexPath, animated: false)
            playersTable.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! MyTeamTableViewCell
        
        cell.redCard?.isHidden = shownPlayers[indexPath.row].redCard == false
        cell.pName?.text = shownPlayers[indexPath.row].name
        cell.pRole?.text = shownPlayers[indexPath.row].role
        cell.pOvr?.text = String(shownPlayers[indexPath.row].rating)
        cell.pStam?.text = String(shownPlayers[indexPath.row].stamina)
        return cell
    }
    
    @IBAction func switchToRes(_ sender: UIButton) {
        subsBtn?.setTitle("Subs", for: .normal)
        if menu != TeamRoles.Reserved {
            titleLabel?.text = "Restul echipei"
            rezBtn?.setTitle("XI", for: .normal)
            shownPlayers = reservedPlayers
            menu = TeamRoles.Reserved
        }
        else{
            titleLabel?.text = "Primul 11"
            rezBtn?.setTitle("Res", for: .normal)
            shownPlayers = startingXiPlayers
            menu = TeamRoles.StartingXI
        }
        playersTable.reloadData()
    }

    @IBAction func switchToSub(_ sender: UIButton) {
        rezBtn?.setTitle("Res", for: .normal)
        if menu != TeamRoles.Substitue {
            titleLabel?.text = "Rezerve"
            subsBtn?.setTitle("XI", for: .normal)
            shownPlayers = substitutePlayers
            menu = TeamRoles.Substitue
        }
        else{
            titleLabel?.text = "Primul 11"
            subsBtn?.setTitle("Subs", for: .normal)
            shownPlayers = startingXiPlayers
            menu = TeamRoles.StartingXI
        }
        playersTable.reloadData()
    }
    
    @IBAction func closeView(_ sender: Any) {
        navigationController?.popViewController(animated: false)
        //self.dismiss(animated: true, completion: nil)
    }
    
    func initPlayers(){
        
        startingXiPlayers = team.getPlayerByTeamRole(role: TeamRoles.StartingXI)
        substitutePlayers = team.getPlayerByTeamRole(role: TeamRoles.Substitue)
        reservedPlayers = team.getPlayerByTeamRole(role: TeamRoles.Reserved)
        
        if menu == TeamRoles.StartingXI {
            shownPlayers = startingXiPlayers
        }
        else if menu == TeamRoles.Substitue{
            shownPlayers = substitutePlayers
        }
        else {
            shownPlayers = reservedPlayers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel?.text = "Primul 11"
        initPlayers()
        shownPlayers = startingXiPlayers
        
        ViewController.assignbackground(self.view!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
