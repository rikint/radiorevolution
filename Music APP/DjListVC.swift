//
//  DjListVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class DjListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    //--------------------------------
    // MARK: Outlets
    //--------------------------------
    
    @IBOutlet weak var tblDjList: UITableView!
    
    @IBOutlet weak var tblDjCountryList: UITableView!
    
    @IBOutlet weak var btnCountryName: UIButton!
    
    @IBOutlet weak var btnHideCountryList: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    //--------------------------------
    // MARK: Identifiers
    //--------------------------------
    
    var countryList = NSMutableArray()
    var djData = NSMutableArray()
    var internetTimer = Timer()
    
    
    //--------------------------------
    // MARK: View Life Cycle
    //--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        countryListAPI()
        djListAPI()
        btnHideCountryList.isHidden = true
        tblDjCountryList.isHidden = true
        
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        // Do any additional setup after loading the view.
    }
    
    //--------------------------------
    // MARK: Delegate Methods
    //--------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 13
        {
            return countryList.count + 1
        }
        else
        {
            return djData.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 13
        {
            let obj = tblDjCountryList.dequeueReusableCell(withIdentifier: "tblCellDjCountryList") as! tblCellDjCountryList
            
            
            if indexPath.row == 0
            {
                obj.lblCountryName.text = "All"
                
            }
            else
            {
                let dic = countryList[indexPath.row-1] as! NSDictionary
                obj.lblCountryName.text = (dic["country_name"] as! String)
            }
            
 
            return obj
        }
        else
        {
            let obj = tblDjList.dequeueReusableCell(withIdentifier: "tblCellDjList") as! tblCellDjList
            
            let dic = djData[indexPath.row] as! NSDictionary
            obj.lblDjName.text = (dic["dj_name"] as! String)
            obj.imgDj.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionIcon"), options: .refreshCached, completed: nil)
            
            return obj
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 13
        {
            btnHideCountryList.isHidden = true
            tblDjCountryList.isHidden = true
            
            if indexPath.row == 0
            {
                btnCountryName.setTitle( "All", for: .normal)
                djListAPI()
            }
            else
            {
                let dic = countryList[indexPath.row-1] as! NSDictionary
                btnCountryName.setTitle( (dic["country_name"] as! String), for: .normal)
                djListLocationWiseAPI()
            }
            
        }
        else
        {
            Constant.urlString = "dj_songs"
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "SongListVC"])
            let dic = djData[indexPath.row] as! NSDictionary
            
            
            let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
            Constant.requestParameter = ["dj_id": (dic["dj_id"] as! Int), "user_id": UserDefaults.standard.integer(forKey: "userId")]
            
            obj.CurretVC = "SongListVC"
            Constant.title = (dic["dj_name"] as! String)
            navigationController?.pushViewController(obj, animated: true)
        }
        
        
        
    }
    
    //--------------------------------
    // MARK: User Defined Functions
    //--------------------------------
    
    @objc func InternetAvailable()
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
    
    //--------------------------------
    // MARK: Button Actions
    //--------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCountryNameTUI(_ sender: UIButton)
    {
        btnHideCountryList.isHidden = false
        tblDjCountryList.isHidden = false
    }
    
    @IBAction func btnHideCountryListTUI(_ sender: Any)
    {
        btnHideCountryList.isHidden = true
        tblDjCountryList.isHidden = true
    }
    
    //--------------------------------
    // MARK: Web Services
    //--------------------------------
    
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
                            self.countryList = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblDjCountryList.reloadData()
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }
    
    func djListAPI()
    {
        //let parameter = ["u_id": appDelegate.userId]
        //print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "dj_list", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            
                            self.djData.removeAllObjects()
                            self.tblDjList.reloadData()
                            SVProgressHUD.dismiss()
                            
                            
                        }
                        else
                        {
                            self.djData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblDjList.reloadData()
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }
    
    func djListLocationWiseAPI()
    {
        let parameter = ["location": btnCountryName.titleLabel!.text!]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "location_wise_dj", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            
                            self.djData.removeAllObjects()
                            self.tblDjList.reloadData()
                            SVProgressHUD.dismiss()
                            
                            
                        }
                        else
                        {
                            self.djData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblDjList.reloadData()
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
        }
        else
        {
            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
        
        
    }


}
