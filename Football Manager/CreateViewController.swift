//
//  CreateViewController.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/6/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit
class CreateViewController: UIViewController, UIPickerViewDelegate , UIPickerViewDataSource{
    
    @IBOutlet var errorLbl: UILabel!
    var leagueArray: [League] = []
    @IBOutlet var emailField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var ligaField: UIPickerView!
    @IBOutlet var clubField: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
        ligaField.delegate = self;
        ligaField.dataSource = self;
        
        clubField.delegate = self;
        clubField.dataSource = self;
        
        ViewController.assignbackground(self.view);
        
        
        leagueArray = loadJSON(fileURL: "gameData")
        //Looks for single or multiple taps.
     let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false

    view.addGestureRecognizer(tap)
}

//Calls this function when the tap is recognized.
@objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
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
            errorLbl.text = "Trebuie sa completati toate campurile"
            errorLbl.isHidden = false
            return
        }
        
        let user = UserData()
        user.ClubLeague = league
        user.ClubName = club
        user.Username = uname!
        user.Email = email!
        user.Password = psd!
        
        user.createScoreBoard(league: leagueArray[(ligaField?.selectedRow(inComponent: 0))!])
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if AppUsers.addUser(user: user, context: context){
            let profileView = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController;
            profileView.userData = user;
            navigationController?.setViewControllers([profileView], animated: false);
            AppUsers.setCurrentUser(user: user)
        }
        else {
            errorLbl.text = "Exista un profil cu acest username"
            errorLbl.isHidden = false
            emailField.text = ""
            passwordField.text = ""
            usernameField.text = ""
            return
        }
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
        navigationController?.setViewControllers([mainView], animated: false);
    }
    
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
                team.generateStarting11()
                league.Teams.append(team)
            }
            leagues.append(league)
        }
        
        return leagues
    }
}
