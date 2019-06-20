//
//  tblCellPlaylist.swift
//  Music APP
//
//  Created by Ashutosh Jani on 14/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class tblCellPlaylist: UITableViewCell
{
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var imgPlaylist: UIImageView!
    
    @IBOutlet weak var lblPlaylistName: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lblTrackCount: UILabel!
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
