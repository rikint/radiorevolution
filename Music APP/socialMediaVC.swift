//
//  socialMediaVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 18/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class socialMediaVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var tblSocialMedia: UITableView!
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    var fbLink = String()
    var instaLink = String()
    var twitterLink = String()
    var timer = Timer()
    var socialMediaData = NSMutableArray()
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        SocialMediaAPI()
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        // Do any additional setup after loading the view.
    }
    

    //------------------------------
    // MARK: Delegate Methods
    //------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return socialMediaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblSocialMedia.dequeueReusableCell(withIdentifier: "tblCellSocialMedia") as! tblCellSocialMedia
        let dic = socialMediaData[indexPath.row] as! NSDictionary
        cell.imgSocialMedia.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)
        tblSocialMedia.beginUpdates()
        let imgUrl = URL(string: dic["image"] as! String)
        print(imgUrl!)
        let imageData = NSData(contentsOf: imgUrl!)
        let myImage = UIImage(data: imageData! as Data)
        let aspectRatio = (myImage?.size.height)! / (myImage?.size.width)!
        
        cell.imgSocialMediaHeight.constant = (cell.frame.width) * aspectRatio
        
        tblSocialMedia.endUpdates()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = socialMediaData[indexPath.row] as! NSDictionary
        let customURL = (dic["link"] as! String)
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    
    //------------------------------
    // MARK: User Defined Function
    //------------------------------
    
    @objc func InternetAvailable()
    {
        SVProgressHUD.dismiss()
        if Connectivity.isConnectedToInternet()
        {
            SocialMediaAPI()
            SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.dismiss()
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    //------------------------------
    // MARK: Button Actions
    //------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFacebookTUI(_ sender: UIButton)
    {
        let customURL = fbLink
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    
    @IBAction func btnTwiiterTUI(_ sender: UIButton)
    {
        let customURL = twitterLink
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    
    @IBAction func btnInstaTUI(_ sender: UIButton)
    {
        let customURL = instaLink
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    
    //------------------------------
    // MARK: Web Services
    //------------------------------
    
    func SocialMediaAPI()
    {
        
        //let header: HTTPHeaders = ["Content-Type": "application/json", "token": "11Z1yzMEte4w6T1Pktpk"]
        SVProgressHUD.show()
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            
            Alamofire.request(appDelegate.apiString + "sociallinks", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.socialMediaData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblSocialMedia.reloadData()
                            
                            
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
