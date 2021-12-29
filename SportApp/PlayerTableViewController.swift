//
//  PlayerTableViewController.swift
//  SportApp
//
//  Created by admin on 29/12/2021.
//

import UIKit

class PlayerTableViewController: UITableViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var sport: Sport!
    
    weak var delegate:  DelegateBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //add a new player
    
    @IBAction func addNewPlayer(_ sender: UIBarButtonItem) {
        playerAlert(title: "Add Player", mesg: "Enter Player Info.", player: nil)
    }
    
   //back to sport page
    @IBAction func back(_ sender: UIBarButtonItem) {
        delegate?.back(pressed: self)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sport.player?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let player = sport.player?[indexPath.row] as? Player{
            cell.textLabel?.text = "\(player.name ?? "") - \(player.age ?? "") - \(player.height ?? "")"
        }
        
        // Configure the cell...
        
        return cell
    }
    //click on the edit sign to update info
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let player = sport.player?[indexPath.row] as! Player
        playerAlert(title: "Edit Player", mesg: "Enter a New Information", player: player)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = sport.player?[indexPath.row] as! Player
        playerAlert(title: "Edit Player", mesg: "Enter a New Information", player: player)
        
    }
    
    //delete the player information cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let player = sport.player?[indexPath.row] as! Player
        sport.removeFromPlayer(player)
        
        saveContext()
        tableView.reloadData()
    }
    
    // MARK: - Function Section
    func  playerAlert(title: String, mesg: String, player: Player?){
        
        let alert = UIAlertController(title: "Add Player", message: "Enter Player Details:", preferredStyle: .alert)
        
        alert.addTextField {
            (textField) in
            textField.text = player?.name
            textField.placeholder = "Player Name"
        }
        
        alert.addTextField {
            (textField) in
            textField.text = player?.age
            textField.placeholder = "Player Age"
        }
        
        alert.addTextField {
            (textField) in
            textField.text = player?.height
            textField.placeholder = "Player Height"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let playerName = alert?.textFields![0].text
            let playerAge = alert?.textFields![1].text
            let playerHeight = alert?.textFields![2].text
            
            if let player = player{
                player.name = playerName
                player.age = playerAge
                player.height = playerHeight
                player.sport = self.sport
            }else{
                let player = Player(context: self.context)
                player.name = playerName
                player.age = playerAge
                player.height = playerHeight
                player.sport = self.sport
            }
            
            
            self.saveContext()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
