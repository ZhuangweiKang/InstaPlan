//
//  SignupController.swift
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

class SignupController: UIViewController, GIDSignInUIDelegate{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var psdTextField: UITextField!
    
    @IBOutlet weak var fb_btn: UIButton!
    
    @IBOutlet weak var google_btn: UIButton!
    
    @IBOutlet weak var done_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        psdTextField.layer.cornerRadius = 5
        fb_btn.layer.cornerRadius = 5
        google_btn.layer.cornerRadius = 5
        done_btn.layer.borderColor = UIColor.black.cgColor
        done_btn.layer.borderWidth = 1
        done_btn.layer.cornerRadius = 5
        GIDSignIn.sharedInstance().uiDelegate = self

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
    @IBAction func instaPlanSignup(_ sender: Any) {
        let usrname = usernameTextField.text!
        let email = emailTextField.text!
        let psd = psdTextField.text!
        
        if usrname == ""
        {
            inputalert(alert_content: "Please tell me your user name.")
        }
        else if email == "" {
            inputalert(alert_content: "Please tell me your email address.")
        }
        else if psd == "" {
            inputalert(alert_content: "Please input your password.")
        }
        else{
            //check user information and store it
            if CoreDataController().signupCheck(email_address: email) {
                CoreDataController().storeUser(user_name: usrname, email_address: email, password: psd)
                print("Then jump to the main page")
                self.jumpToMainPage()
            }
            else{
                inputalert(alert_content: "This email address has been registered or something wrong. Please try again.")
            }
        }
    }
    
    func inputalert(alert_content: String) {
        let alert = UIAlertController(title: "Sign up alert", message: alert_content, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func jumpToMainPage() {
        let mainpage = UIStoryboard(name: "HomePage", bundle: nil)
        let vc = mainpage.instantiateInitialViewController()
        show(vc!, sender: self)
    }
}
