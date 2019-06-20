//
//  tblCellMenu.swift
//  Music APP
//
//  Created by Ashutosh Jani on 15/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class tblCellMenu: UITableViewCell
{
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var lblMenuItem: UILabel!
    
    @IBOutlet weak var imgMenu: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
