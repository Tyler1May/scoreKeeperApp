//
//  AddPlayerViewController.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/23/23.
//

import UIKit

protocol SaveButtonDelegate: AnyObject {
    func saveButtonTapped(withInfo info: Player)
}

class AddPlayerViewController: UIViewController {
    
    @IBOutlet var playerNameField: UITextField!
    @IBOutlet var playerScoreField: UITextField!
    
    var player: Player?

        init?(coder: NSCoder, player: Player?) {
            self.player = player
            super.init(coder: coder)
        }

        required init?(coder: NSCoder) {
            self.player = nil
            super.init(coder: coder)
        }
    
    let scoreboardTableViewController = ScoreboardTableViewController()
    
    weak var delegate: SaveButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let player {
            playerNameField.text = player.name
            playerScoreField.text = String(player.score)
        }
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background1")
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if player != nil {
            //edit
            player?.name = playerNameField.text ?? "Player"
            if let playerScoreString = playerScoreField.text, let score = Int(playerScoreString) {
                player?.score = score
            }
            delegate?.saveButtonTapped(withInfo: player!)
        } else {
            
            delegate?.saveButtonTapped(withInfo: player ?? Player(name: playerNameField.text ?? "Player", score: Int(playerScoreField.text ?? "0") ?? 0))
        }
        navigationController?.popViewController(animated: true)
        
    }
    
}
