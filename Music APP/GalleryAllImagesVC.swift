//
//  GalleryAllImagesVC.swift
//  LMM
//
//  Created by Ashutosh Jani on 10/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit
//import Alamofire
//import SVProgressHUD

class GalleryAllImagesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    //----------------------------------------
    // MARK: Outlets
    //----------------------------------------
    
    @IBOutlet weak var colGalleryImage: UICollectionView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    //----------------------------------------
    // MARK: Identifiers
    //----------------------------------------
    
    var galleryData = NSMutableArray()
    var internetTimer = Timer()
    var imgArray = [String]()
    
    //----------------------------------------
    // MARK: View Life Cycle
    //----------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        //GalleryDataAPI()
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        // Do any additional setup after loading the view.
    }
    
    //----------------------------------------
    // MARK: Delegate Methods
    //----------------------------------------

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        //return imgArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let obj = colGalleryImage.dequeueReusableCell(withReuseIdentifier: "colCellGallerySmallImage", for: indexPath) as! colCellGallerySmallImage

        obj.imgGallery.image = UIImage(named: "IMG-20181011-WA0038")
        //obj.imgGallery.sd_setImage(with: URL(string: imgArray[indexPath.row]), placeholderImage: UIImage(named: "LLM_Icon"), options: .refreshCached, completed: nil)
        
        return obj
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/3 - 1, height: self.view.frame.width/3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        let obj = storyboard?.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
//        obj.count = indexPath.row
//        obj.imageUrl = imgArray
//        present(obj, animated: true, completion: nil)
        
    }
    
    //----------------------------------------
    // MARK: User Defined Functions
    //----------------------------------------
    
//    @objc func galleryDataApiIntChk()
//    {
//        if Connectivity.isConnectedToInternet()
//        {
//            GalleryDataAPI()
//            SVProgressHUD.show()
//        }
//        else
//        {
//            
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//    }
    
    
    //----------------------------------------
    // MARK: Button Actions
    //----------------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //----------------------------------------
    // MARK: Web Services
    //----------------------------------------
    
//    func GalleryDataAPI()
//    {
//
//        //let parameter = ["u_id":"F6EF4225-624B-42FB-A354-119F5066A59E"]
//        print(parameter)
//        if Connectivity.isConnectedToInternet()
//        {
//            internetTimer.invalidate()
//            SVProgressHUD.show()
//            Alamofire.request("https://api.instagram.com/v1/users/self/media/recent/?access_token=1539656103.4103454.9add5247b73d462188821bfeeee19194", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
//                {
//                    response in
//                    switch response.result
//                    {
//                    case .success:
//                        print("Validation Successful")
//                        let result = response.result.value! as! NSDictionary
//                        print(result)
//
//                        self.galleryData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
//                        for i in 0...self.galleryData.count - 1
//                        {
//                            let dic = self.galleryData[i] as! NSDictionary
//                            let dic1 = dic["images"] as! NSDictionary
//                            let dic2 = dic1["standard_resolution"] as! NSDictionary
//                            self.imgArray.append(dic2["url"] as! String)
//                        }
//
//
//                       self.colGalleryImage.reloadData()
//                        SVProgressHUD.dismiss()
//
//
//
//
//                    case .failure(let error):
//                        print(error)
//                    }
//            }
//
//        }
//        else
//        {
//            self.internetTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.galleryDataApiIntChk), userInfo: nil, repeats: true)
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//
//
//    }
}
