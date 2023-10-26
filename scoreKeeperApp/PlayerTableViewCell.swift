//
//  PlayerTableViewCell.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/23/23.
//

import UIKit

protocol PlayerCellDelegate {
    func recieveNewScore(_:PlayerTableViewCell,score:Int,index:Int)
}

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var intervalField: UITextField!
    @IBOutlet var cellView: UIView!
    
    var score = 0
    var index = 0
    var delegate: PlayerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    @IBAction func valueChanged(_ sender: Any) {
        while (intervalField.text?.count)! > 3 {
            intervalField.text?.removeLast()
        }
    }
    
    @IBAction func subtractScore(_ sender: Any) {
        if let text = intervalField.text {
            score -= Int(text) ?? 1
        } else {
            score -= 1
        }
        scoreLabel.text = "\(score)"
        delegate?.recieveNewScore(self, score: score, index: index)
    }
    
    @IBAction func addScore(_ sender: Any) {
        if let text = intervalField.text {
            score += Int(text) ?? 1
        } else {
            score += 1
        }
        scoreLabel.text = "\(score)"
        delegate?.recieveNewScore(self, score: score, index: index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
