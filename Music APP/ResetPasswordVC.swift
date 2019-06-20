//
//  ResetPasswordVC.swift
//  Exit Vacancy
//
//  Created by Ashutosh Jani on 05/07/18.
//  Copyright © 2018 Ashutosh Jani. All ri  ghts reserved.
//

import UIKit
//import Alamofire
//import SVProgressHUD

class ResetPasswordVC: UIViewController, UITextFieldDelegate
{
    //-------------------------
    // MARK: Outlets
    //-------------------------
    
    @IBOutlet weak var lblEmailPlaceHolder: UILabel!
    
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var timer = Timer()
    
    //-------------------------
    // MARK: View Life Cycle
    //-------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        lblEmailError.isHidden = true
        lblEmailPlaceHolder.isHidden = true
        txtEmail.addTarget(self, action: #selector(txtEmailIdChangeValue), for: .editingChanged)
        txtEmail.delegate = self
        btnResetPassword.layer.cornerRadius = 5
        btnResetPassword.layer.borderWidth = 1
        btnResetPassword.layer.borderColor = UIColor.lightGray.cgColor
        txtEmail.attributedPlaceholder = NSMutableAttributedString(string: "Email ID",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
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
    
    //-------------------------------
    // MARK: User Defined Function
    //-------------------------------
    
    @objc func txtEmailIdChangeValue()
    {
        if txtEmail.text == ""
        {
            lblEmailError.isHidden = false
            lblEmailPlaceHolder.isHidden = true
        }
        else
        {
            lblEmailPlaceHolder.isHidden = false
            lblEmailError.isHidden = true
        }
    }
    
//    @objc func InternetAvailable()
//    {
//        if Connectivity.isConnectedToInternet()
//        {
//            ResetPasswordAPI()
//            SVProgressHUD.show()
//        }
//        else
//        {
//            SVProgressHUD.dismiss()
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//    }
    
    //--------------------------
    // MARK: Button Actions
    //--------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
       navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResetPassword(_ sender: UIButton)
    {
        if txtEmail.text == "" || (txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
        {
            lblEmailError.isHidden = false
        }
        else if Constant.validateEmailWithString(txtEmail.text! as NSString)
        {
            lblEmailError.text = "Enter Valid Email"
            lblEmailError.isHidden = false
        }
        else
        {
            self.view.endEditing(true)
            //ResetPasswordAPI()
            //SVProgressHUD.show()
        }
        
    }
    
    //--------------------------
    // MARK: Web Services
    //--------------------------
    
//    func ResetPasswordAPI()
//    {
//        
//        //let header: HTTPHeaders = ["Content-Type": "application/json", "token": "11Z1yzMEte4w6T1Pktpk"]
//        let parameter = ["email": txtEmail.text!] as [String : Any]
//        if Connectivity.isConnectedToInternet()
//        {
//            timer.invalidate()
//            
//            Alamofire.request(appDelegate.apiString + "forgot_password", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
//                {
//                    response in
//                    switch response.result
//                    {
//                    case .success:
//                        print("Validation Successful")
//                        let result = response.result.value! as! NSDictionary
//                        print(result)
//                        if (result["status"] as! Int) == 0
//                        {
//                            SVProgressHUD.dismiss()
//                            PopUp(Controller: self, title: "Fail!!", message: (result["msg"] as! String))
//                            
//                        }
//                        else
//                        {
//                            SVProgressHUD.dismiss()
//                            PopUp(Controller: self, title: "Success!!", message: (result["msg"] as! String))
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
//                            {
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                            
//                        }
//                        
//                        
//                    case .failure(let error):
//                        print(error)
//                    }
//            }
//            
//        }
//        else
//        {
//            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//        
//        
//    }
    

    

}
