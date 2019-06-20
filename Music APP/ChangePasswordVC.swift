//
//  ChangePasswordVC.swift
//  LMM
//
//  Created by Ashutosh Jani on 15/11/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ChangePasswordVC: UIViewController, UITextFieldDelegate
{
    
    //-------------------------------
    // MARK: Outlets
    //-------------------------------
    
    @IBOutlet weak var lblOldPasswordPlaceholder: UILabel!
    
    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var lblOldPasswordError: UILabel!
    
    @IBOutlet weak var lblNewPasswordPlaceholder: UILabel!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var lblNewPasswordError: UILabel!
    
    @IBOutlet weak var lblConfirmPasswordPlaceholder: UILabel!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    //-------------------------------
    // MARK: Identifiers
    //-------------------------------
    
    var timer = Timer()
    
    //-------------------------------
    // MARK: View Life Cycle
    //-------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        
        txtOldPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
        
        txtOldPassword.addTarget(self, action: #selector(txtOldPasswordValueChanged), for: .editingChanged)
        txtNewPassword.addTarget(self, action: #selector(txtNewPasswordValueChanged), for: .editingChanged)
        txtConfirmPassword.addTarget(self, action: #selector(txtConfirmPasswordValueChanged), for: .editingChanged)
        
        lblOldPasswordPlaceholder.isHidden = true
        lblOldPasswordError.isHidden = true
        lblNewPasswordError.isHidden = true
        lblNewPasswordPlaceholder.isHidden = true
        lblConfirmPasswordError.isHidden = true
        lblConfirmPasswordPlaceholder.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //-------------------------------
    // MARK: Delegate Methods
    //-------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //-------------------------------
    // MARK: User Defined Functions
    //-------------------------------
    
    @objc func txtOldPasswordValueChanged()
    {
        if txtOldPassword.text == ""
        {
            lblOldPasswordError.isHidden = false
            lblOldPasswordPlaceholder.isHidden = true
        }
        else
        {
            lblOldPasswordError.isHidden = true
            lblOldPasswordPlaceholder.isHidden = false
        }
    }
    @objc func txtNewPasswordValueChanged()
    {
        if txtNewPassword.text == ""
        {
            lblNewPasswordError.isHidden = false
            lblNewPasswordPlaceholder.isHidden = true
        }
        else
        {
            lblNewPasswordError.isHidden = true
            lblNewPasswordPlaceholder.isHidden = false
        }
    }
    
    @objc func txtConfirmPasswordValueChanged()
    {
        if txtConfirmPassword.text == ""
        {
            lblConfirmPasswordError.isHidden = false
            lblConfirmPasswordPlaceholder.isHidden = true
        }
        else
        {
            lblConfirmPasswordError.isHidden = true
            lblConfirmPasswordPlaceholder.isHidden = false
        }
    }
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            ChangePasswordAPI()
            SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.dismiss()
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    //-------------------------------
    // MARK: Button Action
    //-------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChangePasswordTUI(_ sender: UIButton)
    {
        if txtOldPassword.text == "" || txtOldPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblOldPasswordError.isHidden = false
        }
        else if txtNewPassword.text == "" || txtNewPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblNewPasswordError.isHidden = false
        }
        else if txtConfirmPassword.text == "" || txtConfirmPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblConfirmPasswordError.isHidden = false
        }
        else if txtConfirmPassword.text != txtNewPassword.text
        {
            lblConfirmPasswordError.text = "Confirm password must be same as new password"
            lblConfirmPasswordError.isHidden = false
        }
        else
        {
            ChangePasswordAPI()
        }
    }
    //-------------------------------
    // MARK: Web Services
    //-------------------------------

    func ChangePasswordAPI()
    {
        
        let parameter1 = ["old_password": txtOldPassword.text!, "new_password": txtNewPassword.text!, "id": UserDefaults.standard.integer(forKey: "userId")] as [String : Any]
        print(parameter1)
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            
            Alamofire.request(appDelegate.apiString + "change_password", method: .post, parameters: parameter1, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            Constant.PopUp(Controller: self, title: "Fail!!", message: (result["msg"] as! String))
                            
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                            Constant.PopUp(Controller: self, title: "Success!!", message: (result["msg"] as! String))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }

}
