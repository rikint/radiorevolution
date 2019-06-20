//
//  LoginWithEmailVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LoginWithEmailVC: UIViewController, UITextFieldDelegate
{

    //---------------------------
    // MARK: Outlets
    //---------------------------
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblUsernameError: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var loginScrollView: UIScrollView!
    //---------------------------
    // MARK: Identifiers
    //---------------------------
    
    var timer = Timer()
    
    //---------------------------
    // MARK: View Life Cycle
    //---------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        headerView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        loginScrollView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        lblPasswordError.isHidden = true
        lblUsernameError.isHidden = true
        txtPassword.addTarget(self, action: #selector(txtPasswordChangeValue), for: .editingChanged)
        txtUsername.addTarget(self, action: #selector(txtUsernameChangeValue), for: .editingChanged)
        txtUsername.delegate = self
        txtPassword.delegate = self
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        txtUsername.attributedPlaceholder = NSMutableAttributedString(string: "Username",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtPassword.attributedPlaceholder = NSMutableAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------
    // MARK: Delegate Method
    //-------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //-------------------------------
    // MARK: User Defined Function
    //-------------------------------
    
    @objc func txtUsernameChangeValue()
    {
        if txtUsername.text == ""
        {
            lblUsernameError.isHidden = false
        }
        else
        {
            lblUsernameError.isHidden = true
        }
    }
    
    @objc func txtPasswordChangeValue()
    {
        if txtPassword.text == ""
        {
            lblPasswordError.isHidden = false
        }
        else
        {
            lblPasswordError.isHidden = true
        }
    }
    
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
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.loginScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 140
        loginScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        loginScrollView.contentInset = contentInset
    }
    
    //-------------------------------
    // MARK: Button Actions
    //-------------------------------
    
    @IBAction func btnForgotPasswordTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnLoginTUI(_ sender: UIButton)
    {
        if txtPassword.text == "" || (txtPassword.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblPasswordError.isHidden = false
        }
        else if txtUsername.text == "" || (txtUsername.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblUsernameError.isHidden = false
        }
        else
        {
            self.view.endEditing(true)
            LogInAPI()
            SVProgressHUD.show()
        }
        
    }
    
    @IBAction func btnNewUserTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    //-------------------------------
    // MARK: Web Services
    //-------------------------------
    
    func LogInAPI()
    {

        //let header: HTTPHeaders = ["Content-Type": "application/json", "token": "11Z1yzMEte4w6T1Pktpk"]
        let parameter = ["username": txtUsername.text!, "password": txtPassword.text!, "device":"ios", "fcm_id": appDelegate.FcmId!] as [String : Any]
        print(txtUsername.text!)
        print(txtPassword.text!)
        //print(appDelegate.FcmId)
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()

            Alamofire.request(appDelegate.apiString + "login", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            Constant.PopUp(Controller: self, title: "Error!!", message: (result["msg"] as! String))

                        }
                        else if (result["status"] as! Int) == 2
                        {
                            SVProgressHUD.dismiss()
                            Constant.PopUp(Controller: self, title: "Error!!", message: (result["msg"] as! String))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
                                let dic = result["data"] as! NSDictionary

                                obj.EmailID = (dic["email"] as! String)
                                obj.code = (dic["remember_token"] as! String)
                                obj.username = self.txtUsername.text!
                                self.navigationController?.pushViewController(obj, animated: true)
                            }

                        }
                        else if (result["status"] as! Int) == 3
                        {
                            SVProgressHUD.dismiss()
                            UserDefaults.standard.set((result["user_id"] as! Int), forKey: "userId")

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
                            UserDefaults.standard.set("email", forKey: "loginWith")
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
