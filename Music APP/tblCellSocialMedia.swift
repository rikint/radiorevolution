//
//  tblCellSocialMedia.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/01/19.
//  Copyright © 2019 Qrioustech. All rights reserved.
//

import UIKit

class tblCellSocialMedia: UITableViewCell
{

    //---------------------------------
    // MARK: Outlets
    //---------------------------------
    
    @IBOutlet weak var imgSocialMedia: UIImageView!
    
    @IBOutlet weak var imgSocialMediaHeight: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
