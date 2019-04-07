//
//  ChangePasswordTableViewController.swift
//  Assignment3
//
//  Created by apple on 2018/11/2.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordTableViewController: UITableViewController {
    
    @IBOutlet weak var oldTextField: UITextField!
    @IBOutlet weak var newTextField: UITextField!
    @IBOutlet weak var new2TextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmButton(_ sender: Any) {
        
        var valid = false
        
        let oldPassword = oldTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPassword = newTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let new2Password = new2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (oldPassword?.count)! < 20 && (oldPassword?.count)! > 5 && (newPassword?.count)! < 20 && (newPassword?.count)! > 5 && (new2Password?.count)! < 20 && (new2Password?.count)! > 5 && newPassword! == new2Password!{
            
            valid = true
        }
        
        //adolfosrs, Computer Program, (stackoverflow, 2018)
        if valid{
            
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: (user?.email!)!, password: oldPassword!)
            
            user?.reauthenticate(with: credential, completion: { (error) in
                if error != nil{
                    
                    self.displayMessage("Wrong old password", "Error")
                }
                else{
                    
                    Auth.auth().currentUser?.updatePassword(to: newPassword!) { (error) in
                    }
                    self.oldTextField.text = ""
                    self.newTextField.text = ""
                    self.new2TextField.text = ""
                    CBToast.showToastAction(message: "You have changed your password")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else{
            self.displayMessage("Invalid Password, 1.Password should between 6-20 character. 2. new password should be the same", "Error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        confirmButton.layer.cornerRadius = 10
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        oldTextField.text = ""
        newTextField.text = ""
        new2TextField.text = ""
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
