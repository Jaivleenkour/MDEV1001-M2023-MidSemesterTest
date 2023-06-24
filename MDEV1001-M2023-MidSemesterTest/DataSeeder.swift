//
//  AppDelegate.swift
//  MDEV1001-M2023-MidSemesterTest
//
//  Created by Jaivleen Kour on 2023-06-24.
//

import Foundation
import UIKit
import CoreData

func seedData() {
    guard let url = Bundle.main.url(forResource: "sportsTeam", withExtension: "json") else {
        print("JSON file not found.")
        return
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error loading movies data: \(error)")
            return
        }
        
        guard let data = data else {
            print("Error: No data received.")
            return
        }
        
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("AppDelegate not found.")
                return
            }
        
            
            let context = appDelegate.persistentContainer.viewContext
            
            for jsonObject in jsonArray ?? [] {
                let sportsTeam = SportsTeam(context: context)
                
                sportsTeam.teamname = jsonObject["teamName"] as? String
                sportsTeam.gametype = jsonObject["gameType"] as? String
                sportsTeam.coach = jsonObject["coach"] as? String
                sportsTeam.captain = jsonObject["captain"] as? String
                sportsTeam.players = jsonObject["players"] as? String
                sportsTeam.homevenue = jsonObject["homeVenue"] as? String
                sportsTeam.league = jsonObject["league"] as? String
                sportsTeam.championshipwon = jsonObject["championshipsWon"] as? Int16 ?? 0
                sportsTeam.foundedyear = jsonObject["foundedYear"] as? Int16 ?? 0
                sportsTeam.websiteurl = jsonObject["websiteURL"] as? String
                
                if let imageUrlString = jsonObject["logoURL"] as? String, let imageUrl = URL(string: imageUrlString) {
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        sportsTeam.logourl = imageData
                    } else {
                        print("Failed to load image data for movie: \(sportsTeam.teamname ?? "")")
                    }
                }
                
                // Save the context after each movie is created
                do {
                    try context.save()
                } catch {
                    print("Failed to save movie: \(error)")
                }
            }
            
            print("Data seeded successfully.")
        } catch {
            print("Failed to read JSON file: \(error)")
        }
    }
    
    task.resume()
}

func deleteAllData() {
    let persistentContainer = NSPersistentContainer(name: "MDEV1001_M2023_MidSemesterTest")
    persistentContainer.loadPersistentStores { _, error in
        guard error == nil else {
            print("Failed to load persistent stores: \(error!)")
            return
        }
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SportsTeam")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All data deleted successfully.")
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
}
    
