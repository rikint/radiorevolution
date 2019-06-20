//
//  BookingVC.swift
//  LMM
//
//  Created by Ashutosh Jani on 15/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
//import Alamofire
//import SVProgressHUD

class BookingVC: UIViewController, UITextFieldDelegate
{
    
    //-------------------------------------
    // MARK: Outlets
    //-------------------------------------
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblNamePlaceholder: UILabel!
    
    @IBOutlet weak var lblNameError: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblEmailPlaceholder: UILabel!
    
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtDOB: UITextField!
    
    @IBOutlet weak var lblDOBError: UILabel!
    
    @IBOutlet weak var lblDOBPlaceholder: UILabel!
    
    @IBOutlet weak var lblEventTypeError: UILabel!
    
    @IBOutlet weak var lblEventTypePlaceholder: UILabel!
    
    @IBOutlet weak var txtEventType: UITextField!
    
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var lblMobileNumberError: UILabel!
    
    @IBOutlet weak var lblMobileNumberPlaceholder: UILabel!
    
    @IBOutlet weak var btnBook: UIButton!
    
    @IBOutlet weak var btnHideDatePicker: UIButton!
    
    @IBOutlet weak var dpDatePicker: UIDatePicker!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var bookingScrollView: UIScrollView!
    //-------------------------------------
    // MARK: Identifiers
    //-------------------------------------
    
    var internetTimer = Timer()
    
    //-------------------------------------
    // MARK: View Life Cycle
    //-------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        bookingScrollView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        lblDescription.text = ""
        btnBook.layer.cornerRadius = 5
        btnBook.layer.borderWidth = 1
        btnBook.layer.borderColor = UIColor.lightGray.cgColor
        lblNameError.isHidden = true
        lblNamePlaceholder.isHidden = true
        lblEmailError.isHidden = true
        lblEmailPlaceholder.isHidden = true
        lblDOBError.isHidden = true
        lblDOBPlaceholder.isHidden = true
        lblMobileNumberError.isHidden = true
        lblMobileNumberPlaceholder.isHidden = true
        lblEventTypeError.isHidden = true
        lblEventTypePlaceholder.isHidden = true
        
        
        txtName.delegate = self
        txtEmail.delegate = self
        txtEventType.delegate = self
        txtMobileNumber.delegate = self
        
        
        
        txtName.addTarget(self, action: #selector(txtNameValueChange), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(txtEmailValueChange), for: .editingChanged)
        txtDOB.addTarget(self, action: #selector(txtDOBValueChange), for: .editingChanged)
        txtEventType.addTarget(self, action: #selector(txtEventTypeValueChange), for: .editingChanged)
        txtMobileNumber.addTarget(self, action: #selector(txtDjNameValueChange), for: .editingChanged)
        

        dpDatePicker.isHidden = true
        btnHideDatePicker.isHidden = true
        dpDatePicker.backgroundColor = UIColor.white
        dpDatePicker.datePickerMode = .date
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        txtName.attributedPlaceholder = NSMutableAttributedString(string: "Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtEmail.attributedPlaceholder = NSMutableAttributedString(string: "Email ID",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtDOB.attributedPlaceholder = NSMutableAttributedString(string: "Event Date",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        txtEventType.attributedPlaceholder = NSMutableAttributedString(string: "Event Type",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        
        txtMobileNumber.attributedPlaceholder = NSMutableAttributedString(string: "Mobile Number with country code",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        scrollViewHeight.constant = lblDescription.bounds.height + 500
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------
    // MARK: Delegate Methods
    //-------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //-------------------------------------
    // MARK: User Defined Function
    //-------------------------------------
    
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
    @objc func txtDOBValueChange()
    {
        if txtDOB.text == ""
        {
            lblDOBPlaceholder.isHidden = true
            lblDOBError.isHidden = false
        }
        else
        {
            lblDOBPlaceholder.isHidden = false
            lblDOBError.isHidden = true
        }
    }
    @objc func txtEventTypeValueChange()
    {
        if txtEventType.text == ""
        {
            lblEventTypePlaceholder.isHidden = true
            lblEventTypeError.isHidden = false
        }
        else
        {
            lblEventTypePlaceholder.isHidden = false
            lblEventTypeError.isHidden = true
        }
    }
    
    @objc func txtDjNameValueChange()
    {
        if txtMobileNumber.text == ""
        {
            lblMobileNumberPlaceholder.isHidden = true
            lblMobileNumberError.isHidden = false
        }
        else
        {
            lblMobileNumberPlaceholder.isHidden = false
            lblMobileNumberError.isHidden = true
        }
    }
    
    
    
//    @objc func bookingApiIntChk()
//    {
//        if Connectivity.isConnectedToInternet()
//        {
//            bookingAPI()
//            SVProgressHUD.show()
//        }
//        else
//        {
//
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.bookingScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        bookingScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        bookingScrollView.contentInset = contentInset
    }
    
    //-------------------------------------
    // MARK: Button Actions
    //-------------------------------------
    
    @IBAction func dpDatePickerVC(_ sender: UIDatePicker)
    {
        
    }
    @IBAction func btnHideDatePickerTUI(_ sender: UIButton)
    {
        let component = Calendar.current.dateComponents([.day,.month,.year], from: dpDatePicker.date)
        txtDOB.text = String(describing: component.day!) + " - " + String(describing: component.month!) + " - " + String(describing: component.year!)
        btnHideDatePicker.isHidden = true
        dpDatePicker.isHidden = true
    }
    
    @IBAction func btnDOBTUI(_ sender: UIButton)
    {
        self.view.endEditing(true)
        btnHideDatePicker.isHidden = false
        dpDatePicker.isHidden = false
    }
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBookTUI(_ sender: UIButton)
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
        else if txtDOB.text == "" || (txtDOB.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            
        {
            lblDOBError.isHidden = false
        }
        else if txtEventType.text == "" || (txtEventType.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            
        {
            lblEventTypeError.isHidden = false
        }
        else if txtMobileNumber.text == "" || (txtMobileNumber.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            
        {
            lblMobileNumberError.isHidden = false
        }
        else
        {
            let component = Calendar.current.dateComponents([.day,.month,.year], from: dpDatePicker.date)
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            if component.year! < components.year!
            {
               // PopUp(Controller: self, title: "Error!", message: "Please enter future date!")
            }
            else
            {
                
                //bookingAPI()
            }
        }
    }
    //-------------------------------------
    // MARK: Web Services
    //-------------------------------------

    
//    func bookingAPI()
//    {
//
//        let parameter1 = ["name": txtName.text! , "email": txtEmail.text!, "event_type": txtEventType.text!, "message": txtMessage.text!,  "lmm_dj_name": txtMobileNumber.text!, "date": txtDOB.text!] as [String : Any]
//        print(parameter1)
//        if Connectivity.isConnectedToInternet()
//        {
//            internetTimer.invalidate()
//            SVProgressHUD.show()
//            Alamofire.request(appDelegate.apiString + "contactus", method: .post, parameters: parameter1, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
//
//                            SVProgressHUD.dismiss()
//
//
//                        }
//                        else
//                        {
//
//
//                            PopUp(Controller: self, title: "Success!", message: result["msg"] as! String)
//
//                            SVProgressHUD.dismiss()
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
//            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.bookingApiIntChk), userInfo: nil, repeats: true)
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//
//
//    }
}
