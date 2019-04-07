//
//  TrackTableViewController.swift
//  Assignment3
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase

class ParcelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var packageNumberLable: UILabel!
    @IBOutlet weak var SenderLable: UILabel!
    @IBOutlet weak var StatusLable: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


class TrackTableViewController: UITableViewController {

    let cellSpacingHeight: CGFloat = 10
    var appDelegate: AppDelegate?
    
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    var parcelList = [Parcel]()
    var parcel = Parcel()
    var packageNumberList = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        tableView.rowHeight = 100
       
        let userID = Auth.auth().currentUser!.uid
        let userRef = databaseRef.child("users").child("\(userID)")
        
        userRef.observe(.value, with:{(snapshot) in
            self.parcelList = [Parcel]()
            let value2 = snapshot.value as? NSDictionary
            if value2 != nil{
                
                for (key,valuedata) in value2!{
                    var parcel = Parcel()
                    parcel.uniqueId = key as? String
                    let dataset = valuedata as! NSDictionary
                    var dataList = [String]()
                    
                    for (_, value) in dataset{
                        dataList.append(value as! String)
                    }
                    
                    parcel.parcelNumber = dataList[0]
                    parcel.sender = dataList[1]
                    parcel.senderLocation = dataList[3]
                    parcel.senderPostcode = dataList[7]
                    parcel.senderState = dataList[5]
                    parcel.receiver = dataList[9]
                    parcel.receiverLocation = dataList[8]
                    parcel.receiverPostcode = dataList[2]
                    parcel.receiverState = dataList[6]
                    parcel.status = dataList[4]
                    self.parcelList.append(parcel)
                    
                }
            }
            self.tableView.reloadData()
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //Moodle
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.parcelList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "parcel", for: indexPath) as! ParcelTableViewCell
        var parcel = parcelList[indexPath.section]
        
        // Configure the cell...
        cell.packageNumberLable.text = parcel.parcelNumber
        cell.SenderLable.text = parcel.sender
        if parcel.status == "1"{
            cell.StatusLable.text = "Delivered"
            cell.StatusLable.textColor = UIColor.red
        }
        else{
            cell.StatusLable.text = "On the way"
        }
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor      = UIColor.black.cgColor
        cell.layer.shadowOffset     = CGSize.zero
        cell.layer.shadowRadius     = 2
        cell.layer.shadowOpacity    = 0.2
        let shadowFrame: CGRect     = cell.layer.bounds
        let shadowPath: CGPath      = UIBezierPath(rect: shadowFrame).cgPath
        cell.layer.shadowPath       = shadowPath
        cell.layer.masksToBounds    = false

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.section).")
        parcel = parcelList[indexPath.section]
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let userID = (Auth.auth().currentUser?.uid)!
            self.databaseRef.child("users").child("\(userID)").child("\((parcelList[indexPath.section].uniqueId)!)").removeValue()
            //self.databaseRef.child("users").child("\(userID)").
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
            parcelList.remove(at: indexPath.section)
            tableView.reloadData()
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "detailSegue") {
            
            let detailTableViewController = segue.destination as! DetailTableViewController
            detailTableViewController.parcel = self.parcel
        }
    }
}
