//
//  DJDetailsVC.swift
//  LMM
//
//  Created by Ashutosh Jani on 14/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class DJDetailsVC: UIViewController
{
    
    //-------------------------------
    // MARK: Outlets
    //-------------------------------
    
    @IBOutlet weak var imgDJ: UIImageView!
    
    @IBOutlet weak var lblDJDescription: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var btnInstagram: UIButton!
    
    @IBOutlet weak var btnTwitter: UIButton!
    
    @IBOutlet weak var btnSoundCloud: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var headerView: UIView!
    //-------------------------------
    // MARK: Identifiers
    //-------------------------------
    
    var imgUrl = String()
    var djDescription = String()
    var DjName = String()
    var facebookUrl = String()
    var instagramUrl = String()
    var twitterUrl = String()
    var soundCloudUrl = String()
    
    //-------------------------------
    // MARK: View Life Cycle
    //-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        scrollView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        //imgDJ.sd_setImage(with: URL(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "lmm_logo_official_redbg copy"), options: .refreshCached, completed: nil)
        //lblDJDescription.text = djDescription
        lblDJDescription.text = "ghjjcgsjgvcjascjjcdjgscjgscgjjcdagsc"
//        if facebookUrl == ""
//        {
//            btnFacebook.isHidden = true
//        }
//        if twitterUrl == ""
//        {
//            btnTwitter.isHidden = true
//        }
//        if instagramUrl == ""
//        {
//            btnInstagram.isHidden = true
//        }
//        if soundCloudUrl == ""
//        {
//            btnSoundCloud.isHidden = true
//        }
        
        
        //lblTitle.text = DjName
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        scrollViewHeight.constant = 400 + lblDJDescription.bounds.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //-------------------------------
    // MARK: User Defined Function
    //-------------------------------
    
    
    //-------------------------------
    // MARK: Button Actions
    //-------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFacebookTUI(_ sender: UIButton)
    {
        let customURL = facebookUrl
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    
    @IBAction func btnInstagramTUI(_ sender: UIButton)
    {
        let customURL = instagramUrl
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    @IBAction func btnTwitterTUI(_ sender: UIButton)
    {
        let customURL = twitterUrl
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    
    @IBAction func btnSoundCloudTUI(_ sender: UIButton)
    {
        let customURL = soundCloudUrl
        
        if UIApplication.shared.canOpenURL(NSURL(string: customURL)! as URL)
        {
            //UIApplication.shared.openURL(NSURL(string: customURL)! as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: customURL)! as URL, options: [customURL: customURL], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            
        }
    }
    
}
