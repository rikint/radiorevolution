//
//  EventListVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 16/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class EventListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    //--------------------------------
    // MARK: Outlets
    //--------------------------------
    
    @IBOutlet weak var tblEventList: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    //--------------------------------
    // MARK: Identifiers
    //--------------------------------

    var internetTimer = Timer()
    var eventData = NSMutableArray()
    
    //--------------------------------
    // MARK: View Life Cycle
    //--------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        eventListAPI()
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        // Do any additional setup after loading the view.
    }
    

    //--------------------------------
    // MARK: Delegate Methods
    //--------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let obj = tblEventList.dequeueReusableCell(withIdentifier: "tblCellEventList") as! tblCellEventList
        
        let dic = eventData[indexPath.row] as! NSDictionary
        obj.lblEventName.text = (dic["title"] as! String)
        obj.lblEventDate.text =  (dic["date"] as! String)
        obj.lblEventAddress.text = (dic["address"] as! String)
        obj.imgEvent.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
        obj.btnShare.tag = indexPath.row
        
        return obj
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
        
        let dic = eventData[indexPath.row] as! NSDictionary
        
        obj.eventName = (dic["title"] as! String)
        obj.eventAddress = (dic["address"] as! String)
        obj.eventDate = (dic["date"] as! String)
        obj.eventTime = (dic["time"] as! String)
        obj.imageString = (dic["image"] as! String)
        obj.eventDescription = (dic["description"] as! String)
        
        navigationController?.pushViewController(obj, animated: true)
    }
    
    //--------------------------------
    // MARK: User Defined Functions
    //--------------------------------
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            self.eventListAPI()
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
    
    @IBAction func btnShareTUI(_ sender: UIButton)
    {
        let dic = eventData[sender.tag] as! NSDictionary
        let imgUrl = URL(string: dic["image"] as! String)
        print(imgUrl!)
        let imageData = NSData(contentsOf: imgUrl!)
        let myImage = UIImage(data: imageData! as Data)
        
        shareEvent(view: self.view, self: self, text: """
            Event Name : \(dic["title"] as! String)
            
            Event Description : \(dic["description"] as! String)
            
            Date : \(dic["date"] as! String)
            
            Time : \(dic["time"] as! String)
            
            Address : \(dic["address"] as! String)
            
            App Name : Radio Revolution
            """, img: myImage!)
        
    }
    
    
    //--------------------------------
    // MARK: Web Services
    //--------------------------------
    
    func eventListAPI()
    {
        //let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")]
        //print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "events", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.eventData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblEventList.reloadData()
                            
                            
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
