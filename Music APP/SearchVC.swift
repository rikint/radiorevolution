//
//  SearchVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 14/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import MediaPlayer

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    
    
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tblSearchResult: UITableView!
    
    @IBOutlet weak var oldOrNewPlaylistView: UIView!
    
    @IBOutlet weak var createPlaylistView: UIView!
    
    @IBOutlet weak var tblPlaylistOption: UITableView!
    
    @IBOutlet weak var btnHideOption: UIButton!
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    
    @IBOutlet weak var btnAudio: UIButton!
    
    @IBOutlet weak var btnVideo: UIButton!
    
    @IBOutlet weak var audioUnderline: UIView!
    
    @IBOutlet weak var videoUnderline: UIView!
    
    @IBOutlet weak var audioVideoViewHeigth: NSLayoutConstraint!
    
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    var internetTimer = Timer()
    var searchData = NSMutableArray()
    var playlistData = NSMutableArray()
    var playlistId = Int()
    var songId = Int()
    var filterData = NSMutableArray()
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        songsAPI()
        txtPlaylistName.attributedPlaceholder = NSMutableAttributedString(string: "Playlist Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        searchBar.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        searchBar.barTintColor = UIColor.clear
        
        btnAudio.isSelected = true
        btnHideOption.isHidden = true
        oldOrNewPlaylistView.isHidden = true
        createPlaylistView.isHidden = true
        tblPlaylistOption.isHidden = true
        searchBar.delegate = self
        audioVideoViewHeigth.constant = 0
        audioUnderline.isHidden = true
        videoUnderline.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    //------------------------------
    // MARK: Delegate Methods
    //------------------------------
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if btnAudio.isSelected
        {
            searchData = searchText.isEmpty ? filterData : (filterData.filter({(text) -> Bool in
                let dic = text as! NSDictionary
                let tmp: NSString = ((dic["song_name"] as! String)) as NSString
                let range = tmp.range(of: searchText,options: NSString.CompareOptions.caseInsensitive)
                // If dataItem matches the searchText, return true to include it
                return range.location != NSNotFound
            }) as NSArray).mutableCopy() as! NSMutableArray
            tblSearchResult.reloadData()
        }
        else
        {
            searchData = searchText.isEmpty ? filterData : (filterData.filter({(text) -> Bool in
                let dic = text as! NSDictionary
                let tmp: NSString = ((dic["video_name"] as! String)) as NSString
                let range = tmp.range(of: searchText,options: NSString.CompareOptions.caseInsensitive)
                // If dataItem matches the searchText, return true to include it
                return range.location != NSNotFound
            }) as NSArray).mutableCopy() as! NSMutableArray
            tblSearchResult.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 13
        {
            return playlistData.count
        }
        else
        {
            return searchData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 13
        {
            let obj = tblPlaylistOption.dequeueReusableCell(withIdentifier: "tblCellPlaylistOption") as! tblCellPlaylistOption
            
            let dic = playlistData[indexPath.row] as! NSDictionary
            
            obj.lblPlaylistName.text = (dic["name"] as! String)
            
            return obj
        }
        else
        {
            let obj = tblSearchResult.dequeueReusableCell(withIdentifier: "tblCellSearchResult") as! tblCellSearchResult
            
            let dic = searchData[indexPath.row] as! NSDictionary
            
            
            
            if btnAudio.isSelected
            {
                obj.lblSongName.text = (dic["song_name"] as! String)
                obj.lblDuration.text = (dic["song_time"] as! String)
                obj.lblArtistName.text = (dic["dj_name"] as! String)
                obj.imgSong.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
            }
            else
            {
                obj.lblSongName.text = (dic["video_name"] as! String)
                obj.lblDuration.text = (dic["video_time"] as! String)
                obj.lblArtistName.text = ""
                obj.imgSong.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
            }
            obj.btnShare.tag = indexPath.row
            obj.lblLikeCount.text = ""
            obj.btnLike.isHidden = true
            obj.btnOption.isHidden = true
            
            return obj
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
            if tableView.tag == 13
            {
                let dic = playlistData[indexPath.row] as! NSDictionary
                
                playlistId = (dic["id"] as! Int)
                addSongToPlaylistAPI()
            }
            else
            {
                if btnAudio.isSelected
                {
                    let dic = searchData[indexPath.row] as! NSDictionary
                    let dicSonglinst = Constant.SongList[Constant.songIndex] as! NSDictionary
                    if (dic["song_url"] as! String) != (dicSonglinst["song_url"] as! String)
                    {
                        Constant.SongList.removeAllObjects()
                        Constant.SongList.insert(dic, at: 0)
                        Constant.songIndex = 0
                        playSong()
                    }
                }
                else
                {
                    let dic = searchData[indexPath.row] as! NSDictionary
                    let obj = storyboard?.instantiateViewController(withIdentifier: "YoutubeVideoVC") as! YoutubeVideoVC
                    
                    obj.videoUrl = (dic["video_url"] as! String)
                    
                    navigationController?.pushViewController(obj, animated: true)
                }
                
            }
            
        
    }
    
    //------------------------------
    // MARK: User Defined Function
    //------------------------------
    func playSong()
    {
        
        let dic = Constant.SongList[Constant.songIndex] as! NSDictionary
        print(Constant.songIndex)
        Constant.audioPlayerSTK.play(dic["song_url"] as! String)
        commandCenter()
        //btnPlay.isSelected = true
        
    }
    func commandCenter()
    {
        self.setupNowPlaying()
        let commandObj = MPRemoteCommandCenter.shared()
        commandObj.playCommand.addTarget { [] event in
            
            
            self.setupNowPlaying()
            if Constant.audioPlayerSTK.state != .playing
            {
                Constant.audioPlayerSTK.resume()
                //self.btnPlay.isSelected = true
            }
            
            return .success
            
            //return .commandFailed
        }
        commandObj.pauseCommand.addTarget { [] event in
            if Constant.audioPlayerSTK.state == .playing
            {
                Constant.audioPlayerSTK.pause()
                //self.btnPlay.isSelected = false
                return .success
            }
            return .commandFailed
        }
        commandObj.nextTrackCommand.addTarget { [] event in
            self.setupNowPlaying()
            if Constant.songIndex == Constant.SongList.count - 1
            {
                Constant.songIndex = 0
                self.playSong()
                return .success
            }
            else
            {
                Constant.songIndex += 1
                self.playSong()
                return .success
            }
            
            //return .commandFailed
        }
        commandObj.previousTrackCommand.addTarget { [] event in
            self.setupNowPlaying()
            if Constant.songIndex == 0
            {
                Constant.songIndex = Constant.SongList.count - 1
                self.playSong()
                return .success
            }
            else
            {
                Constant.songIndex -= 1
                self.playSong()
                return .success
            }
            
            
            //return .commandFailed
        }
        
        
    }
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        let dic = Constant.SongList[Constant.songIndex] as! NSDictionary
        nowPlayingInfo[MPMediaItemPropertyTitle] = (dic["song_name"] as! String)
        
        if let image = UIImage(named: "LMM_new_icon") {
            
            if #available(iOS 10.0, *) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork(boundsSize: image.size) { size in
                        return image
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = (String(Int(Float(Constant.audioPlayerSTK.progress)/3600)) + ":" + String(Int(Float(Constant.audioPlayerSTK.progress)/60)) + ":" + String(Int(Float(Constant.audioPlayerSTK.progress).truncatingRemainder(dividingBy: 60))))
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = (String(Int(Float(Constant.audioPlayerSTK.progress)/3600)) + ":" + String(Int(Float(Constant.audioPlayerSTK.progress)/60)) + ":" + String(Int(Float(Constant.audioPlayerSTK.progress).truncatingRemainder(dividingBy: 60))))
        
        
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            self.songsAPI()
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
    
    @IBAction func btnAddToPlaylist(_ sender: UIButton)
    {
        let dic = searchData[sender.tag] as! NSDictionary
        
        songId = (dic["song_id"] as! Int)
        btnHideOption.isHidden = false
        oldOrNewPlaylistView.isHidden = false
    }
    
    @IBAction func btnExistingPlaylistTUI(_ sender: UIButton)
    {
        getPlaylistAPI()
        tblPlaylistOption.isHidden = false
        oldOrNewPlaylistView.isHidden = true
    }
    
    
    @IBAction func btnNewPlaylistTUI(_ sender: UIButton)
    {
        oldOrNewPlaylistView.isHidden = true
        createPlaylistView.isHidden = false
    }
    @IBAction func btnHideOptionTUI(_ sender: UIButton)
    {
        btnHideOption.isHidden = true
        oldOrNewPlaylistView.isHidden = true
        createPlaylistView.isHidden = true
        tblPlaylistOption.isHidden = true
    }
    
    @IBAction func btnCreatePlaylistTUI(_ sender: UIButton)
    {
        createPlaylistAPI()
        createPlaylistView.isHidden = true
        tblPlaylistOption.isHidden = false
    }
    
    @IBAction func btnVideoTUI(_ sender: UIButton)
    {
        if !btnVideo.isSelected
        {
            audioUnderline.isHidden = true
            videoUnderline.isHidden = false
            btnAudio.isSelected = false
            btnVideo.isSelected = true
            videosAPI()
        }
    }
    
    @IBAction func btnAudioTUI(_ sender: UIButton)
    {
        if !btnAudio.isSelected
        {
            audioUnderline.isHidden = false
            videoUnderline.isHidden = true
            btnVideo.isSelected = false
            btnAudio.isSelected = true
            songsAPI()
        }
    }
    
    @IBAction func btnShareTUI(_ sender: UIButton)
    {
        let dic = searchData[sender.tag] as! NSDictionary
        
        let imgUrl = URL(string: dic["image"] as! String)
        print(imgUrl!)
        let imageData = NSData(contentsOf: imgUrl!)
        let myImage = UIImage(data: imageData! as Data)
        
        shareSong(view: self.view, self: self , text: """
            
            Song Name: \(dic["song_name"] as! String)
            
            Dj Name: \(dic["dj_name"] as! String)
            
            Song Link: \(dic["song_url"] as! String)
            
            App Name: Radio Revolution
            
            
            """, img: myImage!)
    }
    //------------------------------
    // MARK: Web Services
    //------------------------------
    
    func songsAPI()
    {
        //let parameter = ["u_id": appDelegate.userId]
        //print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "all_songs", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.searchData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblSearchResult.reloadData()
                            self.filterData = self.searchData
                            
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
    
    func videosAPI()
    {
        //let parameter = ["u_id": appDelegate.userId]
        //print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "all_videos", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.searchData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblSearchResult.reloadData()
                            self.filterData = self.searchData
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
                            self.tblPlaylistOption.reloadData()
                            self.tblPlaylistOption.isHidden = false
                            
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
    
    func addSongToPlaylistAPI()
    {
        var type = Int()
        if btnAudio.isSelected
        {
            type = 0
        }
        else
        {
            type = 1
        }
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "playlist_id": playlistId, "song_id": songId, "type": type] as [String : Any]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "add_song_in_playlist", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            Constant.PopUp(Controller: self, title: "Success", message: (result["msg"] as! String))
                            self.btnHideOption.isHidden = true
                            self.oldOrNewPlaylistView.isHidden = true
                            self.createPlaylistView.isHidden = true
                            self.tblPlaylistOption.isHidden = true
                            
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
