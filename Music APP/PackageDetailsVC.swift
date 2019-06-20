//
//  PackageDetailsVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class PackageDetailsVC: UIViewController
{
    
    
    //---------------------------
    // MARK: Outlets
    //---------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var imgPackage: UIImageView!
    
    @IBOutlet weak var lblPackageName: UILabel!
    
    @IBOutlet weak var lblPackagePrice: UILabel!
    
    @IBOutlet weak var lblPackageDescription: UILabel!
    
    @IBOutlet weak var btnBook: UIButton!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    
    //---------------------------
    // MARK: Identifiers
    //---------------------------
    
    
    
    //---------------------------
    // MARK: View Life Cycle
    //---------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        btnBook.layer.cornerRadius = 5
        btnBook.layer.borderColor = UIColor.lightGray.cgColor
        btnBook.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollViewHeight.constant = 450 + lblPackageDescription.frame.height
    }
    
    //---------------------------
    // MARK: Delegate Methods
    //---------------------------
    
    
    //-------------------------------
    // MARK: User Defined Functions
    //-------------------------------
    
    
    
    //---------------------------
    // MARK: Button Actions
    //---------------------------
    @IBAction func btnBookingTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    //---------------------------
    // MARK: Web Services
    //---------------------------

}
