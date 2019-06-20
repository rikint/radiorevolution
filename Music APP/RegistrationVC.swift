//
//  RegistrationVC.swift
//  LMM
//
//  Created by Ashutosh Jani on 09/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class RegistrationVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var lblNamePlaceholder: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblNameError: UILabel!
    
    @IBOutlet weak var lblUsernamePlaceholder: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var lblUsernameError: UILabel!
    
    @IBOutlet weak var lblEmailPlaceholder: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var lblPasswordPlaceholder: UILabel!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var lblConfirmPasswordPlaceholder: UILabel!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    
    @IBOutlet weak var lblCountryPlaceholder: UILabel!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var lblCountryError: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var RegisterScrollView: UIScrollView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var tblCountryList: UITableView!
    
    @IBOutlet weak var btnHideCountryList: UIButton!
    
    //----------------------------------
    // MARK: Identifiers
    //----------------------------------
    
    var timer = Timer()
    var countryList = NSMutableArray()
    
    //----------------------------------
    // MARK: View Life Cycle
    //----------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        countryListAPI()
        headerView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        RegisterScrollView.backgroundColor = UIColor(rgb: Constant.backgroundColor)

    //-----------------------------------------
        
        lblNameError.isHidden = true
        lblNamePlaceholder.isHidden = true
        lblUsernameError.isHidden = true
        lblUsernamePlaceholder.isHidden = true
        lblEmailPlaceholder.isHidden = true
        lblEmailError.isHidden = true
        lblPasswordPlaceholder.isHidden = true
        lblPasswordError.isHidden = true
        lblConfirmPasswordPlaceholder.isHidden = true
        lblConfirmPasswordError.isHidden = true
        lblCountryError.isHidden = true
        lblCountryPlaceholder.isHidden = true
        btnHideCountryList.isHidden = true
        tblCountryList.isHidden = true
        
    //-----------------------------------------
        
        btnRegister.layer.cornerRadius = 5
        btnRegister.layer.borderWidth = 1
        btnRegister.layer.borderColor = UIColor.lightGray.cgColor
        
    //-----------------------------------------
        
        txtName.delegate = self
        txtEmail.delegate = self
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        
        txtName.addTarget(self, action: #selector(txtNameValueChange), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(txtEmailValueChange), for: .editingChanged)
        txtUsername.addTarget(self, action: #selector(txtUsernameValueChange), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(txtPasswordValueChange), for: .editingChanged)
        txtConfirmPassword.addTarget(self, action: #selector(txtConfirmPasswordValueChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        txtName.attributedPlaceholder = NSMutableAttributedString(string: "Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtUsername.attributedPlaceholder = NSMutableAttributedString(string: "Username",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        
        txtEmail.attributedPlaceholder = NSMutableAttributedString(string: "Email ID",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtCountry.attributedPlaceholder = NSMutableAttributedString(string: "Country",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        
        txtPassword.attributedPlaceholder = NSMutableAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        
        txtConfirmPassword.attributedPlaceholder = NSMutableAttributedString(string: "Confirm Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    
        
    }
    
    //----------------------------------
    // MARK: Delegate Methods
    //----------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let obj = tblCountryList.dequeueReusableCell(withIdentifier: "tblCellCountryList") as! tblCellCountryList
        
        let dic = countryList[indexPath.row] as! NSDictionary
        obj.lblCountryName.text = (dic["country_name"] as! String)
        
        
        
        return obj
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = countryList[indexPath.row] as! NSDictionary
        lblCountryPlaceholder.isHidden = false
        lblCountryError.isHidden = true
        btnHideCountryList.isHidden = true
        tblCountryList.isHidden = true
        txtCountry.text = (dic["country_name"] as! String)
    }
    
    //----------------------------------
    // MARK: User Defined Functions
    //----------------------------------
    
    @objc func txtNameValueChange()
    {
        if txtName.text == ""
        {
            lblNamePlaceholder.isHidden = true
            lblNameError.isHidden = false
        }
        else
        {
            lblNamePlaceholder.isHidden = false
            lblNameError.isHidden = true
        }
    }
    
    @objc func txtUsernameValueChange()
    {
        if txtUsername.text == ""
        {
            lblUsernamePlaceholder.isHidden = true
            lblUsernameError.isHidden = false
        }
        else
        {
            lblUsernamePlaceholder.isHidden = false
            lblUsernameError.isHidden = true
        }
    }
    
    @objc func txtEmailValueChange()
    {
        if txtEmail.text == ""
        {
            lblEmailPlaceholder.isHidden = true
            lblEmailError.isHidden = false
        }
        else
        {
            lblEmailPlaceholder.isHidden = false
            lblEmailError.isHidden = true
        }
        
        
    }
    @objc func txtPasswordValueChange()
    {
        if txtPassword.text == ""
        {
            lblPasswordPlaceholder.isHidden = true
            lblPasswordError.isHidden = false
        }
        else
        {
            lblPasswordPlaceholder.isHidden = false
            lblPasswordError.isHidden = true
        }
    }
    
    @objc func txtConfirmPasswordValueChange()
    {
        if txtConfirmPassword.text == ""
        {
            lblConfirmPasswordPlaceholder.isHidden = true
            lblConfirmPasswordError.isHidden = false
        }
        else
        {
            lblConfirmPasswordPlaceholder.isHidden = false
            lblConfirmPasswordError.isHidden = true
        }
    }
    

    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.RegisterScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        RegisterScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        RegisterScrollView.contentInset = contentInset
    }
    
    @objc func InternetAvailable()
    {
        SVProgressHUD.dismiss()
        if Connectivity.isConnectedToInternet()
        {
            RegistrationAPI()
            SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.dismiss()
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    @objc func LocationInternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            self.countryListAPI()
            SVProgressHUD.show()
        }
        else
        {
            
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    //----------------------------------
    // MARK: Button Action
    //----------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegisterTUI(_ sender: UIButton)
    {
        if txtName.text == "" || (txtName.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblNameError.isHidden = false
        }
        else if txtUsername.text == "" || (txtUsername.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblUsernameError.isHidden = false
        }
        else if txtEmail.text == "" || (txtEmail.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblEmailError.isHidden = false
        }
        else if Constant.validateEmailWithString(txtEmail.text! as NSString)
        {
            lblEmailError.text = "Enter valid email id!!"
            lblEmailError.isHidden = false
        }
        else if txtPassword.text == "" || (txtPassword.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblPasswordError.isHidden = false
        }
        
        else if txtConfirmPassword.text == "" || (txtConfirmPassword.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblConfirmPasswordError.isHidden = false
        }
        else if txtConfirmPassword.text != txtPassword.text
        {
            lblConfirmPasswordError.text = "Confirm password and password must be same!!"
            lblConfirmPasswordError.isHidden = false
        }
        else if txtCountry.text == ""
        {
            lblCountryError.isHidden = false
        }
        else
        {
            RegistrationAPI()
        }
    }
    
    @IBAction func btnCountryOptionTUI(_ sender: UIButton)
    {
        btnHideCountryList.isHidden = false
        tblCountryList.isHidden = false
    }
    
    @IBAction func btnHideCountryListTUI(_ sender: UIButton)
    {
        btnHideCountryList.isHidden = true
        tblCountryList.isHidden = true
    }
    
    //----------------------------------
    // MARK: Web Services
    //----------------------------------
    
    func countryListAPI()
    {
        //let parameter = ["u_id": appDelegate.userId]
        //print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "countries", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            
                            
                        }
                        else
                        {
                            self.countryList = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblCountryList.reloadData()
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.LocationInternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }

    func RegistrationAPI()
    {
        
        //let header: HTTPHeaders = ["Content-Type": "application/json", "token": "11Z1yzMEte4w6T1Pktpk"]
        let parameter = ["name": txtName.text!, "username": txtUsername.text!, "email": txtEmail.text!, "password": txtPassword.text!,"country": txtCountry.text!] as [String : Any]
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            
            Alamofire.request(appDelegate.apiString + "registration", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            Constant.PopUp(Controller: self, title: "Error", message: result["msg"] as! String)
                            
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                            //self.viewVerified.isHidden = false
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "EmailVerificationVC") as! EmailVerificationVC
                            obj.username = self.txtUsername.text!
                            obj.EmailID = self.txtEmail.text!
                            obj.code = (result["data"] as! String)
                            UserDefaults.standard.synchronize()
                            self.navigationController?.pushViewController(obj, animated: true)
                            
                            
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
