//
//  AppDelegate.swift
//  MDEV1001-M2023-MidSemesterTest
//
//  Created by Jaivleen Kour on 2023-06-24.
//

import UIKit
import CoreData

class DataViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var sportsTeamArray: [SportsTeam] = []
    var sportsteamLogo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }
    
    func fetchData() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<SportsTeam> = SportsTeam.fetchRequest()
            
            do {
                sportsTeamArray = try context.fetch(fetchRequest)
                tableView.reloadData()
            } catch {
                print("Failed to fetch data: \(error)")
            }
        }
    


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sportsTeamArray.count > 0 {
            return sportsTeamArray.count} else{return 0}
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SportsTeamCell", for: indexPath) as! SportsTeamTableViewCell
            
            let sportsTeam = sportsTeamArray[indexPath.row]
            
            //Show Labels for Team Name, League and Game Type.
            cell.teamNameLabel?.text = sportsTeam.teamname
            cell.leagueAndGameTypeLabel?.text = "League: \(sportsTeam.league!) | Game: \(sportsTeam.gametype!)"
            
            //Fetching the logo of teams
            let imgData = sportsTeam.logourl != nil ? UIImage(data: sportsTeam.logourl!) : nil
            cell.teamLogo?.image = imgData ?? sportsteamLogo
            return cell
            
           
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
    }
    
    // Swipe Left Gesture
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let sportsTeam = sportsTeamArray[indexPath.row]
            ShowDeleteConfirmationAlert(for: sportsTeam) { confirmed in
                if confirmed
                {
                    self.deleteMovie(at: indexPath)
                }
            }
        }
    }
    func ShowDeleteConfirmationAlert(for sportsTeam: SportsTeam, completion: @escaping (Bool) -> Void)
    {
        let alert = UIAlertController(title: "Delete Sports Team", message: "Are you sure you want to delete this team from the list?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteMovie(at indexPath: IndexPath)
    {
        let sportsTeam = sportsTeamArray[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(sportsTeam)
        
        do {
            try context.save()
            sportsTeamArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print("Failed to delete movie: \(error)")
        }
    }
    
    @IBAction func AddButton_Pressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "AddEditSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddEditSegue"
        {
            if let addEditVC = segue.destination as? AddEditViewController
            {
                addEditVC.dataViewController = self
                if let indexPath = sender as? IndexPath
                {
                   // Editing existing movie
                   let sportsTeam = sportsTeamArray[indexPath.row]
                   addEditVC.sportsTeam = sportsTeam
                } else {
                    // Adding new movie
                    addEditVC.sportsTeam = nil
                }
            }
        }
    }
    


}




