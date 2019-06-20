//
//  PackagesListVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 17/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class PackagesListVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var tblPackageList: UITableView!
    
    
    //----------------------------------
    // MARK: Identifiers
    //----------------------------------
    
    
    //----------------------------------
    // MARK: View Life Cycle
    //----------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        // Do any additional setup after loading the view.
    }
    

    //----------------------------------
    // MARK: Delegate Methods
    //----------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblPackageList.dequeueReusableCell(withIdentifier: "tblCellPackageList") as! tblCellPackageList
        return obj
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "PackageDetailsVC") as! PackageDetailsVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    //----------------------------------
    // MARK: User Defined Functions
    //----------------------------------
    
    
    
    //----------------------------------
    // MARK: Button Actions
    //----------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    //----------------------------------
    // MARK: Web Services
    //----------------------------------

}
