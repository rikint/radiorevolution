//
//  EventDetailsVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 16/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class EventDetailsVC: UIViewController
{
    
    //--------------------------------
    // MARK: Outlets
    //--------------------------------
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var imgEvent: UIImageView!
    
    @IBOutlet weak var lblEventName: UILabel!
    
    @IBOutlet weak var lblEventAddress: UILabel!
    
    @IBOutlet weak var lblEventDate: UILabel!
    
    @IBOutlet weak var imgBanner: UIImageView!
    
    @IBOutlet weak var lblEventDescription: UILabel!
    
    @IBOutlet weak var btnBook: UIButton!
    
    @IBOutlet weak var BookingScrollViewHeight: NSLayoutConstraint!
    
    
    //--------------------------------
    // MARK: Identifiers
    //--------------------------------
    
    var eventName = String()
    var eventAddress = String()
    var eventDate = String()
    var eventTime = String()
    var imageString = String()
    var eventDescription = String()
    
    
    //--------------------------------
    // MARK: View Life Cycle
    //--------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        btnBook.layer.cornerRadius = 5
        btnBook.layer.borderColor = UIColor.lightGray.cgColor
        btnBook.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        lblEventName.text = eventName
        lblEventDate.text = eventDate + " " + eventTime
        lblEventAddress.text = eventAddress
        lblEventDescription.text = eventDescription
        imgEvent.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)
        imgBanner.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "radioRevolutionSplashIcon"), options: .refreshCached, completed: nil)
        
        BookingScrollViewHeight.constant = 570 + lblEventDescription.frame.height
        
    }

    //--------------------------------
    // MARK: Delegate Methods
    //--------------------------------
    
    
    
    
    //--------------------------------
    // MARK: User Defined Function
    //--------------------------------
    
    
    
    
    //--------------------------------
    // MARK: Button Actions
    //--------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareTUI(_ sender: UIButton)
    {
        
        shareEvent(view: self.view, self: self, text: """
            Event Name : \(eventName)
            
            Event Description : \(eventDescription)
            
            Date : \(eventDate)
            
            Time : \(eventTime)
            
            Address : \(eventAddress)
            
            App Name : Radio Revolution
            """, img: imgEvent.image!)
    }
    
    
    //--------------------------------
    // MARK: Web Services
    //--------------------------------

}
