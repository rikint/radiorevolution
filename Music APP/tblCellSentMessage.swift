//
//  tblCellSentMessage.swift
//  Music APP
//
//  Created by Ashutosh Jani on 23/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class tblCellSentMessage: UITableViewCell
{
    
    
    
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var msgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
