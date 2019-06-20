//
//  SponsoredImageVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 18/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class SponsoredImageVC: UIViewController
{
    
    //------------------------------
    // MARK: Outlets
    //------------------------------

    @IBOutlet weak var imgSponsor: UIImageView!
    
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //------------------------------
    // MARK: User Defined Function
    //------------------------------
    
    //------------------------------
    // MARK: Button Actions
    //------------------------------
    
    @IBAction func btnCloseTUI(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    //------------------------------
    // MARK: Web Services
    //------------------------------
}
