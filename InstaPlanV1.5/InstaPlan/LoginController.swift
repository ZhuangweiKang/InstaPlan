//
//  LoginController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/10/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginController: UIViewController, GIDSignInUIDelegate{


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var done_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        done_btn.layer.borderWidth = 1
        done_btn.layer.borderColor = UIColor.black.cgColor
        done_btn.layer.cornerRadius = 5
        print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)
        
        
       GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func forget_password(_ sender: Any) {
        let alert = UIAlertController(title: "Forget Password", message: "", preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.placeholder = "Email"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "New Password"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let email = alert?.textFields?[0]
            let password = alert?.textFields?[1]
            if CoreDataController().signupCheck(email_address: (email?.text)!){
                let error = UIAlertController(title: "Invalid Email", message: "This email address is invalid.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in }
                
                error.addAction(okAction)
                self.present(error, animated: true, completion: nil)
            }
            else{
                CoreDataController().changePassword(email: (email?.text)!, newPassword: (password?.text)!)
            }
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Mark: Facebook login here
    @IBAction func fbLogin(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil{
                return
            }
            else{
                self.returnFaceBookData()
            }
        }
    }
    
    
    func returnFaceBookData() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken:accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil{
                print("Facebook login error", error ?? "")
                return
            }
            print("Successfully login with our user.", user ?? "")
            let usr_email = FIRAuth.auth()?.currentUser?.email!
            let usr_name = FIRAuth.auth()?.currentUser?.displayName!
            if(CoreDataController().signupCheck(email_address: usr_email!)){
                CoreDataController().storeUser(user_name: usr_name!, email_address: usr_email!, password: "")
            }
            self.jumpToMainPage()
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if(err != nil){
                print("failed to request graph request")
                return
            }
            print(result ?? "")
           
            
        }
    }

    //Mark: Google Login here
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Mark: InstaPlan Login
    @IBAction func instaPlanLogin(_ sender: Any) {
        
        
        let email = emailTextField.text
        let psd = passwordTextField.text
        
        if email == nil || email == "" {
            inputalert(alert_content: "Please tell me your email address.")
        }
        else if psd == nil || psd == "" {
            inputalert(alert_content: "Please input your password.")
        }
        else{
            //check user information and store it
            if CoreDataController().loginCheck(email_address: email!, psd: psd!) {
                self.jumpToMainPage()
            }
            else{
                inputalert(alert_content: "The email address or password you input is incorrect, please try again.")
            }
        }

    }
    
    func inputalert(alert_content: String) {
        let alert = UIAlertController(title: "Login alert", message: alert_content, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func jumpToMainPage() {
        let mainpage = UIStoryboard(name: "HomePage", bundle: nil)
        let vc = mainpage.instantiateInitialViewController()
        show(vc!, sender: self)
    }
}
