//
//  DetailTableViewController.swift
//  Assignment3
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import MapKit
import CoreLocation

class DetailTableViewController: UIViewController,MKMapViewDelegate {
    
    
    @IBOutlet weak var confirmButton: UIButton!
    var userID = Auth.auth().currentUser!.uid
    var databaseRef = Database.database().reference()
    
    //action for confirm the receiving of package,after recieve a package will goback to list of package
    @IBAction func confirmAction(_ sender: Any) {
        let userRef = databaseRef.child("package").child((parcel?.parcelNumber)!).child("information")
        let userRef2 = databaseRef.child("users").child(Auth.auth().currentUser!.uid).child((parcel?.uniqueId)!)
        userRef.updateChildValues(["Status": "1"])
        userRef2.updateChildValues(["Status": "1"])
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var ignore: UISwitch!
    var parcel : Parcel?
    var iconTemp: UIImage?
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    var tempLatitude: Double = 0.0
    var tempLongitude: Double = 0.0
    var lat: Double = 0.0
    var long: Double = 0.0
    var speedf: Double = 0.0
    var myRoute: MKRoute?
    @IBOutlet weak var packageNumber: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var sendAddress: UILabel!
    @IBOutlet weak var RecName: UILabel!
    @IBOutlet weak var RecAddress: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var estimateTime: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var trackMap: MKMapView!
    @IBOutlet weak var insideImage: UIImageView!
    //initialize the notification center
    let notificationCenter = UNUserNotificationCenter.current()
    //below are flags for alert and door open
    var hasAlert = false
    var hasAlert2 = false
    var issafe = true
    var isopen = true;
    //initialize of the controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // get the notification requirements
        notificationCenter.requestAuthorization(options: [.badge,.alert,.sound]) {(granted,error) in}
        // put the controller into background then we can send the notification on background
        var bgTask = UIBackgroundTaskIdentifier()
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(bgTask)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackMap.delegate = self as MKMapViewDelegate
        iconTemp = UIImage(named: "delivery.png")
        self.ignore.isOn = false
        var errocheck = true;
        packageNumber.text = parcel?.parcelNumber
        senderName.text = parcel?.sender
        sendAddress.text = parcel?.senderLocation
        RecName.text = parcel?.receiver
        RecAddress.text = parcel?.receiverLocation
        let packNum = (parcel?.parcelNumber)!
        let status = (parcel?.status)!
        //load the data from firebase. for different status of package will load different data, 1 for delivered and 0 for on the way
        if status == "1"{
            self.confirmButton.setTitle("Already Delivered!", for: .normal)
            self.confirmButton.setTitleColor(UIColor.red, for: .normal)
            //if the package is delivered, disable the button and swich
            self.confirmButton.isEnabled = false
            self.ignore.isEnabled = false
            self.speed.text = "Already Delivered!"
            self.temperature.text = "Already Delivered!"
            self.estimateTime.text = "Already Delivered!"
            let userRef5 = databaseRef.child("package").child("\(packNum)").child("image")
            //load the last image captured by camera of inside the box
            userRef5.queryLimited(toLast: 1).observeSingleEvent(of: .value){ (snapshot) in
                let value = snapshot.value as? NSDictionary
                if value == nil {
                    self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                }else{
                    for(_,valuedata) in value! {
                        let dataset = valuedata as! NSDictionary
                        for(_,value2) in dataset {
                            let imageURL = value2 as! String
                            self.downloadImageUserFromFirebase(Link:imageURL)
                        }
                    }
                }
            }
            //add a route to sender address to receiver address
            addRoute(address: "\((parcel?.senderLocation)!), \((parcel?.senderState)!) \((parcel?.senderPostcode)!)", address2: "\((parcel?.receiverLocation)!), \((parcel?.receiverState)!) \((parcel?.receiverPostcode)!)")
            
            
        }else{
            //load image for on the way package
            let userRef9 = databaseRef.child("package").child("\(packNum)").child("information")
            userRef9.queryLimited(toLast: 1).observeSingleEvent(of: .value){ (snapshot) in
                let value = snapshot.value as? NSDictionary
                if value == nil {
                    self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                }else{
                    //if the pacakage is not belong to this user, the user can only look through the information and can not confirm the recieve
                    for(_,valuedata) in value! {
                        let dataset = valuedata as! String
                        if dataset != Auth.auth().currentUser!.uid {
                            self.confirmButton.isEnabled = false
                            self.confirmButton.setTitle("Only Receiver Can Confirm", for: .normal)
                            self.confirmButton.setTitleColor(UIColor.red, for: .normal)
                        }
                    }
                }
            }
            //check if the pacakge has information, if not display an alert
            let userRef = databaseRef.child("package").child("\(packNum)")
            userRef.queryLimited(toLast: 1).observe(DataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if value == nil {
                    self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                    errocheck = false
                }
            })
            if errocheck {
                //below are all change listener for different data
                let userRef1 = databaseRef.child("package").child("\(packNum)").child("temperature")
                userRef1.queryLimited(toLast: 1).observe(DataEventType.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value == nil {
                        self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                    }else{
                        for(_,valuedata) in value! {
                            let dataset = valuedata as! NSDictionary
                            for(_,value2) in dataset {
                                self.temperature.text = "\(value2 as! String)°C"
                            }
                        }
                    }
                })
                let userRef2 = databaseRef.child("package").child("\(packNum)").child("speed")
                userRef2.queryLimited(toLast: 1).observe(DataEventType.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value == nil {
                        self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                    }else{
                        for(_,valuedata) in value! {
                            let dataset = valuedata as! NSDictionary
                            for(_,value2) in dataset {
                                self.speed.text = "\(value2 as! String) KPH"
                                let speeddouble = Double(value2 as! String)
                                let speedstring = String(format: "%.2f",speeddouble!)
                                self.speedf = Double(speedstring)!
                            }
                        }
                    }
                })
                let userRef6 = databaseRef.child("package").child("\(packNum)").child("cordinate")
                userRef6.queryLimited(toLast: 1).observe(DataEventType.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value == nil {
                        self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                    }else{
                        for(_,valuedata) in value! {
                            
                            let dataset = valuedata as! NSDictionary
                            var count = 0
                            for(_,value2) in dataset {
                                if count == 0 {
                                    self.long = Double(value2 as! String)!
                                    count = count + 1
                                }else{
                                    self.lat = Double(value2 as! String)!
                                }
                            }
                            print("lat: \(self.lat)")
                            print("long: \(self.long)")
                            let fencedAnnotation = FencedAnnotation(newTitle: "\(packNum)",newSubtitle: "Your Package is here!",newLatitude: self.lat,newLongitude: self.long)
                            self.trackMap.removeAnnotations(self.trackMap.annotations)
                            self.trackMap.addAnnotation(fencedAnnotation)
                            self.focus(location: fencedAnnotation)
                            self.reverseAddress(address: "\((self.parcel?.receiverLocation)!), \((self.parcel?.receiverState)!) \((self.parcel?.receiverPostcode)!)")
                            
                            self.reverseAddress2(address: "\((self.parcel?.senderLocation)!), \((self.parcel?.senderState)!) \((self.parcel?.senderPostcode)!)")
                            
                            
                        }
                    }
                })
                let userRef5 = databaseRef.child("package").child("\(packNum)").child("image")
                userRef5.queryLimited(toLast: 1).observe(.value, with: { (snapshot) in
                    
                    
                    let value = snapshot.value as? NSDictionary
                    if value == nil {
                        self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                    }else{
                        for(_,valuedata) in value! {
                            let dataset = valuedata as! NSDictionary
                            for(_,value2) in dataset {
                                let imageURL = value2 as! String
                                //print("\(imageURL)")
                                //let storageRef = Storage.storage()
                                self.downloadImageUserFromFirebase(Link:imageURL)
                            }
                        }
                    }
                })
                let userRef4 = databaseRef.child("package").child("\(packNum)").child("safe")
                userRef4.queryLimited(toLast: 1).observe(DataEventType.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value == nil {
                        self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                    }else{
                        for(_,valuedata) in value! {
                            let dataset = valuedata as! NSDictionary
                            for(_,value2) in dataset {
                                self.issafe = value2 as! Bool
                                if !self.issafe {
                                    if !self.hasAlert2 {
                                        if !self.ignore.isOn {
                                            CBToast.showToastAction(message: "Package open without Password!")
                                            self.notificationCreated(message: "Your pacakage has been opened without password, please check it!", title: "Dangerous!")
                                            self.hasAlert2 = true
                                        }
                                    }
                                }else{
                                    self.hasAlert2 = false
                                    if !self.isopen{
                                        if !self.hasAlert {
                                            if self.issafe {
                                                if !self.ignore.isOn {
                                                    CBToast.showToastAction(message: "Package open!")
                                                    self.notificationCreated(message: "Your pacakage has been opened!", title: "Package Open Reminder")
                                                    self.hasAlert = true
                                                }
                                            }
                                        }
                                    }else{
                                        self.hasAlert = false
                                    }
                                }
                            }
                        }
                    }
                })
                let userRef3 = databaseRef.child("package").child("\(packNum)").child("open")
                userRef3.queryLimited(toLast: 1).observe(DataEventType.value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value == nil {
                        self.displayMessage("There is no Data for this Package, Contact us for further Detail!", "Warning")
                    }else{
                        for(_,valuedata) in value! {
                            let dataset = valuedata as! NSDictionary
                            for(_,value2) in dataset {
                                let open = value2 as! Bool
                                self.isopen = open
                            }
                        }
                    }
                })
            }
        }
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //display an alert with title and message, get the code from tutorial conde
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    //create a notification with message and title
    func notificationCreated(message: String,title: String){
        let content = UNMutableNotificationContent()
        content.body =  message
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest.init(identifier: title,content: content,trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request){ (error) in
        }
    }
    
    //function for downloading image from firebase with link provided
    func downloadImageUserFromFirebase(Link:String) {
        let storageRef = Storage.storage().reference(forURL: Link)
        storageRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            if error == nil {
                
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        self.insideImage.image = img
                        print("got imagedata \(String(describing: imgData))")
                    }
                }
            } else {
                print("ERROR DOWNLOADING IMAGE : \(String(describing: error))")
            }
        }
    }
    
    //add a route on map with address provided, address one is start and address2 is end point
    func addRoute(address: String,address2: String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            geoCoder.geocodeAddressString(address2) { (placemarks, error) in
                guard
                    let placemarks2 = placemarks,
                    let location2 = placemarks2.first?.location
                    else {
                        // handle no location found
                        return
                }
                let directionsRequest = MKDirectionsRequest()
                let markFirstPoint = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
                let markSecondPoint = MKPlacemark(coordinate: location2.coordinate, addressDictionary: nil)
                directionsRequest.source = MKMapItem(placemark: markSecondPoint)
                directionsRequest.destination = MKMapItem(placemark: markFirstPoint)
                directionsRequest.transportType = MKDirectionsTransportType.automobile
                let directions = MKDirections(request: directionsRequest)
                directions.calculate { (response:MKDirectionsResponse!, error: Error!) -> Void in
                    if error == nil {
                        self.myRoute = response.routes[0]
                        self.trackMap.add((self.myRoute?.polyline)!)
                    }
                }
                let span = MKCoordinateSpanMake(0.08, 0.08)
                let region = MKCoordinateRegion(center: (location2.coordinate), span: span)
                self.trackMap.centerCoordinate = (location2.coordinate)
                self.trackMap.setRegion(region, animated: true)
                
                let fencedAnnotation = FencedAnnotation(newTitle: "Sender",newSubtitle: "package's sender location",newLatitude: location.coordinate.latitude,newLongitude: location.coordinate.longitude)
                self.trackMap.addAnnotation(fencedAnnotation)
               
               
                let fencedAnnotation2 = FencedAnnotation(newTitle: "Destination",newSubtitle: "package's Destination",newLatitude: location2.coordinate.latitude,newLongitude: location2.coordinate.longitude)
                self.trackMap.addAnnotation(fencedAnnotation2)
            }
        }
    }
    
    //map delegate for creating a route
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let myLineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
        myLineRenderer.strokeColor = UIColor.red
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    //below two reveraddress method will reverse a real word address to cordinate with longtitude and latitude
    func reverseAddress(address: String){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            print("latitude: \(location.coordinate.latitude)")
            self.tempLatitude = location.coordinate.latitude
            self.tempLongitude = location.coordinate.longitude
            let fencedAnnotation = FencedAnnotation(newTitle: "Destination",newSubtitle: "package's Destination",newLatitude: self.tempLatitude,newLongitude: self.tempLongitude)
            self.trackMap.addAnnotation(fencedAnnotation)
            print(self.tempLatitude)
            print(self.tempLongitude)
            //caculate distance from package location to destination and use the distance to get the estimated time
            let location1 = CLLocation(latitude: CLLocationDegrees(self.lat), longitude: CLLocationDegrees(self.long))
            let kilometers = String(format: "%.2f",location1.distance(from: location)/1000)
            let kmdouble = Double(kilometers)
            let time = String(format: "%.2f",kmdouble!/self.speedf)
            self.estimateTime.text = "\(time) hours"
        }
    }
    
    func reverseAddress2(address: String){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            print("latitude: \(location.coordinate.latitude)")
            self.tempLatitude = location.coordinate.latitude
            self.tempLongitude = location.coordinate.longitude
            let fencedAnnotation = FencedAnnotation(newTitle: "Sender",newSubtitle: "package's Sender address",newLatitude: self.tempLatitude,newLongitude: self.tempLongitude)
            self.trackMap.addAnnotation(fencedAnnotation)
        }
    }
    
    
    //map delegate for customrize the annotation.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        annotationView.canShowCallout = true
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        var senderimage: UIImage?
        if(annotation.title == "Sender"){
            senderimage = UIImage(named: "tart.png")
        }else if(annotation.title == "Destination"){
            senderimage = UIImage(named: "end.png")
        }else{
            senderimage = UIImage(named: "delivery.png")
        }
        senderimage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.image = resizedImage
        return annotationView
    }
    
    //focus on map
    func focus(location: MKAnnotation) {
        let span = MKCoordinateSpanMake(0.003, 0.003)
        let region = MKCoordinateRegion(center: (location.coordinate), span: span)
        self.trackMap.centerCoordinate = (location.coordinate)
        self.trackMap.setRegion(region, animated: true)
    }
    
    //load the image file with provided link from firebase
    func loadImageData(fileName: String) -> UIImage? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image: UIImage?
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            let fileData = fileManager.contents(atPath: filePath)
            image = UIImage(data: fileData!)
        }        
        return image
    }
    
}
