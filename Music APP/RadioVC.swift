//
//  RadioVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class RadioVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var colRadio: UICollectionView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnBack: UIButton!
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    var internetTimer = Timer()
    var genreData = NSMutableArray()
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        genresAPI()
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Constant.urlString == "all_genres"
        {
            btnBack.isHidden = true
            headerViewHeight.constant = 0
        }
        else
        {
            btnBack.isHidden = false
            headerViewHeight.constant = 50
        }
    }
    
    //------------------------------
    // MARK: Delegate Methods
    //------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return genreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let obj = colRadio.dequeueReusableCell(withReuseIdentifier: "colCellRadio", for: indexPath) as! colCellRadio
        
        let dic = genreData[indexPath.row] as! NSDictionary
        
        if Constant.urlString == "all_genres"
        {
            obj.lblRadioGenreName.text = (dic["genre_name"] as! String)
            obj.imgRadioGenre.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)
        }
        else
        {
            obj.lblRadioGenreName.text = (dic["mood_name"] as! String)
            obj.imgRadioGenre.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
        }
        
        
        
        return obj
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dic = genreData[indexPath.row] as! NSDictionary
        if Constant.urlString == "all_genres"
        {
            Constant.urlString = "genres_songs"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "SongListVC"])
            
            
            
            let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
            Constant.requestParameter = ["genre_id": (dic["genre_id"] as! Int), "user_id": UserDefaults.standard.integer(forKey: "userId")]
            Constant.genreId = (dic["genre_id"] as! Int)
            obj.CurretVC = "SongListVC"
            Constant.title = (dic["genre_name"] as! String)
            navigationController?.pushViewController(obj, animated: true)
        }
        else
        {
            Constant.requestParameter = ["mood_id": (dic["mood_id"] as! Int)]
            Constant.urlString = "moods_songs"
            Constant.title = (dic["mood_name"] as! String)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "SongListVC"])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/3 - 1, height: self.view.frame.width/3 - 1)
    }
    
    //------------------------------
    // MARK: User Defined Functions
    //------------------------------
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            self.genresAPI()
            SVProgressHUD.show()
        }
        else
        {
            
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
    
    
    //------------------------------
    // MARK: Web Services
    //------------------------------
    
    func genresAPI()
    {
        //let parameter = ["u_id": appDelegate.userId]
        //print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + Constant.urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.genreData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.colRadio.reloadData()
                            
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
