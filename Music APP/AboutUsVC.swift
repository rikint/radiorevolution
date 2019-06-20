//
//  AboutUsVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 16/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AboutUsVC: UIViewController
{
    
    //--------------------------------
    // MARK: Outlets
    //--------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imgSlider: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //--------------------------------
    // MARK: Identifiers
    //--------------------------------
    
    var imageData = [String()]
    var swipeLeftTransition = CATransition()
    var swipeRightTransition = CATransition()
    var count = 0
    var sliderTimer = Timer()
    var internetTimer = Timer()
    
    //--------------------------------
    // MARK: View Life Cycle
    //--------------------------------
    override func viewDidLoad()
    {
        aboutUsAPI()
        
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
//        txtAboutUs.text = (txtAboutUs.text as NSString).uppercased
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //----------------------------------
    // MARK: User Defined Functions
    //----------------------------------
    
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
                        pageControl.currentPage = count
                        
                        
                    }
                    else
                    {
                        count -= 1
                        imgSlider.layer.add(swipeRightTransition, forKey: "swipeRightTransition")
                        imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                        pageControl.currentPage = count
                        
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
                        pageControl.currentPage = count
                    }
                    else
                    {
                        count += 1
                        imgSlider.layer.add(swipeLeftTransition, forKey: "swipeLeftTransition")
                        imgSlider.sd_setImage(with: URL(string: imageData[count] ), placeholderImage: UIImage(named: "radioRevolutionSlpashIcon"), options: .refreshCached, completed: nil)
                        pageControl.currentPage = count
                    }
                }
                
                print("Swiped left")
            default: print("Unrecognised Gesture")
                break
            }
            
        }
    }
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            self.aboutUsAPI()
            SVProgressHUD.show()
        }
        else
        {
            
            Constant.PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
        }
    }
    
    //--------------------------------
    // MARK: Button Actions
    //--------------------------------

    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    //--------------------------------
    // MARK: Web Services
    //--------------------------------

    
    func aboutUsAPI()
    {
        //        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userId")]
        //        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            internetTimer.invalidate()
            SVProgressHUD.show()
            Alamofire.request(appDelegate.apiString + "aboutus", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
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
                            self.imageData = (result["data"] as! [String])
                            //self.videoData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                            //self.colFeaturedTracks.reloadData()
                            if self.imageData.count != 0
                            {
                                self.imgSlider.sd_setImage(with: URL(string: self.imageData[0] ), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)

                                self.pageControl.numberOfPages = self.imageData.count
                            }
                            
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
