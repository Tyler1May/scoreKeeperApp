//
//  AddGameViewController.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/25/23.
//

import UIKit

protocol AddButtonDelegate: AnyObject {
    func addGameButtonTapped(withInfo info: Game)
    
}

class AddGameViewController: UIViewController {
    
    @IBOutlet var gameNameTextField: UITextField!
    @IBOutlet var scoreSettingSelector: UISegmentedControl!
    
    var game: Game?
    var setting: GameSetting
    
    init?(coder: NSCoder, game: Game, setting: GameSetting) {
        self.game = game
        self.setting = setting
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.game = nil
        self.setting = .highScore
        super.init(coder: coder)
    }
    
    @IBAction func selectorChanged(_ sender: Any) {
        switch scoreSettingSelector.selectedSegmentIndex {
        case 0:
            setting = .highScore
        case 1:
            setting = .none
        case 2:
            setting = .lowScore
        default:
            setting = .highScore
        }
    }
    
    weak var delegate: AddButtonDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let game {
            gameNameTextField.text = game.gameName
        }
        self.navigationController?.navigationBar.tintColor = .black
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background1")
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
    }
    
    @IBAction func addGameButtonTapped(_ sender: Any) {
        if game != nil {
            game?.gameName = gameNameTextField.text ?? "Game"
            delegate?.addGameButtonTapped(withInfo: game!)
        } else {
            
            delegate?.addGameButtonTapped(withInfo: game ?? Game(gameName: gameNameTextField.text ?? "Game", gamePlayer: [], gameSetting: setting))
        }
        navigationController?.popViewController(animated: true)
    }
    
}
