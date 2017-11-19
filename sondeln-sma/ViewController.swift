//
//  ViewController.swift
//  sondeln-sma
//
//  Created by Timo on 02.09.17.
//  Copyright © 2017 Timo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var signupMode = false
    
    
    @IBAction func topTapped(_ sender: Any) {
        // Einloggen oder Registrieren
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if signupMode {
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if let error = error {
                            self.presentAlert(title: "Fehler beim Registrieren", alert: error.localizedDescription)
                        } else {
                            if let user = user {
                                Database.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                                
                                self.performSegue(withIdentifier: "goToMenu", sender: nil)
                            }
                        }
                    }
                } else {
                    // LOGIN
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if let error = error {
                            self.presentAlert(title: "Fehler beim Einloggen", alert: error.localizedDescription)
                        } else {
                            print("Login hat funktioniert!!!!!!!!!!!!!!!!! ::D:D:D:D:D:D::D:D:D:D:D:D:D:D:D")
                            self.performSegue(withIdentifier: "goToMenu", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    // Alert in Funktion gebaut
    func presentAlert(title:String ,alert:String) {
        let alertVC = UIAlertController(title: title, message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func bottomTapped(_ sender: Any) {
        // Zu Login/Registrierung wechseln
        
        if signupMode {
            // Zu Registrierung wechseln
            signupMode = false
            topButton.setTitle("Einloggen", for: .normal)
            bottomButton.setTitle("einen neuen Account anlegen", for: .normal)
        } else {
            // Zu Login wechseln
            signupMode = true
            topButton.setTitle("Registrieren", for: .normal)
            bottomButton.setTitle("zu Login wechseln", for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

