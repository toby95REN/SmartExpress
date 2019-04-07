//
//  EditProfileTableViewController.swift
//  Assignment3
//
//  Created by apple on 2018/11/2.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController {
    
    var test = "https://firebasestorage.googleapis.com/v0/b/ass3-99fe9.appspot.com/o/content.jpg?alt=media&token=a86a8dc7-ff4e-4bdf-b1db-fc9708ce5fcb"
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var photoURLTextField: UITextField!

    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmButton(_ sender: Any) {
        
        var valid = false
        if (displayNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || photoURLTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            valid = false
            self.displayMessage("Please enter a name or url", "Error")
        }
        else{
            valid = true
        }
        
        if displayNameTextField.text!.count > 20{
            valid = false
            self.displayMessage("Name must have less than 20 character", "Error")
        }
        
        if valid{
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            
            changeRequest?.displayName = displayNameTextField.text
            changeRequest?.photoURL = URL(string: photoURLTextField.text!)

            changeRequest?.commitChanges { (error) in
                //Yike Ren, teammate
                CBToast.showToastAction(message: "You have changed your display name and photo")
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            self.displayMessage("Invalid input", "Error")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.layer.cornerRadius = 10
        tableView.allowsSelection = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayNameTextField.text = ""
        photoURLTextField.text  = ""
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Moodle
    func displayMessage(_ errorMessage: String, _ title: String){
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
