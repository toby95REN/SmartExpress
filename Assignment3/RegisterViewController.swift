//
//  RegisterViewController.swift
//  Assignment3
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBAction func returnButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        }
    
    @IBOutlet weak var registerButton: UIButton!
    //Moodle
    @IBAction func regisgerButton(_ sender: Any){
        
        guard let password = passwordTextField.text else{
            displayErrorMessage("Please enter a password")
            return
        }
        
        guard let password2 = passwordAgainTextField.text else{
            displayErrorMessage("Please reenter a password")
            return
        }
        
        guard let email = emailTextField.text else{
            displayErrorMessage("Please enter an email address")
            return
        }
        
        if password == password2{
            Auth.auth().createUser(withEmail: email, password: password){(user, error) in
                if error != nil{
                    self.displayErrorMessage(error!.localizedDescription)
                    return
                }
            }
        }
        else{
            displayErrorMessage("Please reenter the same password")
            return
        }
    }
    
    //Moodle
    func displayErrorMessage(_ errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Moodle
        handle = Auth.auth().addStateDidChangeListener({(auth, user) in
            if user != nil{
                self.performSegue(withIdentifier: "loginSegue1", sender: nil)
            }
        })
        
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
