//
//  GameResultViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/29/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class GameResultViewController: UIViewController, UITableViewDataSource
, UITableViewDelegate{

    @IBOutlet var awayScore: UILabel!
    @IBOutlet var homeScore: UILabel!
    @IBOutlet var homeTeam: UILabel!
    @IBOutlet var awayTeam: UILabel!
    
    var userData: UserData = UserData()
    var gameResult: Game = Game()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameResult.Events.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.textLabel?.text = gameResult.Events[indexPath.row].getEvent()
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData.ScoreB.simulateRound()
        gameResult = userData.ScoreB.getGameResultInRound(round: userData.ScoreB.CurrentRound - 2, team: userData.getTeam())!
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
    @IBAction func closeBtn(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }

}
