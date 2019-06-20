//
//  GalleryVC.swift
//  LMM
//
//  Created by Ashutosh Jani on 13/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
//import Alamofire
//import SVProgressHUD
//import SDWebImage
//import UPCarouselFlowLayout

class GalleryVC: UIViewController, UIGestureRecognizerDelegate
{
    
    //----------------------------
    // MARK: Outlets
    //----------------------------
    
    @IBOutlet weak var imgShow: UIImageView!
    
    @IBOutlet weak var colGallery: UICollectionView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    //----------------------------
    // MARK: Identifiers
    //----------------------------
    
    var imageUrl = [String]()
    var swipeLeftTransition = CATransition()
    var swipeRightTransition = CATransition()
    var count = 0
    var sliderTimer = Timer()
    var pinchGesture = UIPinchGestureRecognizer()
    var lastScale = CGFloat()
    
    //----------------------------
    // MARK: View Life Cycle
    //----------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //imgShow.sd_setImage(with: URL(string: imageUrl[count]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
        
        galleryPageControl.numberOfPages = imageUrl.count
        galleryPageControl.currentPage = count
        //let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        //swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        //self.imgShow.addGestureRecognizer(swipeLeft)
        
        //let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        //swipeRight.direction = UISwipeGestureRecognizerDirection.right
        //self.imgShow.addGestureRecognizer(swipeRight)
        self.pinchGesture.delegate = self
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecognized(pinch:)))
        self.imgShow.addGestureRecognizer(self.pinchGesture)
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //----------------------------
    // MARK: Delegate Method
    //----------------------------
    
    
    //----------------------------
    // MARK: User Defined Function
    //----------------------------
    
    
    
    
//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
//    {
//
//
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer
//        {
//
//            switch swipeGesture.direction
//            {
//            case UISwipeGestureRecognizerDirection.right:
//                if imageUrl.count == 1
//                {
//
//                    imgShow.sd_setImage(with: URL(string: imageUrl[0]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
//                }
//                else
//                {
//                    if count == 0
//                    {
//                        count = imageUrl.count - 1
//
//
//                        imgShow.layer.add(swipeRightTransition, forKey: "swipeRightTransition")
//                        imgShow.sd_setImage(with: URL(string: imageUrl[count]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
//
//                        galleryPageControl.currentPage = count
//
//                    }
//                    else
//                    {
//                        count -= 1
//
//                        imgShow.layer.add(swipeRightTransition, forKey: "swipeRightTransition")
//                        imgShow.sd_setImage(with: URL(string: imageUrl[count]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
//                        galleryPageControl.currentPage = count
//
//                    }
//                }
//
//
//
//                print("Swiped right")
//            case UISwipeGestureRecognizerDirection.left:
//
//                if imageUrl.count == 1
//                {
//
//                    imgShow.sd_setImage(with: URL(string: imageUrl[0]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
//                }
//                else
//                {
//                    if count == imageUrl.count - 1
//                    {
//                        count = 0
//                        imgShow.layer.add(swipeLeftTransition, forKey: "swipeLeftTransition")
//                        imgShow.sd_setImage(with: URL(string: imageUrl[count]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
//                        galleryPageControl.currentPage = count
//                    }
//                    else
//                    {
//                        count += 1
//                        imgShow.layer.add(swipeLeftTransition, forKey: "swipeLeftTransition")
//                        imgShow.sd_setImage(with: URL(string: imageUrl[count]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
//                        galleryPageControl.currentPage = count
//                    }
//                }
//
//                print("Swiped left")
//            default: print("Unrecognised Gesture")
//                break
//            }
//
//        }
//    }
    
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer)
    {
        if pinch.state == .began
        {
            lastScale = pinch.scale
            print(lastScale)
        }
        
        else if pinch.state == .ended
        {
            imgShow.transform = imgShow.transform.scaledBy(x: 1, y: 1)
            
           print("pinch ended")
            
        }
        else
        {
            print("pinch started")
            let currentScale = pinch.view!.layer.value(forKeyPath:"transform.scale")! as! CGFloat
            // Constants to adjust the max/min values of zoom
            let kMaxScale:CGFloat = 2.0
            let kMinScale:CGFloat = 1.0
            var newScale = 1 -  (lastScale - pinch.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform = (pinch.view?.transform)!.scaledBy(x: newScale, y: newScale);
            pinch.view?.transform = transform
//            pinch.view!.transform = pinch.view!.transform.scaledBy(x:
//               1 - pinch.scale, y: 1 - pinch.scale)
            print(pinch.scale)
        }
//        let fontSize = self.textview1.font!.pointSize*(pinch.scale)/2
//        if fontSize > 12 && fontSize < 32{
//            textview1.font = UIFont(name: self.textview1.font!.fontName, size:fontSize)
//        }
    }
    
    //----------------------------
    // MARK: Button Actions
    //----------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    //----------------------------
    // MARK: Web Services
    //----------------------------

    
    
}
