//
//  AddTableViewController.swift
//  Assignment3
//
//  Created by apple on 2018/11/2.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase

class AddTableViewController: UITableViewController {
    
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var parcel = Parcel()

    
    @IBOutlet weak var parcelNumberTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmButton(_ sender: Any) {
        
        var valid = false
        
        var dataList1 = [String]()
        let userID = (Auth.auth().currentUser?.uid)!
        let userRef1 = databaseRef.child("users").child("\(userID)")
        userRef1.observeSingleEvent(of: .value){(snapshot) in
            let value2 = snapshot.value as? NSDictionary
            if value2 != nil{
            
                for (_,valuedata) in value2!{
                    var dataList2 = [String]()
                    let value3 = valuedata as! NSDictionary
                    
                    for (_, valuedata2) in value3{
                        dataList2.append(valuedata2 as! String)
                    }
                    
                    dataList1.append(dataList2[0])
                }
 
                var valid2 = true
                for data in dataList1{
                    if data == self.parcelNumberTextField.text!{
                        self.displayErrorMessage("You already have this package!")
                        valid2 = false
                    }
                }
                if valid2{
                    valid = true
                }
            }
            else{
                valid = true
            }
          
            if self.parcelNumberTextField.text == ""{
                self.displayErrorMessage("Please enter a package number")
                valid = false
            }
            
            if valid{
                
                let userRef = self.databaseRef.child("package").child("\(self.parcelNumberTextField.text!)").child("information")
                
                userRef.observeSingleEvent(of: .value){(snapshot) in
                    let value2 = snapshot.value as? NSDictionary
                    if value2 != nil{
                        var dataList = [String]()
                        
                        for (_,valuedata) in value2!{
                            dataList.append(valuedata as! String)
                        }
                        
                        self.parcel.parcelNumber = dataList[1]
                        self.parcel.sender = dataList[7]
                        self.parcel.senderLocation = dataList[3]
                        self.parcel.senderPostcode = dataList[6]
                        self.parcel.senderState = dataList[10]
                        self.parcel.receiver = dataList[0]
                        self.parcel.receiverLocation = dataList[12]
                        self.parcel.receiverPostcode = dataList[9]
                        self.parcel.receiverState = dataList[2]
                        self.parcel.status = dataList[8]
                        
                        let uuid = UUID().uuidString
                        
                        self.databaseRef.child("users").child("\(userID)").child("\(uuid)").updateChildValues(["ParcelNumber": "\(self.parcelNumberTextField.text!)", "Sender":"\(self.parcel.sender!)", "SenderLocation": "\(self.parcel.senderLocation!)", "SenderPostcode": "\(self.parcel.senderPostcode!)", "SenderState": "\(self.parcel.senderState!)", "Receiver": "\(self.parcel.receiver!)", "ReceiverLocation": "\(self.parcel.receiverLocation!)", "ReceiverPostcode": "\(self.parcel.receiverPostcode!)", "ReceiveState": "\(self.parcel.receiverState!)", "Status":"\(self.parcel.status!)"])
                        
                        self.parcelNumberTextField.text = ""
                        self.tabBarController?.selectedIndex = 0
                    }
                    else{
                        self.displayErrorMessage("Can not find this package!")
                    }
                }
            }
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
  
        parcelNumberTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Moodle tutorial
    func displayErrorMessage(_ errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
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
