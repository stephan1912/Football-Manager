//
//  ScoreBoardViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/14/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var scoreBoard: ScoreBoard = ScoreBoard()
    var teamS: [TeamStats] = []
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MyTeamViewController") as! MyTeamViewController;
        mainView.isUserTeam = false
        mainView.team = teamS[indexPath.row].TeamS
        navigationController?.pushViewController(mainView, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamS.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! ScoreBoardTableViewCell
        
        cell.tNameLabel?.text = teamS[indexPath.row].TeamS.name
        cell.gPlayedLabel?.text = String(teamS[indexPath.row].GamesPlayed)
        cell.gScoredLabel?.text = String(teamS[indexPath.row].GoalsScored)
        cell.gRecvLabel?.text = String(teamS[indexPath.row].GoalsRecv)
        cell.pointsLabel?.text = String(teamS[indexPath.row].Points)
        cell.nrCrtLabel?.text = String(indexPath.row + 1) + "."
        return cell
    }
    
    @IBAction func closeView(_ sender: Any) {
        navigationController?.popViewController(animated: false)
        //self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreBoard = AppUsers.getCurrentUser().ScoreB
        teamS = scoreBoard.TeamS.sorted(by: {$0.Points > $1.Points})
        
        ViewController.assignbackground(self.view!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
