//
//  GameTableViewCell.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/25/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet var gameNameLabel: UILabel!
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerScoreLabel: UILabel!
    @IBOutlet var cellView: UIView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
