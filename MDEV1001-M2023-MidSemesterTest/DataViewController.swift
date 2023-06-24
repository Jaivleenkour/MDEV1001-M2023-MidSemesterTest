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
            cell.teamNameLabel?.text = sportsTeam.teamname
            cell.gameTypeLabel?.text = "League: \(sportsTeam.league!) | Game: \(sportsTeam.gametype!)"
            
            
          //  cell.ratingLabel?.text = "\(sportsTeam.criticsrating)"
            let imgData = sportsTeam.logourl != nil ? UIImage(data: sportsTeam.logourl!) : nil
            cell.teamLogo?.image = imgData ?? sportsteamLogo
            return cell
            
           
        }
    


}




