//
//  YoutubeVideoVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 16/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class YoutubeVideoVC: UIViewController
{
    
    //---------------------------------
    // MARK: Outlets
    //---------------------------------
    
    @IBOutlet weak var videoWebView: WKWebView!
    
    //---------------------------------
    // MARK: Identifiers
    //---------------------------------
    
    var videoUrl = String()
    var timer = Timer()
    
    //---------------------------------
    // MARK: View Life Cycle
    //---------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        videoWebView.load(URLRequest(url: URL(string: videoUrl)!))
        print(videoUrl)
        SVProgressHUD.show()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.loader), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------
    // MARK: User Defined Function
    //---------------------------------
    
    @objc func loader() {
        
        if !videoWebView.isLoading{
            
            SVProgressHUD.dismiss()
        }
    }
    
    //---------------------------------
    // MARK: Button Actions
    //---------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }

}
