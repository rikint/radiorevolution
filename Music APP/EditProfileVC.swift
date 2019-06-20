//
//  EditProfileVC.swift
//  Exit Vacancy
//
//  Created by Ashutosh Jani on 20/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class EditProfileVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //-----------------------------
    // MARK: Outlets
    //-----------------------------
    
    @IBOutlet weak var imgHotel: UIImageView!
    
    @IBOutlet weak var lblNamePlaceholder: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblNameError: UILabel!
    
    @IBOutlet weak var lblEmailIdPlaceholder: UILabel!
    
    @IBOutlet weak var txtEmailID: UITextField!
    
    @IBOutlet weak var lblEmailIdError: UILabel!
    
    @IBOutlet weak var lblUsernamePlaceholder: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var lblUsernameError: UILabel!
    
    @IBOutlet weak var lblLocationPlaceholder: UILabel!
    
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var lblLocationError: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var tblLocationList: UITableView!
    
    @IBOutlet weak var btnHideCountryList: UIButton!
    
    @IBOutlet weak var btnLocation: UIButton!
    
    @IBOutlet weak var btnEditPhoto: UIButton!
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var changePasswordView: UIView!
    
    @IBOutlet weak var logOutView: UIView!
    //-----------------------------
    // MARK: Identifiers
    //-----------------------------
    
    var timer = Timer()
    var selectedImage = UIImage()
    var internetTimer = Timer()
    var imageUpload = String()
    var profileDetails = NSDictionary()
    var locationList = NSMutableArray()
    
    //-----------------------------
    // MARK: View Life Cycle
    //-----------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        txtName.text = UserDefaults.standard.string(forKey: "name")
        txtEmailID.text = UserDefaults.standard.string(forKey: "email")
        txtUsername.text = UserDefaults.standard.string(forKey: "username")
        txtLocation.text = UserDefaults.standard.string(forKey: "country")
    
        if ((UserDefaults.standard.string(forKey: "image")) != nil)
        {
            imgHotel.sd_setImage(with: URL(string: "http://3.82.73.198/radiorevolution/storage/uploads/" + (UserDefaults.standard.string(forKey: "image")!)), placeholderImage: UIImage(named: "radioRevolutionIcon"), options: .refreshCached, completed: nil)
        }
        else
        {
            imgHotel.image = UIImage(named: "radioRevolutionIcon")
        }
        if UserDefaults.standard.string(forKey: "loginWith") == "SocialMedia"
        {
            changePasswordView.isHidden = true
        }
        imgHotel.layer.cornerRadius = imgHotel.frame.height/2
        
        lblNameError.isHidden = true
        lblEmailIdError.isHidden = true
        lblUsernameError.isHidden = true
        lblLocationError.isHidden = true
        btnUpdate.isHidden = true
        editView.layer.borderColor = UIColor(rgb: 0x700FB6).cgColor
        editView.layer.borderWidth = 1
        txtName.isEnabled = false
        txtEmailID.isEnabled = false
        txtUsername.isEnabled = false
        txtLocation.isEnabled = false
        btnLocation.isEnabled = false
        btnEditPhoto.isHidden = true
        
        countryListAPI()
        btnHideCountryList.isHidden = true
        tblLocationList.isHidden = true
        
        changePasswordView.layer.borderColor = UIColor(rgb: 0x700FB6).cgColor
        changePasswordView.layer.borderWidth = 1
        
        logOutView.layer.borderColor = UIColor(rgb: 0x700FB6).cgColor
        logOutView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        imgHotel.layer.cornerRadius = imgHotel.frame.height/2
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----------------------------
    // MARK: Delegate Methods
    //-----------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let obj = tblLocationList.dequeueReusableCell(withIdentifier: "tblCellCountryList") as! tblCellCountryList
        let dic = locationList[indexPath.row] as! NSDictionary
        
        obj.lblCountryName.text = (dic["country_name"] as! String)
        
        return obj
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        btnHideCountryList.isHidden = true
        tblLocationList.isHidden = true
        let dic = locationList[indexPath.row] as! NSDictionary
        txtLocation.text = (dic["country_name"] as! String)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // To handle image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dismiss(animated: true, completion: nil)
            self.imgHotel.image = image
        } else{
            print("Something went wrong in  image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    //-----------------------------
    // MARK: User Defined Functions
    //-----------------------------
    @objc func txtNameValueChange()
    {
        
        if txtName.text == ""
        {
            
            lblNameError.isHidden = false
        }
        else
        {
            
            lblNameError.isHidden = true
        }
        
    }
    
    
    @objc func InternetAvailable()
    {
        SVProgressHUD.dismiss()
        if Connectivity.isConnectedToInternet()
        {
            
            uploadImage()
            SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.dismiss()
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    @objc func CountryInternetAvailable()
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
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //-----------------------------
    // MARK: Button Actions
    //-----------------------------
    
    @IBAction func btnEditPhotoTUI(_ sender: UIButton)
    {
        let actionSheet = UIAlertController(title: "Choose", message: "Choose a option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            self.photoLibrary()
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnLocationTUI(_ sender: UIButton)
    {
        btnHideCountryList.isHidden = false
        tblLocationList.isHidden = false
    }
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdateTUI(_ sender: UIButton)
    {
        
        
        if txtName.text == "" || (txtName.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblNameError.isHidden = false
        }
        else if txtLocation.text == "" || (txtLocation.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            lblLocationError.isHidden = false
            //Constant.PopUp(Controller: self, title: "Error", message: "")
        }
        else if imgHotel.image == nil
        {
            updateProfileAPI()
        }
        else
        {
            uploadImage()
        }
    }
    
    @IBAction func btnEditTUI(_ sender: UIButton)
    {
        if btnEdit.isSelected
        {
            txtName.isEnabled = false
            btnLocation.isEnabled = false
            btnUpdate.isHidden = true
            btnBack.isHidden = false
            btnEdit.isSelected = false
            btnEditPhoto.isHidden = true
            changePasswordView.isHidden = false
            logOutView.isHidden = false
        }
        else
        {
            changePasswordView.isHidden = true
            txtName.isEnabled = true
            btnLocation.isEnabled = true
            btnUpdate.isHidden = false
            btnBack.isHidden = true
            btnEdit.isSelected = true
            btnEditPhoto.isHidden = false
            logOutView.isHidden = true
            
        }
        if UserDefaults.standard.string(forKey: "loginWith") == "SocialMedia"
        {
            changePasswordView.isHidden = true
        }
        
    }
    @IBAction func btnChangePasswordTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLogoutTUI(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Logout!", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            
            
            
            self.LogoutAPI()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { ACTION in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    //-----------------------------
    // MARK: Web Services
    //-----------------------------

    
    func LogoutAPI()
    {
        SVProgressHUD.show()
        
        
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")] as [String : Any]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            
            Alamofire.request(appDelegate.apiString + "logout", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            Constant.PopUp(Controller: self, title: "Error!", message: (result["msg"] as! String))
                            SVProgressHUD.dismiss()
                            
                        }
                        else
                        {
                            
                            SVProgressHUD.dismiss()
                            Constant.PopUp(Controller: self, title: "Success!", message: (result["msg"] as! String))
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                            {
                                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                                UserDefaults.standard.set( "", forKey: "name")
                                
                                UserDefaults.standard.set( "", forKey: "email")
                                UserDefaults.standard.set( "", forKey: "country")
                                UserDefaults.standard.set( "", forKey: "username")
                                UserDefaults.standard.set( "", forKey: "image")
                                UserDefaults.standard.set( "", forKey: "userId")
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
    
    func updateProfileAPI()
    {
        SVProgressHUD.show()
        
        
        let parameter = ["username": txtUsername.text!, "name": txtName.text!, "email": txtEmailID.text!, "id": String(UserDefaults.standard.integer(forKey: "userId")), "country": txtLocation.text!, "image": imageUpload]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            
            Alamofire.request(appDelegate.apiString + "update_profile", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            Constant.PopUp(Controller: self, title: "Error!", message: (result["msg"] as! String))
                            SVProgressHUD.dismiss()
                            
                        }
                        else
                        {
                            
                            SVProgressHUD.dismiss()
                            Constant.PopUp(Controller: self, title: "Success!", message: (result["msg"] as! String))
                            UserDefaults.standard.set( self.txtName.text!, forKey: "name")
                            UserDefaults.standard.set( self.txtLocation.text!, forKey: "name")
                            UserDefaults.standard.set( result["image"] as! String, forKey: "image")
                            
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
    
    func uploadImage ()
    {
        let image = self.imgHotel.image
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        let parameters = ["username": txtUsername.text!, "name": txtName.text!, "email": txtEmailID.text!, "id": String(UserDefaults.standard.integer(forKey: "userId")), "country": txtLocation.text!, "image": imageUpload]
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
                
            },
                             to: appDelegate.apiString + "update_profile")
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print(response.result.value!)
                        let result = response.result.value! as! NSDictionary
                        if (result["status"] as! Int) == 0
                        {
                            Constant.PopUp(Controller: self, title: "Error!", message: (result["msg"] as! String))
                            SVProgressHUD.dismiss()
                            
                        }
                        else
                        {
                            Constant.PopUp(Controller: self, title: "Success!", message: (result["msg"] as! String))
                            UserDefaults.standard.set( self.txtName.text!, forKey: "name")
                            UserDefaults.standard.set( self.txtLocation.text!, forKey: "name")
                        UserDefaults.standard.set( result["image"] as! String, forKey: "image")
                            //self.imageUpload = (result["image"] as! String)
                            
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
        else
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
    }
    
    func countryListAPI()
    {
        //let parameter = ["u_id": appDelegate.userId]
        //print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
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
                            self.locationList = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblLocationList.reloadData()
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.CountryInternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }
    
    
    
}
