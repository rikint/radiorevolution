//
//  FullPlayerVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 19/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import StreamingKit
import SVProgressHUD
import MediaPlayer
import Alamofire

class FullPlayerVC: UIViewController, STKAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    //---------------------------------
    // MARK: Outlets
    //---------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var imgSong: UIImageView!
    
    @IBOutlet weak var lblSongName: UILabel!
    
    @IBOutlet weak var btnRepeat: UIButton!
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnShuffle: UIButton!
    
    @IBOutlet weak var seekSlider: UISlider!
    
    @IBOutlet weak var oldOrNewPlaylistView: UIView!
    
    @IBOutlet weak var createPlaylistView: UIView!
    
    @IBOutlet weak var tblPlaylistOption: UITableView!
    
    @IBOutlet weak var btnHideOption: UIButton!
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    //---------------------------------
    // MARK: Identifiers
    //---------------------------------
    
    var playerTimer = Timer()
    var internetTimer = Timer()
    var playlistData = NSMutableArray()
    var playlistId = Int()
    var songId = Int()
    
    //---------------------------------
    // MARK: View Life Cycle
    //---------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtPlaylistName.attributedPlaceholder = NSMutableAttributedString(string: "Username",attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        btnHideOption.isHidden = true
        oldOrNewPlaylistView.isHidden = true
        createPlaylistView.isHidden = true
        tblPlaylistOption.isHidden = true
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        playerTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Loader), userInfo: nil, repeats: true)
        playerTimer.fire()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------
    // MARK: Delegate Methods
    //---------------------------------
    
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
        //print(songProgress.progress)
        print(UInt8((Constant.audioPlayerSTK.state).rawValue))
        
        if Constant.audioPlayerSTK.state == .init(rawValue: 16)
        {
                        if btnRepeat.isSelected
                        {
            
                            playSong()
            
                        }
                        else if btnShuffle.isSelected
                        {
                            Constant.songIndex = Int(arc4random_uniform(UInt32(Constant.SongList.count)))
                            playSong()
                        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return playlistData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let obj = tblPlaylistOption.dequeueReusableCell(withIdentifier: "tblCellPlaylistOption") as! tblCellPlaylistOption
            
            let dic = playlistData[indexPath.row] as! NSDictionary
            
            obj.lblPlaylistName.text = (dic["name"] as! String)
            
            return obj
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
            let dic = playlistData[indexPath.row] as! NSDictionary
            
            playlistId = (dic["id"] as! Int)
            addSongToPlaylistAPI()
        
        
    }
    
    //---------------------------------
    // MARK: User Defined Functions
    //---------------------------------
    
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
            imgSong.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)
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
    
    //---------------------------------
    // MARK: Button Actions
    //---------------------------------
    
    @IBAction func btnCloseTUI(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func btnRepeatTUI(_ sender: UIButton)
    {
        if btnRepeat.isSelected
        {
            btnRepeat.isSelected = false
        }
        else
        {
            btnRepeat.isSelected = true
        }
    }
    @IBAction func btnShuffleTUI(_ sender: UIButton)
    {
        if btnShuffle.isSelected
        {
            btnShuffle.isSelected = false
        }
        else
        {
            btnShuffle.isSelected = true
        }
        
    }
    
    @IBAction func btnAddToPlaylist(_ sender: UIButton)
    {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            let dic = Constant.SongList[Constant.songIndex] as! NSDictionary
            
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
    
    @IBAction func seekSliderVC(_ sender: UISlider)
    {
        Constant.audioPlayerSTK.seek(toTime: Double(sender.value))
    }
    //---------------------------------
    // MARK: Web Services
    //---------------------------------
    
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

}
