//
//  RecentVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 12/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import MediaPlayer

class RecentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate
{
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var featuredTracksHeaderView: UIView!
    
    @IBOutlet weak var colFeaturedTracks: UICollectionView!
    
    @IBOutlet weak var tblRecentSongs: UITableView!
    
    @IBOutlet weak var oldOrNewPlaylistView: UIView!
    
    @IBOutlet weak var createPlaylistView: UIView!
    
    @IBOutlet weak var tblPlaylistOption: UITableView!
    
    @IBOutlet weak var btnHideOption: UIButton!
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    
    @IBOutlet weak var imgSlider: UIImageView!
    //----------------------------------
    // MARK: Identifiers
    //----------------------------------
    
    var internetTimer = Timer()
    var playlistData = NSMutableArray()
    var videoData = NSMutableArray()
    var songData = NSMutableArray()
    var playlistId = Int()
    var songId = Int()
    var imageData = [String()]
    var swipeLeftTransition = CATransition()
    var swipeRightTransition = CATransition()
    var count = 0
    var sliderTimer = Timer()

    //----------------------------------
    // MARK: View Life Cycle
    //----------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.imgSlider.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.imgSlider.addGestureRecognizer(swipeRight)
        //-------------------------------------------
        
        swipeLeftTransition = CATransition()
        // CATransition * slideTransition; instance variable
        swipeLeftTransition.duration = 0.35
        swipeLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        swipeLeftTransition.type = kCATransitionPush
        swipeLeftTransition.subtype = kCATransitionFromRight
        swipeLeftTransition.delegate = self as? CAAnimationDelegate
        
        //-------------------------------------------
        
        swipeRightTransition = CATransition()
        // CATransition * slideTransition; instance variable
        swipeRightTransition.duration = 0.35
        swipeRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        swipeRightTransition.type = kCATransitionPush
        swipeRightTransition.subtype = kCATransitionFromLeft
        swipeRightTransition.delegate = self as? CAAnimationDelegate
        
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        featuredTracksHeaderView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        txtPlaylistName.attributedPlaceholder = NSMutableAttributedString(string: "Playlist Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtPlaylistName.delegate = self
        colFeaturedTracks.backgroundColor = UIColor(rgb: 0xFFFFFF)
        colFeaturedTracks.isHidden = true
        btnHideOption.isHidden = true
        oldOrNewPlaylistView.isHidden = true
        createPlaylistView.isHidden = true
        tblPlaylistOption.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        videosAPI()
        songsAPI()
    }
    //----------------------------------
    // MARK: Delegate Methods
    //----------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let obj = colFeaturedTracks.dequeueReusableCell(withReuseIdentifier: "colCellFeaturedTracks", for: indexPath) as! colCellFeaturedTracks
        
        let dic = videoData[indexPath.row] as! NSDictionary
        
        obj.lblSongName.text = (dic["video_name"] as! String)
        obj.lblArtistName.text = ""
        obj.imgSong.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
        
        obj.layer.borderColor = UIColor(rgb: 0xE5E5E5).cgColor
        obj.layer.borderWidth = 1
        obj.lblSongName.textColor = UIColor(rgb: 0x000000)
        obj.lblArtistName.textColor = UIColor(rgb: Constant.themeColor)
        
        
        return obj
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "YoutubeVideoVC") as! YoutubeVideoVC
        
        let dic = videoData[indexPath.row] as! NSDictionary
        
        obj.videoUrl = (dic["video_url"] as! String)
        print(dic)
        
        navigationController?.pushViewController(obj, animated: true)
        
    }
    
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 13
        {
            let obj = tblPlaylistOption.dequeueReusableCell(withIdentifier: "tblCellPlaylistOption") as! tblCellPlaylistOption
            
            let dic = playlistData[indexPath.row] as! NSDictionary
            
            obj.lblPlaylistName.text = (dic["name"] as! String)
            
            return obj
        }
        else
        {
            let obj = tblRecentSongs.dequeueReusableCell(withIdentifier: "tblCellRecentSongs") as! tblCellRecentSongs
            
            let dic = songData[indexPath.row] as! NSDictionary
            
            obj.lblSongName.text = (dic["song_name"] as! String)
            obj.lblDuration.text = (dic["song_time"] as! String)
            obj.lblArtistName.text = (dic["dj_name"] as! String)
            obj.lblLikeCount.text = ""
            if (dic["favourite"] as! Int) == 1
            {
                obj.btnLike.isSelected = true
            }
            else
            {
                obj.btnLike.isSelected = false
            }
            obj.btnOption.tag = indexPath.row
            obj.imgSong.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
            
            obj.btnLike.tag = indexPath.row
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
        
    }
    
    //----------------------------------
    // MARK: User Defined Functions
    //----------------------------------
    
    @objc func slideImage()
    {
        if imageData.count == 1
        {
            
            imgSlider.sd_setImage(with: URL(string: imageData[0] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
        }
        else
        {
            if count == imageData.count - 1
            {
                count = 0
                imgSlider.layer.add(swipeLeftTransition, forKey: "swipeLeftTransition")
                imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                
            }
            else
            {
                count += 1
                imgSlider.layer.add(swipeLeftTransition, forKey: "swipeLeftTransition")
                imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                
            }
        }
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.right:
                if imageData.count == 1
                {
                    imgSlider.sd_setImage(with: URL(string: imageData[0] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                }
                else
                {
                    if count == 0
                    {
                        count = imageData.count - 1
                        
                        imgSlider.layer.add(swipeRightTransition, forKey: "swipeRightTransition")
                        imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                        
                        
                        
                    }
                    else
                    {
                        count -= 1
                        imgSlider.layer.add(swipeRightTransition, forKey: "swipeRightTransition")
                        imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                        
                        
                    }
                }
                
                
                
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.left:
                
                if imageData.count == 1
                {
                    imgSlider.sd_setImage(with: URL(string: imageData[0] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                }
                else
                {
                    if count == imageData.count - 1
                    {
                        count = 0
                        imgSlider.layer.add(swipeLeftTransition, forKey: "swipeLeftTransition")
                        imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                        
                    }
                    else
                    {
                        count += 1
                        imgSlider.layer.add(swipeLeftTransition, forKey: "swipeLeftTransition")
                        imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                        
                    }
                }
                
                print("Swiped left")
            default: print("Unrecognised Gesture")
                break
            }
            
        }
    }
    
    
    func playSong()
    {
        
        let dic = Constant.SongList[Constant.songIndex] as! NSDictionary
        print(Constant.songIndex)
        Constant.audioPlayerSTK.play(dic["song_url"] as! String)
        commandCenter()
        //btnPlay.isSelected = true
        
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
        
        if let image = UIImage(named: "radioRevolutionSlpashIcon") {
            
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
    
    //----------------------------------
    // MARK: Button Actions
    //----------------------------------
    
    @IBAction func btnAddToPlaylist(_ sender: UIButton)
    {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            let dic = songData[sender.tag] as! NSDictionary
            
            songId = (dic["song_id"] as! Int)
            btnHideOption.isHidden = false
            oldOrNewPlaylistView.isHidden = false
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
    @IBAction func btnFavouriteTUI(_ sender: UIButton)
    {
        let dic = songData[sender.tag] as! NSDictionary
        
        songId = (dic["song_id"] as! Int)
        if sender.isSelected
        {
            removeSongFromFavouritesAPI()
        }
        else
        {
            addSongToFavouritesAPI()
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
    //----------------------------------
    // MARK: Web Services
    //----------------------------------
    
    
    func songsAPI()
    {
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")]
        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "recent_songs", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.songData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblRecentSongs.reloadData()
                            
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
//        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")]
//        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "sliderimages", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.imageData = (result["images"] as! [String])
                            //self.videoData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            //self.colFeaturedTracks.reloadData()
                            self.sliderTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.slideImage), userInfo: nil, repeats: true)
                            self.sliderTimer.fire()
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
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "playlist_id": playlistId, "song_id": songId, "type":"0"] as [String : Any]
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
    
    func addSongToFavouritesAPI()
    {
        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId"), "song_id": songId, "type":"0"] as [String : Any]
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
                            self.songsAPI()
                            
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
                            self.songsAPI()
                            
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
