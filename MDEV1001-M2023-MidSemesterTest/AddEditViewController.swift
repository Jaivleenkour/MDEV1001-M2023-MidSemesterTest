//
//  AppDelegate.swift
//  MDEV1001-M2023-MidSemesterTest
//
//  Created by Jaivleen Kour on 2023-06-24.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController, UIDocumentPickerDelegate
{
    // UI References
    @IBOutlet weak var AddEditTitleLabel: UILabel!
    @IBOutlet weak var UpdateButton: UIButton!
    
    // Sports Team Outlets
    
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var gameTypeTextField: UITextField!
    @IBOutlet weak var coachTextField: UITextField!
    @IBOutlet weak var captainTextField: UITextField!
    @IBOutlet weak var playersTextField: UITextField!
    @IBOutlet weak var homeVenueTextField: UITextField!
    @IBOutlet weak var leagueTextField: UITextField!
    @IBOutlet weak var websiteUrlTextField: UITextField!
    @IBOutlet weak var championshipWonTextField: UITextField!
    @IBOutlet weak var foundedYearTextField: UITextField!
    
    var sportsTeam: SportsTeam?
    var dataViewController: DataViewController?
    var sportsteamLogo: UIImage?
    var checkImagePickFromEdit = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.teamLogo.layer.borderColor = UIColor.black.cgColor
        self.teamLogo.layer.borderWidth = 2
        
        if let sportsTeam = sportsTeam
        {
            // Edit existing team
            teamNameTextField.text = sportsTeam.teamname
            gameTypeTextField.text = sportsTeam.gametype
            coachTextField.text = sportsTeam.coach
            captainTextField.text = sportsTeam.captain
            playersTextField.text = sportsTeam.players
            homeVenueTextField.text = sportsTeam.homevenue
            leagueTextField.text = sportsTeam.league
            websiteUrlTextField.text = sportsTeam.websiteurl
            championshipWonTextField.text = "\(sportsTeam.championshipwon)"
            foundedYearTextField.text = "\(sportsTeam.foundedyear)"
            
            if let imageData = sportsTeam.logourl, let image = UIImage(data: imageData) {
                teamLogo.image = image
                }
        }
        else
        {
            //Add New Sports Team UI
            AddEditTitleLabel.text = "Add Sports Team"
            UpdateButton.setTitle("Add", for: .normal)
        }
    }
    
    @IBAction func CancelButton_Pressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UpdateButton_Pressed(_ sender: UIButton)
    {
        // Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        // Retrieve the managed object context
        let context = appDelegate.persistentContainer.viewContext
        dataViewController?.sportsteamLogo = sportsteamLogo
        

        if let sportsTeam = sportsTeam
        {
            // Editing existing movie
            sportsTeam.teamname = teamNameTextField.text
            sportsTeam.gametype = gameTypeTextField.text
            sportsTeam.coach = coachTextField.text
            sportsTeam.captain = captainTextField.text
            sportsTeam.players = playersTextField.text
            sportsTeam.homevenue = homeVenueTextField.text
            sportsTeam.league = leagueTextField.text
            sportsTeam.websiteurl = websiteUrlTextField.text
            sportsTeam.championshipwon = Int16(championshipWonTextField.text ?? "") ?? 0
            sportsTeam.foundedyear = Int16(foundedYearTextField.text ?? "") ?? 0
            
            if checkImagePickFromEdit == true{
                sportsTeam.logourl = sportsteamLogo?.jpegData(compressionQuality: 1.0)
            }
            else{
                let imageData = sportsTeam.logourl
                sportsTeam.logourl = imageData
            }
          
           
        } else {
            // Creating a new sport team
            let newSportsTeam = SportsTeam(context: context)
            
            newSportsTeam.teamname = teamNameTextField.text
            newSportsTeam.gametype = gameTypeTextField.text
            newSportsTeam.coach = coachTextField.text
            newSportsTeam.captain = captainTextField.text
            newSportsTeam.players = playersTextField.text
            newSportsTeam.homevenue = homeVenueTextField.text
            newSportsTeam.league = leagueTextField.text
            newSportsTeam.websiteurl = websiteUrlTextField.text
            newSportsTeam.championshipwon = Int16(championshipWonTextField.text ?? "") ?? 0
            newSportsTeam.foundedyear = Int16(foundedYearTextField.text ?? "") ?? 0
            newSportsTeam.logourl = sportsteamLogo?.jpegData(compressionQuality: 1.0)
            
        }

        // Save the changes in the context
        do {
            try context.save()
            dataViewController?.fetchData()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to save data: \(error)")
            
        }
    }
    @IBAction func uploadImageButton(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)

    }
    
  
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: selectedFileURL.path) {
            if let imageData = fileManager.contents(atPath: selectedFileURL.path), let image = UIImage(data: imageData) {
                teamLogo.image = image
                sportsteamLogo = image
               if AddEditTitleLabel.text == "Edit Sports Team"
                {
                   checkImagePickFromEdit = true
               }
                else{
                    checkImagePickFromEdit = false
                }
                
            } else {
                print("Failed to read image data from URL: \(selectedFileURL)")
            }
        } else {
            print("Selected file does not exist at URL: \(selectedFileURL)")
        }
    }

    
}
