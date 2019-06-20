//
//  LoginVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin
import SVProgressHUD
import Alamofire

class LoginVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate
{
    
    //-----------------------------
    // MARK: Outlets
    //-----------------------------
    
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    //-----------------------------
    // MARK: Identifiers
    //-----------------------------
    
    var error : NSError?
    var dict : [String : AnyObject]!
    var emailId = String()
    var name = String()
    var timer = Timer()
    
    //-----------------------------
    // MARK: View Life Cycle
    //-----------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        if error != nil{
            print(error ?? "google error")
            return
        }
        
        //adding the delegates
        
        
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        logoutView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    //-----------------------------
    // MARK: Delegate Method
    //-----------------------------
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error
        {
            print("\(error.localizedDescription)")
        } else
        {
            name = user.profile.name
            emailId = user.profile.email
            
            
            UserDefaults.standard.set("SocialMedia", forKey: "loginWith")
            UserDefaults.standard.synchronize()
            LogInAPI()
            // Perform any operations on signed in user here.
            //lbl_txt.text = "Google Sign-In Done"
            
            
        }
    }
    
    //-----------------------------
    // MARK: User Defined Functions
    //-----------------------------
    
    @objc func InternetAvailable()
    {
        SVProgressHUD.dismiss()
        if Connectivity.isConnectedToInternet()
        {
            LogInAPI()
            SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.dismiss()
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large),email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    
                    self.dict = (result as! [String : AnyObject])
                    print(self.dict)
                    self.name = (self.dict["name"] as! String)
                    if (self.dict["email"] as? String) != nil
                    {
                        self.emailId = (self.dict["email"] as! String)
                        self.LogInAPI()
                    }
                    else
                    {
                        Constant.PopUp(Controller: self, title: "Error", message: "Please add email ID to your facebook account")
                    }
                    
                    //UserDefaults.standard.set((self.dict["name"] as! String), forKey: "userName")
                    
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    
    //-----------------------------
    // MARK: Button Actions
    //-----------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLoginWithEmailTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "LoginWithEmailVC") as! LoginWithEmailVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnFacebookLoginTUI(_ sender: UIButton)
    {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: self)
        { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                UserDefaults.standard.set("SocialMedia", forKey: "loginWith")
                UserDefaults.standard.synchronize()
                
                print("Login Successful")
                self.getFBUserData()
            }
        }
    }
    
    @IBAction func btnGoogleLoginTUI(_ sender: UIButton)
    {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    //-----------------------------
    // MARK: Web Services
    //-----------------------------

    func LogInAPI()
    {
        
        //let header: HTTPHeaders = ["Content-Type": "application/json", "token": "11Z1yzMEte4w6T1Pktpk"]
        let parameter = ["email": emailId, "name": name, "device":"ios", "fcm_id": appDelegate.FcmId!] as [String : Any]

        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            
            Alamofire.request(appDelegate.apiString + "social_login", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
                        print("Validation Successful")
                        let result = response.result.value! as! NSDictionary
                        print(result)
                        if (result["status"] as! Int) == 0
                        {
                            
                            SVProgressHUD.dismiss()
                            Constant.PopUp(Controller: self, title: "Error1!!", message: (result["msg"] as! String))
                            
                        }
                        else
                        {
                            let dic = result["data"] as! NSDictionary
                            SVProgressHUD.dismiss()
                            UserDefaults.standard.set( (dic["name"] as! String), forKey: "name")
                            
                            UserDefaults.standard.set( (dic["email"] as! String), forKey: "email")
                            UserDefaults.standard.set( (dic["country"] as! String), forKey: "country")
                            UserDefaults.standard.set( (dic["username"] as! String), forKey: "username")
                            UserDefaults.standard.set( (dic["image"] as! String), forKey: "image")
                            UserDefaults.standard.set( (dic["id"] as! Int), forKey: "userId")
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            UserDefaults.standard.synchronize()
                            
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
                            
                            
                            self.navigationController?.pushViewController(obj, animated: true)
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            SVProgressHUD.dismiss()
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }

   
}
