//
//  AccountTableViewController.swift
//  Assignment3
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase

class UICell1: UITableViewCell{
    
    //O-mkar, Computer Program, (stackoverflow, 2018)
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width - 20 // get 80% width here
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            
            super.frame = frame
            
        }
    }
}

class AccountTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var changePassword: UILabel!
    @IBOutlet weak var de: UILabel!
    
    
    @IBAction func logoutAccount(_ sender: Any) {
    
        do {
            try Auth.auth().signOut()
            
        }
        catch {
        }
        
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
        //self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    //creeperspeak, software programm (2018)
    func forgotPasswordTapped() {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = UIImage(named: "images")
        displayLabel.text = "Anonymous"
        emailLabel.text = Auth.auth().currentUser?.email
        
        if Auth.auth().currentUser?.displayName == nil && Auth.auth().currentUser?.displayName?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            displayLabel.text = "Anonymous"
        }
        else{
            displayLabel.text = Auth.auth().currentUser?.displayName?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var url = URL(string: "https://firebasestorage.googleapis.com/v0/b/ass3-99fe9.appspot.com/o/content1.jpg?alt=media&token=ea90e3fa-df87-4c82-a655-b3184d6c8119")
        url = Auth.auth().currentUser?.photoURL
        
        if url != nil && url?.absoluteString.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            
            let data = try? Data(contentsOf: url!)
            if data != nil{
                
                imageView.image = UIImage(data: data!)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30
        case 1:
            return 5
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row{
            case 0: self.performSegue(withIdentifier: "changePasswordSegue", sender: nil)
            case 1: self.performSegue(withIdentifier: "editProfileSegue", sender: nil)
            case 2: print("b")
            default: print("c")
            }
        case 2:
            print(234)
        case 3:
            print(345)
        default:
            print(456)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

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
