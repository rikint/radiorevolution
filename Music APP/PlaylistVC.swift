//
//  PlaylistVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 14/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class PlaylistVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var tblPlaylist: UITableView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var btnHideOption: UIButton!
    
    @IBOutlet weak var createPlaylistView: UIView!
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnAddPlaylist: UIButton!
    
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    var internetTimer = Timer()
    var playlistData = NSMutableArray()
    var playlistId = Int()
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        if Constant.urlString == "all_moods"
        {
            btnAddPlaylist.isHidden = true
            getMoodsAPI()
        }
        else
        {
            btnAddPlaylist.isHidden = false
            getPlaylistAPI()
        }
        lblTitle.text = Constant.title
        
        txtPlaylistName.attributedPlaceholder = NSMutableAttributedString(string: "Playlist Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        btnHideOption.isHidden = true
        createPlaylistView.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    //------------------------------
    // MARK: Delegate Methods
    //------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblPlaylist.dequeueReusableCell(withIdentifier: "tblCellPlaylist") as! tblCellPlaylist
        
        let dic = playlistData[indexPath.row] as! NSDictionary
        
        if Constant.urlString == "all_moods"
        {
            obj.imgPlaylist.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)
            obj.lblTrackCount.isHidden = true
            obj.lblPlaylistName.text = (dic["mood_name"] as! String)
            obj.btnDelete.isHidden = true
        }
        else
        {
            obj.imgPlaylist.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)
            obj.lblTrackCount.text = String(dic["count"] as! Int) + " Songs"
            obj.lblPlaylistName.text = (dic["name"] as! String)
            obj.btnDelete.isHidden = false
            obj.btnDelete.tag = (dic["id"] as! Int)
        }
        
        
        
        return obj
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    
        let dic = playlistData[indexPath.row] as! NSDictionary
        
        if Constant.urlString == "all_moods"
        {
            Constant.requestParameter = ["mood_id": (dic["mood_id"] as! Int)]
            Constant.urlString = "moods_songs"
            Constant.title = (dic["mood_name"] as! String)
            
        }
        else
        {
            Constant.requestParameter = ["playlist_id": (dic["id"] as! Int), "user_id": UserDefaults.standard.integer(forKey: "userId")]
            Constant.urlString = "songs_of_playlist"
            Constant.playlistIdRemoveSong = (dic["id"] as! Int)
            Constant.title = (dic["name"] as! String)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "SongListVC"])
    }
    
    //------------------------------
    // MARK: User Defined Functions
    //------------------------------
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            self.getPlaylistAPI()
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
    
    @IBAction func btnDeleteTUI(_ sender: UIButton)
    {
        
                let alert = UIAlertController(title: "Remove!", message: "Are you sure you want to remove?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { action in
                    print("Download Clicked")
        
                    self.playlistId = sender.tag
                    self.removePlaylistAPI()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { ACTION in
                    print("Download Cancel")
                }))

        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func btnNewPlaylistTUI(_ sender: UIButton)
    {
        btnHideOption.isHidden = false
        createPlaylistView.isHidden = false
    }
    
    @IBAction func btnCreatePlaylist(_ sender: UIButton)
    {
        createPlaylistAPI()
    }
    @IBAction func btnHideOptinonTUI(_ sender: UIButton)
    {
        btnHideOption.isHidden = true
        createPlaylistView.isHidden = true
    }
    //------------------------------
    // MARK: Web Services
    //------------------------------
    
    func getMoodsAPI()
    {
//        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")]
//        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "all_moods", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.playlistData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblPlaylist.reloadData()
                            
                            
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
    
    
    func getPlaylistAPI()
    {
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "get_playlist", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.playlistData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblPlaylist.reloadData()
                            
                            
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
    
    func removePlaylistAPI()
    {
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "playlist_id": playlistId]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "remove_playlist", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.getPlaylistAPI()
                            
                            
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
    
    func createPlaylistAPI()
    {
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "playlist_name": txtPlaylistName.text!] as [String : Any]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "create_playlist", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.getPlaylistAPI()
                            self.createPlaylistView.isHidden = true
                            self.btnHideOption.isHidden = true
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
