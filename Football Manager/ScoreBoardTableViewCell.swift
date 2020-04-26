//
//  ScoreBoardTableViewCell.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/14/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class ScoreBoardTableViewCell: UITableViewCell {

    @IBOutlet var nrCrtLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var gRecvLabel: UILabel!
    @IBOutlet var gScoredLabel: UILabel!
    @IBOutlet var gPlayedLabel: UILabel!
    @IBOutlet var tNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
