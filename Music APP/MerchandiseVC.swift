//
//  MerchandiseVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 18/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class MerchandiseVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    @IBOutlet weak var tblCategory: UITableView!
    
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var colMerchandise: UICollectionView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var btnHideCategory: UIButton!
    
    //----------------------------------
    // MARK: Identifiers
    //----------------------------------
    
    var categoryNames = ["All","Tshirt","Caps"]
    
    
    //----------------------------------
    // MARK: View Life Cycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        btnHideCategory.isHidden = true
        tblCategory.isHidden = true
        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        // Do any additional setup after loading the view.
    }
    
    //----------------------------------
    // MARK: Delegate Methods
    //----------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let obj = colMerchandise.dequeueReusableCell(withReuseIdentifier: "colCellMerchandise", for: indexPath) as! colCellMerchandise
        return obj
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2 - 1, height: self.view.frame.width/2 + 50)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let obj = tblCategory.dequeueReusableCell(withIdentifier: "tblCellMerchandiseCategory") as! tblCellMerchandiseCategory
        obj.lblCategoryName.text = categoryNames[indexPath.row]
        return obj
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        btnHideCategory.isHidden = true
        tblCategory.isHidden = true
        btnCategory.setTitle(categoryNames[indexPath.row], for: .normal)
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
    
    @IBAction func btnCategoryTUI(_ sender: UIButton)
    {
        btnHideCategory.isHidden = false
        tblCategory.isHidden = false
    }
    @IBAction func btnHideCategoryTUI(_ sender: UIButton)
    {
        btnHideCategory.isHidden = true
        tblCategory.isHidden = true
    }
    //----------------------------------
    // MARK: Web Services
    //----------------------------------

}
