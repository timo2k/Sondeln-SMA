//
//  MainMenuViewController.swift
//  sondeln-sma
//
//  Created by Timo on 02.09.17.
//  Copyright © 2017 Timo. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainMenuViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    // Um eine View zu Schließen und aus dem Speicher zu löschen
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Fehler beim Ausloggen passiert: %@", signOutError)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
            if let username = user.displayName {
                usernameLabel.text = "Hallo \(username)"
            } else {
                usernameLabel.text = "Hallo du Sack!"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
