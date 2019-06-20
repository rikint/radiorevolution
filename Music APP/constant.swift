//
//  constant.swift
//  Music APP
//
//  Created by Ashutosh Jani on 19/09/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import Foundation
import UIKit
import StreamingKit
import AVKit

struct Constant
{
    static var title = String()
    static var genreId = Int()
    static var currentVC = String()
    static var requestParameter = [String:Any]()
    static var urlString = String()
    static var audioPlayerSTK = STKAudioPlayer()
    static var songIndex = -1
    static var SongList = NSMutableArray()
    static var radioPlayer = STKAudioPlayer()
    static var playerItem : AVPlayerItem!
    static var tabbarBackgroundColor = 0x7337b6
    static var playerBackgroudColor = 0x060606
    static var backgroundColor = 0xFFFFFF
    static var themeColor = 0x000000
    static var djNameScreen = 0
    static var playlistIdRemoveSong = Int()
    /*
     0 = dj biography
     1 = dj Packages
     2 = chatroom
    */
    static var offlineStatus = 0
    
    //static var urlString = String()
    
    

    
    static func PopUp(Controller: UIViewController, title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        Controller.present(alert, animated: true, completion: nil)
    }
    
    static func validateEmailWithString(_ Email: NSString) -> Bool {
        //let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !emailTest.evaluate(with: Email)
    }
}

func shareSong(view: UIView, self: UIViewController, text: String, img: UIImage)
{
    
    // set up activity view controller
    let textToShare = [ text, img ] as [Any]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    //activityViewController.excludedActivityTypes = ([ UIActivityType.airDrop ] as! [UIActivityType])
    //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
    
    // present the view controller
    self.present(activityViewController, animated: true, completion: nil)
}

func shareEvent(view: UIView, self: UIViewController, text: String, img: UIImage)
{
    
    // set up activity view controller
    let textToShare = [ text, img ] as [Any]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = ([ UIActivityType.airDrop, "net.whatsapp.WhatsApp.ShareExtension" ] as! [UIActivityType])
    
    // present the view controller
    self.present(activityViewController, animated: true, completion: nil)
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
class WhatsAppActivity : UIActivity
{
    
    override init()
    {
        self.text = ""
        
    }
    
    var text:String?
    
    
    func activityType()-> String
    {
        return NSStringFromClass(self.classForCoder)
    }
    
    func activityImage()-> UIImage
    {
        return UIImage(named: "whatsapp2")!;
    }
    
    func activityTitle() -> String
    {
        return "WhatsApp";
    }
    
    class func activityCategory() -> UIActivityCategory
    {
        return UIActivityCategory.share
    }
    
    func getURLFromMessage(message:String)-> NSURL
    {
        var url = "whatsapp://"
        
        if (message != "")
        {
            url = "\(url)send?text=\(message)"
        }
        
        return NSURL(string: url)!
    }
    
    func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool
    {
        for activityItem in activityItems
        {
            if ((activityItem.isKind(of:)) != nil)
            {
                self.text = activityItem as? String;
                var whatsAppURL:NSURL  = self.getURLFromMessage(message: self.text!)
                return UIApplication.shared.canOpenURL(whatsAppURL as URL)
            }
        }
        return false;
    }
    
    func prepareWithActivityItems(activityItems: [AnyObject])
    {
        for activityItem in activityItems
        {
            if((activityItem.isKind(of:)) != nil)
            {
                let whatsAppUrl:NSURL = self.getURLFromMessage(message: self.text!)
                if(UIApplication.shared.canOpenURL(whatsAppUrl as URL))
                {
                    UIApplication.shared.openURL(whatsAppUrl as URL)
                }
                break;
            }
        }
    }
}

