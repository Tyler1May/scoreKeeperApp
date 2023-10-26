//
//  GameTableViewController.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/25/23.
//

import UIKit

class GameTableViewController: UITableViewController, AddButtonDelegate, PlayerDisplayDelegate {
    
    func addGameButtonTapped(withInfo info: Game) {
        if let index = myGames.firstIndex(where: {$0.id == info.id }) {
            myGames[index] = info
        } else {
            myGames.insert(info, at: 0)
        }
        tableView.reloadData()
    }
    
    var scoreboardTableViewController = ScoreboardTableViewController()
    
    
    var selectedGame: Game?
    var myGames: [Game] = [] {
        didSet {
            Game.save(games: myGames)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myGames = Game.load()
        
        let backgroundImage = UIImageView(image: UIImage(named: "background"))
        tableView.backgroundView = backgroundImage
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = tableView.frame
        tableView.sendSubviewToBack(backgroundImage)
        tableView.backgroundColor = .clear
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        selectedGame = nil
    }
    
    func getNewPlayers(_: ScoreboardTableViewController, players: [Player]) {
        if let index = myGames.firstIndex(where: { $0.id == selectedGame?.id }) {
            selectedGame?.gamePlayer = players
            myGames[index] = selectedGame!
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    @IBAction func addGameTapped(_ sender: Any) {
        performSegue(withIdentifier: "addGame", sender: nil)
    }
    
    @IBSegueAction func addGameSegue(_ coder: NSCoder, sender: Any?) -> AddGameViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let game = myGames[indexPath.row]
            let vc = AddGameViewController(coder: coder, game: game, setting: game.gameSetting)
            vc?.delegate = self
            return vc
        } else {
            let vc = AddGameViewController(coder: coder)
            vc?.delegate = self
            return vc
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGame = myGames[indexPath.row]
        performSegue(withIdentifier: "toPlayers", sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGames.count
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameTableViewCell
        let game = myGames[indexPath.row]
        
        cell.cellView.layer.cornerRadius = 20
        cell.gameNameLabel.text = "\(game.gameName.capitalized)"
        if game.gamePlayer.count > 0 {
            cell.playerNameLabel.text = "\(game.gamePlayer[0].name)"
            cell.playerScoreLabel.text = "\(game.gamePlayer[0].score)"
        }
        
        return cell
    }
    
    @IBSegueAction func toPlayers(_ coder: NSCoder, sender: Any?) -> ScoreboardTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return ScoreboardTableViewController(coder: coder)
        }
        let vc = ScoreboardTableViewController(coder: coder)
        
        vc?.myPlayers = myGames[indexPath.row].gamePlayer
        vc?.setting = myGames[indexPath.row].gameSetting
        vc?.playerDelegate = self
        
        return vc
    }
    
    
}
