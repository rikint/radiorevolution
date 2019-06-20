//
//  tblCellEventList.swift
//  Music APP
//
//  Created by Ashutosh Jani on 16/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class tblCellEventList: UITableViewCell
{
    
    @IBOutlet weak var imgEvent: UIImageView!
    
    @IBOutlet weak var lblEventName: UILabel!
    
    @IBOutlet weak var lblEventAddress: UILabel!
    
    @IBOutlet weak var lblEventDate: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
