//
//  SportTableViewController.swift
//  SportApp
//
//  Created by admin on 29/12/2021.
//

import UIKit
import CoreData

class SportTableViewController: UITableViewController, Delegate, DelegateBack {
    func back(pressed: PlayerTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    let imageViewController = UIImagePickerController()
    
    //list to store the sport name
    var sportsList: [Sport] = []
    var isSelected: Sport!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllData()
    }
    
    //add new sport
    @IBAction func addNewSport(_ sender: UIBarButtonItem) {
        sportAlert(title: "Add New Sport", mesg: "Enter Sport Name", sport: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sportsList.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportTableViewCell
        
        let sport = sportsList[indexPath.row]
        cell.configure(sport.name!, sport.image)
        cell.delegate = self 

        //Configure the cell...

        return cell
    }
    
    //click on the whole cell will go to player page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToPlayerList", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextPage = segue.destination as! PlayerTableViewController
        let indexPath = sender as! IndexPath
        let sport = sportsList[indexPath.row]
        
        nextPage.title = sport.name?.capitalized
        nextPage.sport = sport
    }
    
    //click on the edit sign the edit alert will show
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        sportAlert(title: "Edit Sport", mesg: "Enter a New Sport Name", sport: sportsList[indexPath.row])
    }
    
    //remove the sport
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let sportItem = sportsList[indexPath.row]
        context.delete(sportItem)
        
        saveContext()
        fetchAllData()
    }
    

    // MARK: - Function Section
    
    func fetchAllData(){
        
        do{
            sportsList = try context.fetch(Sport.fetchRequest())
            
        }catch{
            print("Something went error")
        }
        tableView.reloadData()
    }
    
    //show alert function to add or edit a sport name
    func sportAlert(title: String, mesg: String, sport: Sport?){
        let alert = UIAlertController(title: title, message: mesg, preferredStyle: .alert)
        
        alert.addTextField {
            (textField) in
            textField.text = sport?.name
            textField.placeholder = "Sport Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let sportName = alert.textFields![0].text
            
            if let sport = sport {
                sport.name = sportName
            }else {
                let sport = Sport(context: self.context)
                sport.name = sportName
            }
            
            self.saveContext()
            self.fetchAllData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func updateImage(_ cell: SportTableViewCell) {
        let selectImage = tableView.indexPath(for: cell)?.row ?? 0
        isSelected = sportsList[selectImage]
        
        imageViewController.delegate = self
        present(imageViewController, animated: true, completion: nil)
    }
}
    // MARK: - Image View
    
    extension SportTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage{
                isSelected.image = image.pngData()
                saveContext()
            }
            self.fetchAllData()
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
 


