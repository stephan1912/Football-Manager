//
//  CreateViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/6/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit
class CreateViewController: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource{
    
    var leagueArray: [League] = []
    @IBOutlet var emailField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var ligaField: UIPickerView!
    @IBOutlet var clubField: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ligaField.delegate = self;
        ligaField.dataSource = self;
        
        clubField.delegate = self;
        clubField.dataSource = self;
        
        ViewController.assignbackground(self.view);
        
        
        leagueArray = loadJSON(fileURL: "gameData")
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet var CreateAccount: UIButton!
    @IBAction func createAccountAction(_ sender: Any) {
        let uname = usernameField?.text
        let email = emailField?.text
        let psd = passwordField?.text
        let league = leagueArray[(ligaField?.selectedRow(inComponent: 0))!].name
        let club = leagueArray[(ligaField?.selectedRow(inComponent: 0))!].Teams[(clubField?.selectedRow(inComponent: 0))!].name
        
        if uname == "" || email == "" || psd == "" || league == "" || club == "" {
            // return;
        }
        
        let userString = UserDefaults.standard.object(forKey: uname!) as? String
        
        if userString != nil {
            //return
        }
        
        let user = UserData()
        user.ClubLeague = league
        user.ClubName = club
        user.Username = uname!
        user.Email = email!
        user.Password = psd!
        
        user.createScoreBoard(league: leagueArray[(ligaField?.selectedRow(inComponent: 0))!])
        
        if AppUsers.addUser(user: user){
            let profileView = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController;
            profileView.userData = user;
            navigationController?.setViewControllers([profileView], animated: false);        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int {
        if(pickerView.restorationIdentifier == "ligaPicker"){
            //return pickerLigaData.count
            return leagueArray.count
        }else{
            //return pickerClubData.count
            return leagueArray[(ligaField?.selectedRow(inComponent: 0))!].Teams.count
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.restorationIdentifier == "ligaPicker"){
            clubField.reloadAllComponents()
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        if(pickerView.restorationIdentifier == "ligaPicker"){
            //return pickerLigaData[row]
            return leagueArray[row].name
        }else{
            //return pickerClubData[row]
            return leagueArray[(ligaField?.selectedRow(inComponent: 0))!].Teams[row].name
        }
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController;
        navigationController?.setViewControllers([mainView], animated: false);    }
    
    // Retrieves JSON from bundle
    func loadJSON(fileURL:String)-> [League] {
        let asset = NSDataAsset(name:fileURL, bundle: Bundle.main)
        let json = try? JSONSerialization.jsonObject(with: asset!.data, options: []) as! [AnyObject]
        
        var leagues: [League] = []
        
        for js in json ?? []{
            let league = League()
            
            league.name = (js["leagueName"] as? String)!;
            
            for field in js["teams"] as? [AnyObject] ?? [] {
                let team = Team()
                team.name = (field["name"] as? String)!
                team.country = (field["country"] as? String)!
                team.league = (field["league"] as? String)!
                team.manager = (field["manager"] as? String)!
                
                for pl in field["players"] as? [AnyObject] ?? []{
                    let player = Player()
                    player.name = (pl["name"] as? String)!
                    player.role = (pl["role"] as? String)!
                    player.rating = (pl["rating"] as? Int)!
                    player.stamina = (pl["stamina"] as? Int)!
                    team.players.append(player)
                }
                league.Teams.append(team)
            }
            leagues.append(league)
        }
        
        return leagues
    }
}
