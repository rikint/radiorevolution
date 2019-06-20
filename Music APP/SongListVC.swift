//
//  SongListVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 15/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import MediaPlayer

class SongListVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    //---------------------------------
    // MARK: Outlets
    //---------------------------------
    
    @IBOutlet weak var tblSongList: UITableView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var btnVideo: UIButton!
    
    @IBOutlet weak var btnAudio: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var oldOrNewPlaylistView: UIView!
    
    @IBOutlet weak var createPlaylistView: UIView!
    
    @IBOutlet weak var tblPlaylistOption: UITableView!
    
    @IBOutlet weak var btnHideOption: UIButton!
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    
    @IBOutlet weak var audioUnderline: UIView!
    
    @IBOutlet weak var videoUnderline: UIView!
    
    @IBOutlet weak var audioVideoViewHeight: NSLayoutConstraint!
    
    
    //---------------------------------
    // MARK: Identifiers
    //---------------------------------
    
    
    var internetTimer = Timer()
    var songData = NSMutableArray()
    var playlistData = NSMutableArray()
    var playlistId = Int()
    var songId = Int()
    
    //---------------------------------
    // MARK: View Life Cycle
    //---------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btnAudio.isSelected = true

        songListAPI()
        lblTitle.text = Constant.title
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        txtPlaylistName.attributedPlaceholder = NSMutableAttributedString(string: "Playlist Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        btnHideOption.isHidden = true
        oldOrNewPlaylistView.isHidden = true
        createPlaylistView.isHidden = true
        tblPlaylistOption.isHidden = true
        audioVideoViewHeight.constant = 0
        audioUnderline.isHidden = true
        videoUnderline.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    
    //---------------------------------
    // MARK: Delegate Methods
    //---------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 13
        {
            return playlistData.count
        }
        else
        {
            return songData.count
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
            let obj = tblSongList.dequeueReusableCell(withIdentifier: "tblCellSongList") as! tblCellSongList
            
            let dic = songData[indexPath.row] as! NSDictionary
            
            //if Constant.urlString == "genres_songs" || Constant.urlString == "songs_of_playlist"
            if btnAudio.isSelected
            {
                if Constant.urlString == "songs_of_playlist"
                {
                    obj.btnOption.setImage(UIImage(named: "icon_delete"), for: .normal)
                }
                if Constant.urlString == "favourite_songs"
                {
                    obj.btnLike.isSelected = true
                }
                else
                {
                    if (dic["favourite"] as! Int) == 1
                    {
                        obj.btnLike.isSelected = true
                    }
                    else
                    {
                        obj.btnLike.isSelected = false
                    }
                }
                
                obj.lblSongName.text = (dic["song_name"] as! String)
                obj.lblDuration.text = (dic["song_time"] as! String)
                obj.lblArtistName.text = (dic["dj_name"] as! String)
                obj.imgSong.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
            }
            else
            {
                if Constant.urlString == "favourite_songs"
                {
                    obj.btnLike.isSelected = true
                }
                else
                {
                    if (dic["favourite"] as! Int) == 1
                    {
                        obj.btnLike.isSelected = true
                    }
                    else
                    {
                        obj.btnLike.isSelected = false
                    }
                }
                if Constant.urlString == "songs_of_playlist"
                {
                    obj.btnOption.setImage(UIImage(named: "icon_delete"), for: .normal)
                }
                obj.lblSongName.text = (dic["video_name"] as! String)
                obj.lblDuration.text = (dic["video_time"] as! String)
                obj.lblArtistName.text = ""
                obj.imgSong.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
            }
            
            obj.lblLikeCount.text = ""
            obj.btnLike.tag = indexPath.row
            obj.btnOption.tag = indexPath.row
            obj.btnShare.tag = indexPath.row
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
                if songData == Constant.SongList
                {
                    Constant.songIndex = indexPath.row
                    playSong()
                }
                else
                {
                    Constant.SongList = songData
                    Constant.songIndex = indexPath.row
                    playSong()
                    
                }
            }
            else
            {
                let dic = songData[indexPath.row] as! NSDictionary
                let obj = storyboard?.instantiateViewController(withIdentifier: "YoutubeVideoVC") as! YoutubeVideoVC
                
                obj.videoUrl = (dic["video_url"] as! String)
                
                navigationController?.pushViewController(obj, animated: true)
            }
            
        }
    }
    
    
    //---------------------------------
    // MARK: User Defined Functions
    //---------------------------------
    
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
            self.songListAPI()
            SVProgressHUD.show()
        }
        else
        {
            
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    //---------------------------------
    // MARK: Button Actions
    //---------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        if Constant.urlString == "songs_of_playlist"
        {
        
            Constant.title = "My Playlist"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "PlaylistVC"])
            
        }
        else if Constant.urlString == "moods_songs"
        {
            Constant.title = "Moods"
            Constant.urlString = "all_moods"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "RadioVC"])
        }
        else
        {
            Constant.urlString = "all_genres"
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func btnVideoTUI(_ sender: UIButton)
    {
        if !btnVideo.isSelected
        {
            if Constant.urlString == "genres_songs"
            {
                btnAudio.isSelected = false
                btnVideo.isSelected = true
                Constant.urlString = "genres_videos"
            }
            else if Constant.urlString == "dj_songs"
            {
                btnAudio.isSelected = false
                btnVideo.isSelected = true
                Constant.urlString = "dj_videos"
            }
            audioUnderline.isHidden = true
            videoUnderline.isHidden = false
            btnAudio.isSelected = false
            btnVideo.isSelected = true
            songListAPI()
        }
    }
    
    @IBAction func btnAudioTUI(_ sender: UIButton)
    {
        if !btnAudio.isSelected
        {
            if Constant.urlString == "genres_videos"
            {
                btnVideo.isSelected = false
                btnAudio.isSelected = true
                Constant.urlString = "genres_songs"
            }
            else if Constant.urlString == "dj_videos"
            {
                btnVideo.isSelected = false
                btnAudio.isSelected = true
                Constant.urlString = "dj_songs"
            }
            audioUnderline.isHidden = false
            videoUnderline.isHidden = true
            btnVideo.isSelected = false
            btnAudio.isSelected = true
            songListAPI()
        }
    }
    
    @IBAction func btnAddToPlaylist(_ sender: UIButton)
    {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            let dic = songData[sender.tag] as! NSDictionary
            
            if btnAudio.isSelected
            {
                songId = (dic["song_id"] as! Int)
            }
            else
            {
                songId = (dic["video_id"] as! Int)
            }
            
            if Constant.urlString == "songs_of_playlist"
            {
                let alert = UIAlertController(title: "Remove!", message: "Are you sure you want to remove?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { action in
                    print("Download Clicked")
                    
                    self.playlistId = sender.tag
                    self.removeSongFromPlaylistAPI()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { ACTION in
                    print("Download Cancel")
                }))
                
                present(alert, animated: true, completion: nil)
            }
            else
            {
                
                btnHideOption.isHidden = false
                oldOrNewPlaylistView.isHidden = false
            }
        }
        else
        {
            let obj = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            
            navigationController?.pushViewController(obj, animated: true)
        }
        
        
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
    
    @IBAction func btnFavouritesTUI(_ sender: UIButton)
    {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            let dic = songData[sender.tag] as! NSDictionary
            
            if btnAudio.isSelected
            {
                songId = (dic["song_id"] as! Int)
            }
            else
            {
                songId = (dic["video_id"] as! Int)
            }
            
            if sender.isSelected
            {
                removeSongFromFavouritesAPI()
            }
            else
            {
                addSongToFavouritesAPI()
            }
        }
        else
        {
            let obj = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            
            navigationController?.pushViewController(obj, animated: true)
        }
        
    }
    
    @IBAction func btnShareTUI(_ sender: UIButton)
    {
        let dic = songData[sender.tag] as! NSDictionary
        
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
    
    //---------------------------------
    // MARK: Web Services
    //---------------------------------
    
    
    func songListAPI()
    {
        if Constant.urlString == "songs_of_playlist" || Constant.urlString == "favourite_songs"
        {
            if btnAudio.isSelected
            {
                Constant.requestParameter.updateValue(0, forKey: "type")
            }
            else
            {
                Constant.requestParameter.updateValue(1, forKey: "type")
            }
        }
        
        
        print(Constant.requestParameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            print(appDelegate.apiString + Constant.urlString)
            Alamofire.request(appDelegate.apiString + Constant.urlString, method: .post, parameters: Constant.requestParameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.songData.removeAllObjects()
                            self.tblSongList.reloadData()
                            SVProgressHUD.dismiss()
                            
                            
                        }
                        else
                        {
                            self.songData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblSongList.reloadData()
                            
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
    
    func removeSongFromPlaylistAPI()
    {
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "playlist_id": Constant.playlistIdRemoveSong, "song_id": songId] as [String : Any]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "remove_song_from_playlist", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.songListAPI()
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

    func addSongToFavouritesAPI()
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
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "song_id": songId, "type": type] as [String : Any]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "add_favourite", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.songListAPI()
                            
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
    
    func removeSongFromFavouritesAPI()
    {
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "song_id": songId] as [String : Any]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "remove_favourite_song", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.songListAPI()
                            
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
