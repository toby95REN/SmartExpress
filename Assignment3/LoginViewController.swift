//
//  LoginViewController.swift
//  Assignment3
//
//  Created by apple on 2018/10/30.
//  Copyright © 2018年 Monash University. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var backgoundView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var handle: AuthStateDidChangeListenerHandle?
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    //Moodle
    @IBAction func loginAccount(_ sender: Any) {
     
        guard let password = passwordTextField.text else{
            displayErrorMessage("Please enter a password")
            return
            
        }
        guard let email = emailTextField.text else{
            displayErrorMessage("Please enter an email address")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password){(user, error) in
            if error != nil{
                self.displayErrorMessage(error!.localizedDescription)
            }
        }
    }
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerAccount(_ sender: Any) {

    }
    
    //Moodle
    func displayErrorMessage(_ errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //creeperspeak, software programm (2018)
    @IBAction func forgotPasswordButton(_ sender: Any) {
        
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: ", preferredStyle: .alert)
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
        self.navigationController?.isNavigationBarHidden = true
        
        loginButton.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        registerButton.layer.borderWidth = 2
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderColor = UIColor(red: 0.301, green: 0.396, blue: 0.603, alpha: 1).cgColor

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
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        })
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
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
