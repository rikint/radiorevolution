//
//  ContactUsVC.swift
//  LMM
//
//  Created by Ashutosh Jani on 14/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ContactUsVC: UIViewController, UITextFieldDelegate
{
    
    //------------------------------------
    // MARK: Outlets
    //------------------------------------
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblNamePlaceholder: UILabel!
    @IBOutlet weak var lblNameError: UILabel!
    @IBOutlet weak var lblEmailPlaceholder: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblSubjectPlaceholder: UILabel!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var lblSubjectError: UILabel!
    @IBOutlet weak var lblMessagePlaceholder: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var lblMessageError: UILabel!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var contactUsScrollView: UIScrollView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    //------------------------------------
    // MARK: Identifiers
    //------------------------------------
    
    var internetTimer = Timer()
    
    //------------------------------------
    // MARK: View Life Cycle
    //------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        contactUsTextAPI()
        contactUsScrollView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        headerView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        btnContact.layer.cornerRadius = 5
        btnContact.layer.borderWidth = 1
        btnContact.layer.borderColor = UIColor(rgb: Constant.tabbarBackgroundColor).cgColor
        lblNameError.isHidden = true
        lblNamePlaceholder.isHidden = true
        lblEmailError.isHidden = true
        lblEmailPlaceholder.isHidden = true
        lblSubjectError.isHidden = true
        lblSubjectPlaceholder.isHidden = true
        lblMessageError.isHidden = true
        lblMessagePlaceholder.isHidden = true
        
        txtName.delegate = self
        txtEmail.delegate = self
        txtSubject.delegate = self
        txtMessage.delegate = self
        
        txtName.addTarget(self, action: #selector(txtNameValueChange), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(txtEmailValueChange), for: .editingChanged)
        txtSubject.addTarget(self, action: #selector(txtSubjectValueChange), for: .editingChanged)
        txtMessage.addTarget(self, action: #selector(txtMessageValueChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        lblDescription.text = """
//        For questions or suggestions please call us at 908-769-8040.  You can also email us at LatinMixMasters@gmail.com or use the form below and someone will get back to you within 24 hours or less.
//
//        Thank You LATIN MIX MASTERS
//        """
        
        txtName.attributedPlaceholder = NSMutableAttributedString(string: "Enter Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtEmail.attributedPlaceholder = NSMutableAttributedString(string: "Enter Email ID",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtSubject.attributedPlaceholder = NSMutableAttributedString(string: "Enter Subject",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtMessage.attributedPlaceholder = NSMutableAttributedString(string: "Enter Message",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        scrollViewHeight.constant = 370 + lblDescription.bounds.height
//        print(scrollViewHeight.constant)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //------------------------------------
    // MARK: Delegate Methods
    //------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //------------------------------------
    // MARK: User Defined Functions
    //------------------------------------
    
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
    @objc func txtSubjectValueChange()
    {
        if txtSubject.text == ""
        {
            lblSubjectPlaceholder.isHidden = true
            lblSubjectError.isHidden = false
        }
        else
        {
            lblSubjectPlaceholder.isHidden = false
            lblSubjectError.isHidden = true
        }
    }
    
    @objc func txtMessageValueChange()
    {
        if txtMessage.text == ""
        {
            lblMessagePlaceholder.isHidden = true
            lblMessageError.isHidden = false
        }
        else
        {
            lblMessagePlaceholder.isHidden = false
            lblMessageError.isHidden = true
        }
    }
    
    @objc func contactUsApiIntChk()
    {
        if Connectivity.isConnectedToInternet()
        {
            contactUsAPI()
            SVProgressHUD.show()
        }
        else
        {

            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.contactUsScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        contactUsScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        contactUsScrollView.contentInset = contentInset
    }
    
    //------------------------------------
    // MARK: Button Actions
    //------------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContactTUI(_ sender: UIButton)
    {
        if txtName.text == "" || (txtName.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblNameError.isHidden = false
        }
        else if txtEmail.text == "" || (txtEmail.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            
        {
            lblEmailError.isHidden = false
        }
        else if Constant.validateEmailWithString(txtEmail.text! as NSString)
        {
            lblEmailError.text = "Please enter valid Email ID"
        }
        else if txtSubject.text == "" || (txtSubject.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            
        {
            lblSubjectError.isHidden = false
        }
        else if txtMessage.text == "" || (txtMessage.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            
        {
            lblMessageError.isHidden = false
        }
        else
        {
            contactUsAPI()
        }
        
    }
    
    
    
    //------------------------------------
    // MARK: Web Services
    //------------------------------------

    
    
    
    func contactUsAPI()
    {

        let parameter1 = ["name": txtName.text! , "email": txtEmail.text!, "subject": txtSubject.text!, "message": txtMessage.text!] as [String : Any]
        print(parameter1)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "contactus", method: .post, parameters: parameter1, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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


                            Constant.PopUp(Controller: self, title: "Success!", message: result["msg"] as! String)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            

                            SVProgressHUD.dismiss()

                        }


                    case .failure(let error):
                        print(error)
                    }
            }

        }
        else
        {
            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.contactUsApiIntChk), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }


    }
    func contactUsTextAPI()
    {
        
//        let parameter1 = ["name": txtName.text! , "email": txtEmail.text!, "subject": txtSubject.text!, "message": txtMessage.text!] as [String : Any]
//        print(parameter1)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "contact_text", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            
                            let dic = result["data"] as! NSDictionary
                            self.lblDescription.text = (dic["text"] as! String)
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.contactUsApiIntChk), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }
}
