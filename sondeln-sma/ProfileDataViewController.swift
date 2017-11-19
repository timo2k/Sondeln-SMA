//
//  ProfileDataViewController.swift
//  sondeln-sma
//
//  Created by Timo on 02.09.17.
//  Copyright © 2017 Timo. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileDataViewController: UIViewController {
    
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func saveTapped(_ sender: Any) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayNameTextField.text
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            if let username = user.displayName {
                displayNameTextField.text = username
            }
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
