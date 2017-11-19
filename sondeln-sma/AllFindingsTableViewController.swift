//
//  AllFindingsTableViewController.swift
//  sondeln-sma
//
//  Created by Timo on 02.09.17.
//  Copyright © 2017 Timo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AllFindingsTableViewController: UITableViewController {
    
    var findingData : [DataSnapshot] = []
    var currentKey:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userId = Auth.auth().currentUser?.uid {
            Database.database().reference().child("findings").child(userId).queryLimited(toLast: 20).observe(.childAdded, with: { (snapshot) in
                
                if self.currentKey == nil {
                    let first = snapshot.key
                    self.currentKey = first
                }
                
                self.findingData.insert(snapshot, at: 0)
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return findingData.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let finding = findingData[indexPath.row]
        
        if let findingDictionary = finding.value as? NSDictionary {
            if let title = findingDictionary["title"] as? String {
                if let cat = findingDictionary["category"] as? String {
                    cell.textLabel?.text = title
                    cell.detailTextLabel?.text = cat
                }
                
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = findingData[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: snapshot)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()

            
            let key = findingData[indexPath.row].key
            
            if let userId = Auth.auth().currentUser?.uid {
                Database.database().reference().child("findings").child(userId).child(key).removeValue()
            }
            findingData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
    
            tableView.endUpdates()
        }
    }
    
    // TODO: Dynamische Intervalle erzeugen um die richtigen Datenpakete beim scrolen nachzuladen
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = findingData.count - 1
        if indexPath.row == lastElement {
            if let userId = Auth.auth().currentUser?.uid {
                Database.database().reference().child("findings").child(userId).queryLimited(toFirst: 31).queryEnding(atValue: currentKey).observe(.childAdded, with: { (snapshot) in
                    
                    self.findingData.insert(snapshot, at: 20)
                    self.tableView.reloadData()
                })
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            if let detailsVC = segue.destination as? DetailViewController {
                if let finding = sender as? DataSnapshot {
                    detailsVC.finding = finding
                }
            }
        }
    }


}
