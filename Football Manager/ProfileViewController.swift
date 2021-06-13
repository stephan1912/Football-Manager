//
//  ProfileViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/6/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import CodableFirebase
import FirebaseDatabase
class ProfileViewController: UIViewController {

    
    @IBOutlet var nextOponentLabel: UILabel!
    @IBOutlet var currentRoundLabel: UILabel!
    @IBOutlet var clubLabel: UILabel!
    @IBOutlet var leagueLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var newsLabel: UILabel!
    
    var ref = Database.database().reference()
    var newsList: [News] = []
    var currentNews = 0
    
    @IBAction func WebViewPrevEvent(_ sender: UIButton) {
        if newsList.count <= 0 {
            return
        }
        currentNews = currentNews - 1
        if currentNews <= 0{
            currentNews = newsList.count - 1
        }
        newsLabel.text = newsList[currentNews].title
        webView.load(URLRequest(url: URL(string: newsList[currentNews].link)!))
    }
    @IBAction func WebViewNextEvent(_ sender: UIButton) {
        if newsList.count <= 0 {
            return
        }
        currentNews = currentNews + 1
        if currentNews >= newsList.count{
            currentNews = 0
        }
        newsLabel.text = newsList[currentNews].title
        webView.load(URLRequest(url: URL(string: newsList[currentNews].link)!))
    }
    
    func getNewsData(){
        self.ref.child("News").getData { (error, snapshot) in
            do{
            if let error = error {
                print("Error getting news \(error)")
            }
            else if snapshot.exists() {
                self.newsList = try FirebaseDecoder().decode([News].self, from: snapshot.value!)
                if(self.newsList.count == 0) {
                    return
                }
                DispatchQueue.main.async {
                    self.newsLabel.text = self.newsList[0].title
                    self.webView.load(URLRequest(url: URL(string: self.newsList[0].link)!))
                    
                }
                //print("Got data \(snapshot.value!)")
            }
            else {
                print("No news available")
            }
            }
            catch{
                print("Error on news")
            }
        }
        
    }
    
    var userData:UserData = UserData();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewsData()
        
        userData = AppUsers.getCurrentUser()
        
        usernameLabel.text = "Bun venit " + userData.Username
        leagueLabel.text = "Campionat: " + userData.ClubLeague
        clubLabel.text = "Echipa: " + userData.ClubName
        currentRoundLabel.text = "Etapa: " + String(userData.ScoreB.CurrentRound)
        nextOponentLabel.text = "Urmatorul meci: " + (userData.ScoreB.getNextOpponent(teamName: userData.ClubName)?.name)!
        ViewController.assignbackground(self.view);
        
        // Do any additional setup after loading the view.
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
        //mainView.scoreBoard = userData.ScoreB
        navigationController?.pushViewController(mainView, animated: false)    }
    @IBAction func goToScoreBoard(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "ScoreBoardViewController") as! ScoreBoardViewController;
        //mainView.scoreBoard = userData.ScoreB
        navigationController?.pushViewController(mainView, animated: false)
        //self.present(mainView, animated: false, completion: nil);
    }
    @IBAction func goToMyTeam(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MyTeamViewController") as! MyTeamViewController;
        //mainView.team = userData.ScoreB.getTeamByName(name: userData.ClubName)!
        navigationController?.pushViewController(mainView, animated: false)
    }
    @IBAction func goToSimulateRound(_ sender: Any) {
        let check  = userData.getTeam().performCheck()
        if check == GameError.NoError{
            
            let mainView = storyboard?.instantiateViewController(withIdentifier: "GameResultViewController") as! GameResultViewController;
            //mainView.userData = userData
            navigationController?.pushViewController(mainView, animated: false)
            
        }
        else{
            let alert = UIAlertController(title: "Oops", message: check.rawValue, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Vezi Echipa", style: UIAlertAction.Style.default, handler: goToMyTeam))
            alert.addAction(UIAlertAction(title: "Inchide", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        userData = AppUsers.getCurrentUser()
        currentRoundLabel.text = "Etapa: " + String(userData.ScoreB.CurrentRound)
        nextOponentLabel.text = "Urmatorul meci: " + (userData.ScoreB.getNextOpponent(teamName: userData.ClubName)?.name)!
    }

}
