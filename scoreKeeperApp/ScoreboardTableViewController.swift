//
//  ScoreboardTableViewController.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/23/23.
//

import UIKit

protocol PlayerDisplayDelegate {
    func getNewPlayers(_:ScoreboardTableViewController,players: [Player])
}

class ScoreboardTableViewController: UITableViewController, SaveButtonDelegate, PlayerCellDelegate {
    func saveButtonTapped(withInfo info: Player) {
        if let index = myPlayers.firstIndex(where: { $0.id == info.id }) {
            //an edit
            myPlayers[index] = info
        } else {
            //new
            myPlayers.insert(info, at: 0)
        }
        
        myPlayers = order(setting: setting, with: myPlayers)
        
        tableView.reloadData()
    }
    
    var setting: GameSetting!
    var playerDelegate: PlayerDisplayDelegate?
    
    var myPlayers: [Player] = [] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !myPlayers.isEmpty {
            myPlayers = order(setting: setting, with: myPlayers)
            tableView.reloadData()
        }
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let backgroundImage = UIImageView(image: UIImage(named: "background"))
        tableView.backgroundView = backgroundImage
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = tableView.frame
        tableView.sendSubviewToBack(backgroundImage)
        tableView.backgroundColor = .clear
    }
    
    // MARK: - Table view data source
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAdd", sender: nil)
    }
    
    @IBSegueAction func addSegue(_ coder: NSCoder) -> AddPlayerViewController? {
        let vc = AddPlayerViewController(coder: coder)
        vc?.delegate = self
        return vc
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editPlayer", sender: self)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myPlayers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerTableViewCell
        let player = myPlayers[indexPath.row]
        
        cell.cellView.layer.cornerRadius = 20
        cell.delegate = self
        cell.score = player.score
        cell.index = indexPath.row
        cell.playerNameLabel.text = "\(player.name)"
        cell.scoreLabel.text = "\(player.score)"
    
        return cell
    }
    
    func recieveNewScore(_: PlayerTableViewCell, score: Int, index: Int) {
        myPlayers[index].score = score
        myPlayers = order(setting: setting, with: myPlayers)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    @IBAction func unwindToPlayers(segue: UIStoryboardSegue) {
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myPlayers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            myPlayers = order(setting: setting, with: myPlayers)
            tableView.reloadData()
        }
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> AddPlayerViewController? {
        let player: Player?
        let vc = AddPlayerViewController(coder: coder)
        if let indexPath = tableView.indexPathForSelectedRow {
            player = myPlayers[indexPath.row]
            vc?.player = player
        } else {
            player = nil
        }
        vc?.delegate = self
        return vc
    }
    
    func order(setting: GameSetting, with players: [Player]) -> [Player] {
        var players = players
        switch setting {
        case .highScore:
            players.sort(by: >)
        case .none:
            break
        case .lowScore:
            players.sort(by: <)
        }
        playerDelegate?.getNewPlayers(self, players: players)
        return players
    }
    
}
