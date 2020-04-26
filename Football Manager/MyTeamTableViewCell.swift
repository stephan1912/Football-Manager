//
//  MyTeamTableViewCell.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import UIKit

class MyTeamTableViewCell: UITableViewCell {

    @IBOutlet var pStam: UILabel!
    @IBOutlet var pOvr: UILabel!
    @IBOutlet var pRole: UILabel!
    @IBOutlet var pName: UILabel!
    @IBOutlet var redCard: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
