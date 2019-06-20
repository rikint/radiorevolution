//
//  tblCellSearchResult.swift
//  Music APP
//
//  Created by Ashutosh Jani on 15/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class tblCellSearchResult: UITableViewCell
{
    
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var imgSong: UIImageView!
    
    @IBOutlet weak var lblSongName: UILabel!
    
    @IBOutlet weak var lblArtistName: UILabel!
    
    @IBOutlet weak var btnOption: UIButton!
    
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnComment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
