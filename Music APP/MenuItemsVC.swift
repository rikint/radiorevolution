//
//  MenuItemsVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 15/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import StreamingKit
import MediaPlayer
import Alamofire
import SVProgressHUD
import GoogleMobileAds

class MenuItemsVC: UIViewController, STKAudioPlayerDelegate, GADBannerViewDelegate
{
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var adMobView: GADBannerView!
    
    @IBOutlet weak var adMobViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var songProgress: UIProgressView!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblSongName: UILabel!
    
    @IBOutlet weak var lblArtistName: UILabel!
    //----------------------------------
    // MARK: Identifiers
    //----------------------------------
    
    var MenuItemVC = UIViewController()
    
    var CurretVC = String()
    
    var playerTimer = Timer()
    
    var timer = Timer()
    
    var rewardAd = GADRewardBasedVideoAd.sharedInstance()
    
    //----------------------------------
    // MARK: View Life Cycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        playerView.backgroundColor = UIColor(rgb: Constant.playerBackgroudColor)
        adMobView.backgroundColor = UIColor(rgb: Constant.playerBackgroudColor)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeMenuItemVC), name: Notification.Name("MenuItemVcChanged"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": CurretVC])
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        playerTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Loader), userInfo: nil, repeats: true)
        playerTimer.fire()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        adMobView.adUnitID = "ca-app-pub-2864538952219635/6683944226"
        //adView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        adMobView.rootViewController = self
        adMobView.isAutoloadEnabled = true
        adMobView.load(GADRequest())
        adMobView.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(adVideo), userInfo: nil, repeats: true)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "MenuItems")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    //----------------------------------
    // MARK: Delegate Methods
    //----------------------------------
    
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
        print(songProgress.progress)
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
        adMobViewHeight.constant = 50
        print("ad received")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        
        adMobViewHeight.constant = 0
        print("ad failed. Error:",error.localizedDescription)
    }
    
    //----------------------------------
    // MARK: User Defined Functions
    //----------------------------------
    
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
        //songProgress.maximumValue = Float(audioPlayerSTK.duration)
        //seekSlider.value = Float(audioPlayerSTK.progress)
        
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
    
    @objc func ChangeMenuItemVC(_notification: Notification)
    {
        MenuItemVC.view.removeFromSuperview()
        //        if appDelegate.previousVC.count > 3
        //        {
        //            appDelegate.previousVC.removeFirst()
        //        }
        switch (_notification.userInfo!["Id"] as! String)
        {
        case "PlaylistVC":
            MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "PlaylistVC") as! PlaylistVC
            
        case "SongListVC":
            MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "SongListVC") as! SongListVC
            
            //print(appDelegate.previousVC)
        case "EventListVC":
            MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "EventListVC") as! EventListVC
            //
            //            print(appDelegate.previousVC)
            //
        case "DjListVC":
                        MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "DjListVC") as! DjListVC
            
            //            print(appDelegate.previousVC)
            //
        case "GalleryAllImagesVC":
                        MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "GalleryAllImagesVC") as! GalleryAllImagesVC
            //
            //            print(appDelegate.previousVC)
        //
        case "RadioVC":
            MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "RadioVC") as! RadioVC
            
            //            print(appDelegate.previousVC)
        //
        case "SearchVC":
            MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            
            //            print(appDelegate.previousVC)
            //
        case "YoutubeListVC":
                        MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "YoutubeListVC") as! YoutubeListVC
            //
            //            print(appDelegate.previousVC)
            //
        case "socialMediaVC":
            MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "socialMediaVC") as! socialMediaVC
            
        case "VimeoVC":
            MenuItemVC = storyboard?.instantiateViewController(withIdentifier: "VimeoVC") as! VimeoVC

            //        case "RadioVC":
            //            currentVC = "RadioVC"
            //            seekSlider.isHidden = true
            //            btnRepeat.isHidden = true
            //            btnShuffle.isHidden = true
            //            btnNext.isHidden = true
            //            btnPrevious.isHidden = true
            //            btnPlay.isSelected = true
            //            VC = storyboard?.instantiateViewController(withIdentifier: "RadioVC") as! RadioVC
            //            appDelegate.previousVC.append("RadioVC")
            //            print(appDelegate.previousVC)
            
        default:
            print("")
        }
        self.addChildViewController(MenuItemVC)
        MenuItemVC.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview(MenuItemVC.view)
        MenuItemVC.didMove(toParentViewController: self)
    }
    
    
    //----------------------------------
    // MARK: Button Actions
    //----------------------------------
    
    
    @IBAction func btnNowPlayingTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "FullPlayerVC") as! FullPlayerVC
        present(obj, animated: true, completion: nil)
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
    
    //----------------------------------
    // MARK: Web Services
    //----------------------------------

}
