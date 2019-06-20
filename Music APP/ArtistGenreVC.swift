//
//  ArtistGenreVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 12/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class ArtistGenreVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    //--------------------------------
    // MARK: Outlets
    //--------------------------------
    
    @IBOutlet weak var tblArtistGenre: UITableView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    //--------------------------------
    // MARK: Identifiers
    //--------------------------------
    
    var Title = String()
    
    //--------------------------------
    // MARK: View Life Cycle
    //--------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        //lblTitle.text = Title
        
        // Do any additional setup after loading the view.
    }
    

    //--------------------------------
    // MARK: Delegate Methods
    //--------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblArtistGenre.dequeueReusableCell(withIdentifier: "tblCellArtistGenre") as! tblCellArtistGenre
        
        return obj
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Constant.urlString = "ArtistGenre"
        Constant.offlineStatus = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MenuItemVcChanged"), object: nil, userInfo: ["Id": "SongListVC"])
        let obj = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
        obj.CurretVC = "SongListVC"
        navigationController?.pushViewController(obj, animated: true)
    }
    
    //--------------------------------
    // MARK: User Defaults
    //--------------------------------
    
    
    
    
    //--------------------------------
    // MARK: Button Actions
    //--------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //--------------------------------
    // MARK: Web Services
    //--------------------------------

}
