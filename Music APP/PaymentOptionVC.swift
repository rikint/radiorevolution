//
//  PaymentOptionVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 19/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class PaymentOptionVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    
    //------------------------------
    // MARK: Outlets
    //------------------------------

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var tblPaymentOption: UITableView!
    
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    var paymentOptionArr = ["Credit/Debit Card", "Paypal", "Crypto Currency", "Wallets"]
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = UIColor(rgb: Constant.backgroundColor)
        // Do any additional setup after loading the view.
    }
    
    //------------------------------
    // MARK: Delegate Methods
    //------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentOptionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblPaymentOption.dequeueReusableCell(withIdentifier: "tblCellPaymentOption") as! tblCellPaymentOption
        obj.lblPaymentOption.text = paymentOptionArr[indexPath.row]
        return obj
    }
    //------------------------------
    // MARK: User Defined Function
    //------------------------------
    
    
    //------------------------------
    // MARK: Button Actions
    //------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    //------------------------------
    // MARK: Web Services
    //------------------------------

}
