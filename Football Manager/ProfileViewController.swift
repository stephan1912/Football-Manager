//
//  ProfileViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/6/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet var nextOponentLabel: UILabel!
    @IBOutlet var currentRoundLabel: UILabel!
    @IBOutlet var clubLabel: UILabel!
    @IBOutlet var leagueLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    var userData:UserData = UserData();
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "Bun venit " + userData.Username
        leagueLabel.text = "Campionat: " + userData.ClubLeague
        clubLabel.text = "Echipa: " + userData.ClubName
        currentRoundLabel.text = "Etapa: " + String(userData.ScoreB.CurrentRound)
        nextOponentLabel.text = "Urmatorul meci: " + (userData.ScoreB.getNextOpponent(teamName: userData.ClubName)?.name)!
        ViewController.assignbackground(self.view);        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutAction(_ sender: AnyObject) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController;
        navigationController?.setViewControllers([mainView], animated: false);
    }

    @IBAction func goToCurrentRound(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "CurrentRoundViewController") as! CurrentRoundViewController;
        mainView.scoreBoard = userData.ScoreB
        navigationController?.pushViewController(mainView, animated: false)    }
    @IBAction func goToScoreBoard(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "ScoreBoardViewController") as! ScoreBoardViewController;
        mainView.scoreBoard = userData.ScoreB
        navigationController?.pushViewController(mainView, animated: false)
        //self.present(mainView, animated: false, completion: nil);
    }
    @IBAction func goToMyTeam(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MyTeamViewController") as! MyTeamViewController;
        mainView.team = userData.ScoreB.getTeamByName(name: userData.ClubName)!
        navigationController?.pushViewController(mainView, animated: false)
    }
    @IBAction func goToSimulateRound(_ sender: Any) {
        userData.ScoreB.simulateRound()
        currentRoundLabel.text = "Etapa: " + String(userData.ScoreB.CurrentRound)
        nextOponentLabel.text = "Urmatorul meci: " + (userData.ScoreB.getNextOpponent(teamName: userData.ClubName)?.name)!
        
    }

}
