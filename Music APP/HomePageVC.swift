//
//  HomePageVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 19/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AVKit
import StreamingKit
import MediaPlayer
import GoogleMobileAds



//-------------------------------
// MARK Classes
//-------------------------------

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}

class HomePageVC: UIViewController, STKAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate,GADBannerViewDelegate
{
    
    //-----------------------------------
    // MARK: Outlets
    //-----------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var imgRecent: UIImageView!
    
    @IBOutlet weak var lblRecent: UILabel!
    
    @IBOutlet weak var imgGenre: UIImageView!
    
    @IBOutlet weak var lblGenre: UILabel!
    
    @IBOutlet weak var imgDj: UIImageView!
    
    @IBOutlet weak var lblDj: UILabel!
    
    @IBOutlet weak var imgSearch: UIImageView!
    
    @IBOutlet weak var lblSearch: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var adViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblMenu: UITableView!
    
    @IBOutlet weak var btnHideMenu: UIButton!
    
    @IBOutlet weak var seekSlider: UISlider!
    
    @IBOutlet weak var MenuViewWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var songProgress: UIProgressView!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblSongName: UILabel!
    
    @IBOutlet weak var lblArtistName: UILabel!
    
    @IBOutlet weak var adView: GADBannerView!
    
    @IBOutlet weak var menuScrollingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblMenuHeight: NSLayoutConstraint!
    
    //-----------------------------------
    // MARK: Identifiers
    //-----------------------------------
    
    var VC = UIViewController()

    var MenuItems = ["My Profile", "Moods","My Playlists", "Favourites", "Events" , "Social Media", "Contact Us", "About Us"]
    var MenuItemsImage = [UIImage(named: "icon_myprofile"), UIImage(named: "icon_mood"), UIImage(named: "icon_playlist_menu"), UIImage(named: "icon_favourite"), UIImage(named: "icon_events"), UIImage(named: "icon_social"), UIImage(named: "icon_contact"), UIImage(named: "icon_about")]
    var MenuItemsWithoutLogin = ["Social Media", "Contact Us", "About Us", "Login"]
    var MenuItemsWithoutLoginImage = [UIImage(named: "icon_social"), UIImage(named: "icon_contact"), UIImage(named: "icon_about"), UIImage(named: "icon_login")]
    var playerTimer = Timer()
    var internetTimer = Timer()
    var timer = Timer()
    var rewardAd = GADRewardBasedVideoAd.sharedInstance()
    
    //-----------------------------------
    // MARK: View Life Cycle
    //-----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .allowAirPlay)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
        if Constant.SongList.count == 0
        {
            songsAPI()
        }
        
        btnHideMenu.isHidden = true
        MenuViewWidth.constant = 0
        
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        tabbarView.backgroundColor = UIColor(rgb: Constant.tabbarBackgroundColor)
        playerView.backgroundColor = UIColor(rgb: Constant.playerBackgroudColor)
        tblMenu.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        VC = storyboard?.instantiateViewController(withIdentifier: "RecentVC") as! RecentVC
        self.addChildViewController(VC)
        VC.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview(VC.view)
        VC.didMove(toParentViewController: self)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeVC), name: Notification.Name("VcChanged"), object: nil)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        menuScrollingViewHeight.constant = tblMenu.contentSize.height + 180
        tblMenuHeight.constant = tblMenu.contentSize.height
        tblMenu.reloadData()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        playerTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Loader), userInfo: nil, repeats: true)
        playerTimer.fire()
        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        adView.adUnitID = "ca-app-pub-2864538952219635/6683944226"
        //adView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        adView.rootViewController = self
        adView.isAutoloadEnabled = true
        adView.load(GADRequest())
        adView.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(adVideo), userInfo: nil, repeats: true)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "HomePage")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----------------------------------
    // MARK: Delegate Methods
    //-----------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            return MenuItems.count
        }
        else
        {
            return MenuItemsWithoutLogin.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblMenu.dequeueReusableCell(withIdentifier: "tblCellMenu") as! tblCellMenu
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            obj.lblMenuItem.text = MenuItems[indexPath.row]
            obj.imgMenu.image = MenuItemsImage[indexPath.row]
            
        }
        else
        {
            obj.lblMenuItem.text = MenuItemsWithoutLogin[indexPath.row]
            obj.imgMenu.image = MenuItemsWithoutLoginImage[indexPath.row]
        }
        
        return obj
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        btnHideMenu.isHidden = true
        UIView.animate(withDuration: 10.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            if self.MenuViewWidth.constant == 0 {
                self.MenuViewWidth.constant = self.view.frame.width * 0.7
            }
            else {
                self.MenuViewWidth.constant = 0
            }
        }, completion: { (finished:Bool) -> Void in
            
        })
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            switch MenuItems[indexPath.row]
            {
            case "My Playlists":
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "PlaylistVC"])
                let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
                obj.CurretVC = "PlaylistVC"
                Constant.title = "My Playlist"
                Constant.urlString = "get_playlist"
                navigationController?.pushViewController(obj, animated: true)
            case "Moods":
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "RadioVC"])
                let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
                
                obj.CurretVC = "RadioVC"
                Constant.urlString = "all_moods"
                Constant.title = "Moods"
                navigationController?.pushViewController(obj, animated: true)
            case "Favourites":
                Constant.urlString = "favourite_songs"
                Constant.title = "My Favourites"
                Constant.requestParameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "SongListVC"])
                let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
                obj.CurretVC = "SongListVC"
                navigationController?.pushViewController(obj, animated: true)
                
            case "Contact Us":
                
                
                let obj = storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                
                navigationController?.pushViewController(obj, animated: true)
                
            case "About Us":
                
                
                let obj = storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                
                navigationController?.pushViewController(obj, animated: true)
            case "Events":
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "EventListVC"])
                let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
                obj.CurretVC = "EventListVC"
                navigationController?.pushViewController(obj, animated: true)
            case "My Profile":
                
                
                let obj = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                
                navigationController?.pushViewController(obj, animated: true)
                
            case "Social Media":
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "socialMediaVC"])
                let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
                obj.CurretVC = "socialMediaVC"
                navigationController?.pushViewController(obj, animated: true)
            
            default:
                print("Wrong Choice")
            }
        }
        else
        {
            switch MenuItemsWithoutLogin[indexPath.row]
            {
                
            case "Contact Us":
                
                
                let obj = storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                
                navigationController?.pushViewController(obj, animated: true)
                
            case "About Us":
                
                
                let obj = storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                
                navigationController?.pushViewController(obj, animated: true)
            case "Login":
                
                
                let obj = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                
                navigationController?.pushViewController(obj, animated: true)
                
            case "Social Media":
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "socialMediaVC"])
                let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
                obj.CurretVC = "socialMediaVC"
                navigationController?.pushViewController(obj, animated: true)
            default:
                print("Wrong Choice")
            }
        }
        
        
        
    }
    
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState)
    {
        
        switch state {
        case .buffering:
            SVProgressHUD.show()
        case .playing:
            SVProgressHUD.dismiss()
        default:
            print("state: ",state)
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double)
    {
        print(seekSlider.value)
        print(UInt8((Constant.audioPlayerSTK.state).rawValue))
        
        if Constant.audioPlayerSTK.state == .init(rawValue: 16)
        {
//            if btnRepeat.isSelected
//            {
//
//                playSong()
//
//            }
//            else if btnShuffle.isSelected
//            {
//                songIndex = Int(arc4random_uniform(UInt32(SongList.count)))
//                playSong()
//            }
            if Constant.songIndex == Constant.SongList.count - 1
            {
                Constant.songIndex = 0
                playSong()
            }
            else
            {
                Constant.songIndex += 1
                playSong()
            }
        }
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        adViewHeight.constant = 50
        print("ad received")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        
        adViewHeight.constant = 0
        print("ad failed. Error:",error.localizedDescription)
    }
    
    //-----------------------------------
    // MARK: User Defined Functions
    //-----------------------------------
    
    
    
    @objc func adVideo()
    {
        rewardAd.load(GADRequest(), withAdUnitID: "ca-app-pub-2864538952219635/6683944226")
    }
    
    func playSong()
    {
        
        let dic = Constant.SongList[Constant.songIndex] as! NSDictionary
        print(Constant.songIndex)
        Constant.audioPlayerSTK.play(dic["song_url"] as! String)
        commandCenter()
        btnPlay.isSelected = true
        
    }
    
    @objc func Loader()
    {
        seekSlider.maximumValue = Float(Constant.audioPlayerSTK.duration)
        seekSlider.value = Float(Constant.audioPlayerSTK.progress)
        
        if Constant.songIndex != -1
        {
            let dic = Constant.SongList[Constant.songIndex] as! NSDictionary
            lblSongName.text = (dic["song_name"] as! String)
            //lblSongLenght.text = (dic["song_time"] as! String)
        }
        if Constant.audioPlayerSTK.state == .playing
        {
            btnPlay.isSelected = true
        }
        else
        {
            btnPlay.isSelected = false
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
                self.btnPlay.isSelected = true
            }
            
            return .success
            
            //return .commandFailed
        }
        commandObj.pauseCommand.addTarget { [] event in
            if Constant.audioPlayerSTK.state == .playing
            {
                Constant.audioPlayerSTK.pause()
                self.btnPlay.isSelected = false
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
    
    @objc func ChangeVC(_notification: Notification)
    {
        VC.view.removeFromSuperview()
//        if appDelegate.previousVC.count > 3
//        {
//            appDelegate.previousVC.removeFirst()
//        }
        switch (_notification.userInfo!["Id"] as! String)
        {
        case "HomePageVC":
            VC = storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
            
            
        case "RecentVC":
            VC = storyboard?.instantiateViewController(withIdentifier: "RecentVC") as! RecentVC
            
            //print(appDelegate.previousVC)
//        case "SongListVC":
//            VC = storyboard?.instantiateViewController(withIdentifier: "SongListVC") as! SongListVC
//
//            print(appDelegate.previousVC)
//
        case "DjListVC":
            VC = storyboard?.instantiateViewController(withIdentifier: "DjListVC") as! DjListVC
//
//            print(appDelegate.previousVC)
//
        case "ArtistGenreVC":
            VC = storyboard?.instantiateViewController(withIdentifier: "ArtistGenreVC") as! ArtistGenreVC
//
//            print(appDelegate.previousVC)
//
        case "PlaylistVC":
            VC = storyboard?.instantiateViewController(withIdentifier: "PlaylistVC") as! PlaylistVC

//            print(appDelegate.previousVC)
//
        case "SearchVC":
            VC = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC

//            print(appDelegate.previousVC)
//
//        case "YoutubeVC":
//            VC = storyboard?.instantiateViewController(withIdentifier: "YoutubeVC") as! YoutubeVC
//
//            print(appDelegate.previousVC)
//
        case "RadioVC":
//            currentVC = "RadioVC"
//            seekSlider.isHidden = true
//            btnRepeat.isHidden = true
//            btnShuffle.isHidden = true
//            btnNext.isHidden = true
//            btnPrevious.isHidden = true
//            btnPlay.isSelected = true
            VC = storyboard?.instantiateViewController(withIdentifier: "RadioVC") as! RadioVC
//            appDelegate.previousVC.append("RadioVC")
//            print(appDelegate.previousVC)
            
        default:
            print("")
        }
        self.addChildViewController(VC)
        VC.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview(VC.view)
        VC.didMove(toParentViewController: self)
    }
    
    //-----------------------------------
    // MARK: Button Actions
    //-----------------------------------
    
    @IBAction func btnShowFullPlayerTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "FullPlayerVC") as! FullPlayerVC
        present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnRecentsTUI(_ sender: UIButton)
    {
        if (imgRecent.image != UIImage(named: "icon_recent_black"))
        {
            imgRecent.image = UIImage(named: "icon_recent_black")
            lblRecent.textColor = UIColor(rgb: Constant.themeColor)
            imgGenre.image = UIImage(named: "icon_genre")
            lblGenre.textColor = UIColor(rgb: 0xFFFFFF)
            imgDj.image = UIImage(named: "icon_dj")
            lblDj.textColor = UIColor(rgb: 0xFFFFFF)
            imgSearch.image = UIImage(named: "icon_search")
            lblSearch.textColor = UIColor(rgb: 0xFFFFFF)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id": "RecentVC"])
        }
    }
    
    @IBAction func btnGenresTUI(_ sender: UIButton)
    {
        if (imgGenre.image != UIImage(named: "icon_genre_black"))
        {
            
            imgGenre.image = UIImage(named: "icon_genre_black")
            lblGenre.textColor = UIColor(rgb: Constant.themeColor)
            imgRecent.image = UIImage(named: "icon_recent")
            lblRecent.textColor = UIColor(rgb: 0xFFFFFF)
            imgDj.image = UIImage(named: "icon_dj")
            lblDj.textColor = UIColor(rgb: 0xFFFFFF)
            imgSearch.image = UIImage(named: "icon_search")
            lblSearch.textColor = UIColor(rgb: 0xFFFFFF)
            Constant.urlString = "all_genres"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id": "RadioVC"])
        }
    }
    
    @IBAction func btnDJsTUI(_ sender: UIButton)
    {
        if (imgDj.image != UIImage(named: "icon_dj_black"))
        {
            imgDj.image = UIImage(named: "icon_dj_black")
            lblDj.textColor = UIColor(rgb: Constant.themeColor)
            imgRecent.image = UIImage(named: "icon_recent")
            lblRecent.textColor = UIColor(rgb: 0xFFFFFF)
            imgGenre.image = UIImage(named: "icon_genre")
            lblGenre.textColor = UIColor(rgb: 0xFFFFFF)
            imgSearch.image = UIImage(named: "icon_search")
            lblSearch.textColor = UIColor(rgb: 0xFFFFFF)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id": "DjListVC"])
            
        }
    }
    
    @IBAction func btnSearchTUI(_ sender: UIButton)
    {
        if (imgSearch.image != UIImage(named: "icon_search_black"))
        {
            imgSearch.image = UIImage(named: "icon_search_black")
            lblSearch.textColor = UIColor(rgb: Constant.themeColor)
            imgRecent.image = UIImage(named: "icon_recent")
            lblRecent.textColor = UIColor(rgb: 0xFFFFFF)
            imgGenre.image = UIImage(named: "icon_genre")
            lblGenre.textColor = UIColor(rgb: 0xFFFFFF)
            imgDj.image = UIImage(named: "icon_dj")
            lblDj.textColor = UIColor(rgb: 0xFFFFFF)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id": "SearchVC"])
            
        }
    }
    
    @IBAction func btnMenuTUI(_ sender: UIButton)
    {
        btnHideMenu.isHidden = false
        UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            if self.MenuViewWidth.constant == 0 {
                self.MenuViewWidth.constant = self.view.frame.width * 0.7
            }
            else {
                self.MenuViewWidth.constant = 0
            }
        }, completion: { (finished:Bool) -> Void in
            
        })
    }
    
    @IBAction func btnHideMenuTUI(_ sender: Any)
    {
        btnHideMenu.isHidden = true
        UIView.animate(withDuration: 10.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            if self.MenuViewWidth.constant == 0 {
                self.MenuViewWidth.constant = self.view.frame.width * 0.7
            }
            else {
                self.MenuViewWidth.constant = 0
            }
        }, completion: { (finished:Bool) -> Void in
            
        })
    }
    
    @IBAction func btnPlayTUI(_ sender: UIButton)
    {
        if !btnPlay.isSelected
        {
            if Constant.songIndex == -1
            {
                Constant.songIndex += 1
                playSong()
                btnPlay.isSelected = true
            }
            else
            {
                Constant.audioPlayerSTK.resume()
                btnPlay.isSelected = true
            }
            
        }
        else
        {
        
            Constant.audioPlayerSTK.pause()
            btnPlay.isSelected = false
        }
        
    }
    
    @IBAction func btnNextTUI(_ sender: UIButton)
    {
        
            if Constant.songIndex == Constant.SongList.count - 1
            {
                Constant.songIndex = 0
                playSong()
            }
            else
            {
                Constant.songIndex += 1
                playSong()
            }
            
        
        
    }
    
    @IBAction func btnPreviousTUI(_ sender: UIButton)
    {
        
            
            if Constant.songIndex == 0
            {
                Constant.songIndex = Constant.SongList.count - 1
                playSong()
            }
            else
            {
                Constant.songIndex -= 1
                playSong()
            }
    }
    
    @IBAction func seekSliderVC(_ sender: UISlider)
    {
        Constant.audioPlayerSTK.seek(toTime: Double(sender.value))
    }
    //-----------------------------------
    // MARK: Web Services
    //-----------------------------------
    
    func songsAPI()
    {
//        let parameter = ["u_id": appDelegate.userId]
//        print(parameter)
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
                            Constant.SongList = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            
                            
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
