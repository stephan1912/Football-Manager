//
//  CurrentRoundViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/14/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class CurrentRoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var scoreBoard: ScoreBoard = ScoreBoard()
    var etapaCurenta: Int = 0
    @IBOutlet var etapaLabel: UILabel!
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreBoard.Rounds[scoreBoard.CurrentRound - 1].Games.count
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBAction func prevRound(_ sender: Any) {
        if etapaCurenta > 1 {
            etapaCurenta = etapaCurenta - 1
            tableView.reloadData()
            etapaLabel?.text = "Meciurile etapei " + String(etapaCurenta)
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBAction func nextRound(_ sender: Any) {
        if etapaCurenta < scoreBoard.Rounds.count{
            etapaCurenta = etapaCurenta + 1
            tableView.reloadData()
            etapaLabel?.text = "Meciurile etapei " + String(etapaCurenta)        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! RoundTableViewCell
        let games = scoreBoard.Rounds[etapaCurenta - 1].Games
        cell.homeTeam?.text = games[indexPath.row].HomeTeam.name
        cell.awayTeam?.text = games[indexPath.row].AwayTeam.name
        cell.homeScore?.text = String(games[indexPath.row].HomeGoals)
        cell.awayScore?.text = String(games[indexPath.row].AwayGoals)
        cell.nrCrt?.text = String(indexPath.row + 1) + "."
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "GameResultViewController") as! GameResultViewController;
        mainView.gameResult = scoreBoard.Rounds[etapaCurenta - 1].Games[indexPath.row]
        mainView.isSimulation = false
        navigationController?.pushViewController(mainView, animated: false)
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    @IBAction func closeView(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreBoard = AppUsers.getCurrentUser().ScoreB
        tableView.backgroundColor = UIColor.clear
        ViewController.assignbackground(self.view!)
        etapaCurenta = scoreBoard.CurrentRound;
        etapaLabel?.text = "Meciurile etapei " + String(scoreBoard.CurrentRound)
        // Do any additional setup after loading the view.
        //ViewController.assignbackground(tableView.backgroundView!)
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
