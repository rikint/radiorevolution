//
//  VimeoVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 19/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class VimeoVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    
    
    //-----------------------------
    // MARK: Outlets
    //-----------------------------
    
    @IBOutlet weak var colVideo: UICollectionView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    //-----------------------------
    // MARK: Identifiers
    //-----------------------------
    
    
    
    
    //-----------------------------
    // MARK: View Life Cycle
    //-----------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        
        // Do any additional setup after loading the view.
    }
    
    //-----------------------------
    // MARK: Delegate Methods
    //-----------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let obj = colVideo.dequeueReusableCell(withReuseIdentifier: "colCellVimeo", for: indexPath) as! colCellVimeo
        return obj
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width/2 - 1, height: self.view.frame.width/2 + 30)
    }
    
    //-----------------------------
    // MARK: User Defined Functions
    //-----------------------------
    
    
    
    //-----------------------------
    // MARK: Button Actions
    //-----------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //-----------------------------
    // MARK: Web Services
    //-----------------------------

}
