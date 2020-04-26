//
//  RoundTableViewCell.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/14/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class RoundTableViewCell: UITableViewCell {

    @IBOutlet var nrCrt: UILabel!
    @IBOutlet var awayScore: UILabel!
    @IBOutlet var homeScore: UILabel!
    @IBOutlet var awayTeam: UILabel!
    @IBOutlet var homeTeam: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
