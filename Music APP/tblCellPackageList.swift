//
//  tblCellPackageList.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class tblCellPackageList: UITableViewCell
{
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var imgPackage: UIImageView!
    
    @IBOutlet weak var lblPackageName: UILabel!
    
    @IBOutlet weak var lblPackagePrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
