//
//  EmailVerificationVC.swift
//  Exit Vacancy
//
//  Created by Ashutosh Jani on 05/07/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class EmailVerificationVC: UIViewController, UITextFieldDelegate {

    //-------------------------
    // MARK: Outlets
    //-------------------------
    
    @IBOutlet weak var viewVerified: UIView!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblCodeError: UILabel!
    
    @IBOutlet weak var lblCodePlaceHolder: UILabel!
    
    @IBOutlet weak var btnVerify: UIButton!
    
    @IBOutlet weak var txtVerificationCode: UITextField!
    
    @IBOutlet weak var btnReSendCode: UIButton!
    
    @IBOutlet weak var btnChangeEmail: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var timer = Timer()
    var EmailID = String()
    var username = String()
    var code = String()
    
    //-------------------------
    // MARK: View Life Cycle
    //-------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        btnChangeEmail.isHidden = true
        btnReSendCode.isHidden = true
        //viewVerified.isHidden = true
        btnVerify.layer.cornerRadius = 5
        btnVerify.layer.borderWidth = 1
        btnVerify.layer.borderColor = UIColor.lightGray.cgColor
        lblCodePlaceHolder.isHidden = true
        lblCodeError.isHidden = true
        txtVerificationCode.addTarget(self, action: #selector(txtCodeValueChanged), for: .editingChanged)
        
        lblSubTitle.text = "Enter Verification code sent to " + EmailID
        txtVerificationCode.delegate = self
        
        txtVerificationCode.attributedPlaceholder = NSMutableAttributedString(string: "Verification Code",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        // Do any additional setup after loading the view.
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
    
    //------------------------------
    // MARK: User Defined Function
    //------------------------------
    
    @objc func txtCodeValueChanged()
    {
        if txtVerificationCode.text == ""
        {
            lblCodePlaceHolder.isHidden = true
            lblCodeError.isHidden = false
        }
        else
        {
            lblCodeError.isHidden = true
            lblCodePlaceHolder.isHidden = false
        }
    
    }
    
//    @objc func ResendApiInternetCheck()
//    {
//        SVProgressHUD.dismiss()
//        if Connectivity.isConnectedToInternet()
//        {
//            VerifyEmail()
//            SVProgressHUD.show()
//        }
//        else
//        {
//            SVProgressHUD.dismiss()
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//    }

    @objc func InternetAvailable()
    {
        SVProgressHUD.dismiss()
        if Connectivity.isConnectedToInternet()
        {
            VerifyEmail()
            SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.dismiss()
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    //---------------------------
    // MARK: Button Actions
    //---------------------------
    
    @IBAction func btnVerifyTUI(_ sender: UIButton)
    {
        if ((txtVerificationCode.text! as NSString).compare(code, options: .caseInsensitive).rawValue == 0)
        {
            self.view.endEditing(true)
            VerifyEmail()
            SVProgressHUD.show()
        }
        else
        {
            Constant.PopUp(Controller: self, title: "Error!!!", message: "Wrong Verification Code")
        }
        
    }
    @IBAction func btnChangeEmailTUI(_ sender: UIButton)
    {
        self.view.endEditing(true)
//        let obj = storyboard?.instantiateViewController(withIdentifier: "ChangeEmailIDVC") as! ChangeEmailIDVC
//        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReSendCodeTUI(_ sender: UIButton)
    {
        self.view.endEditing(true)
        Constant.PopUp(Controller: self, title: "Success!", message: "Verification code sent Successfully")
        VerifyEmail()
    }
    
    //---------------------------
    // MARK: Web Services
    //---------------------------
    func VerifyEmail()
    {

        //let header: HTTPHeaders = ["Content-Type": "application/json", "token": "11Z1yzMEte4w6T1Pktpk"]
        let parameter = ["username": username ,"token": txtVerificationCode.text!] as [String : Any]
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()

            Alamofire.request(appDelegate.apiString + "verify_email", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                        else
                        {
                            SVProgressHUD.dismiss()
                            Constant.PopUp(Controller: self, title: "Error!!", message: (result["msg"] as! String))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginWithEmailVC") as! LoginWithEmailVC
                               self.navigationController?.pushViewController(obj, animated: true)
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
