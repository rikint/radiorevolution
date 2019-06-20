//
//  tblCellPaymentOption.swift
//  Music APP
//
//  Created by Ashutosh Jani on 19/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class tblCellPaymentOption: UITableViewCell
{
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var imgPaymentOption: UIImageView!
    
    @IBOutlet weak var lblPaymentOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
