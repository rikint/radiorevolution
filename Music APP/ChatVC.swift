//
//  ChatVC.swift
//  Music APP
//
//  Created by Ashutosh Jani on 23/10/18.
//  Copyright © 2018 Qrioustech. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    
    
    
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var tblChat: UITableView!
    
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var btnRecord: UIButton!
    
    @IBOutlet weak var typeMsgView: UIView!
    
    @IBOutlet weak var txtMessage: UITextField!
    
    @IBOutlet weak var recordingView: UIView!
    
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    
    
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        btnSend.isHidden = true
        typeMsgView.layer.cornerRadius = 20
        txtMessage.delegate = self
        txtMessage.addTarget(self, action: #selector(txtMessageValueChanged), for: .editingChanged)
        recordingView.isHidden = true
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        btnRecord.addGestureRecognizer(longGesture)
        // Do any additional setup after loading the view.
    }
    
    
    //------------------------------
    // MARK: Delegate Methods
    //------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row%2 == 0
        {
            let obj = tblChat.dequeueReusableCell(withIdentifier: "tblCellSentMessage") as! tblCellSentMessage
            let attrsA = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 16.0)]
            let a = NSMutableAttributedString(string:String(format: "%@", String(describing: "Hello World!!")), attributes:attrsA)
            let attrsB =  [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10.0)]
            let b = NSAttributedString(string:"\n\n\(String(format: "%@", String(describing: "10:35 AM")))", attributes:attrsB)
            a.append(b)
            obj.lblMsg.attributedText! = a
            //obj.lblMsg.text = "hsdbcjhasbjchbasjhdbcajshdbcjasbdcjhbbjhbjs bjhbdjbshjbcjhschjs cjsdjhbcshjdbcjhsbdcjhbsjcbsjbc"
            obj.msgView.layer.cornerRadius = 10
            return obj
        }
        else
        {
            let obj = tblChat.dequeueReusableCell(withIdentifier: "tblCellReceivedMessage") as! tblCellReceivedMessage
            let attrsA = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 16.0)]
            let a = NSMutableAttributedString(string:String(format: "%@", String(describing: "hsdbcjhasbjchbasjhdbcajshdbcjasbdcjhbbjhbjs bjhbdjbshjbcjhschjs cjsdjhbcshjdbcjhsbdcjhbsjcbsjbchsdbcjhasbjchbasjhdbcajshdbcjasbdcjhbbjhbjs bjhbdjbshjbcjhschjs cjsdjhbcshjdbcjhsbdcjhbsjcbsjbchsdbcjhasbjchbasjhdbcajshdbcjasbdcjhbbjhbjs bjhbdjbshjbcjhschjs cjsdjhbcshjdbcjhsbdcjhbsjcbsjbc")), attributes:attrsA)
            let attrsB = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10.0)]
            let b = NSAttributedString(string:"\n\n\(String(format: "%@", String(describing: "10:35 AM")))", attributes:attrsB)
            a.append(b)
            obj.lblMsg.attributedText! = a
            //obj.lblMsg.text = "hsdbcjhasbjchbasjhdbcajshdbcjasbdcjhbbjhbjs bjhbdjbshjbcjhschjs cjsdjhbcshjdbcjhsbdcjhbsjcbsjbchsdbcjhasbjchbasjhdbcajshdbcjasbdcjhbbjhbjs bjhbdjbshjbcjhschjs cjsdjhbcshjdbcjhsbdcjhbsjcbsjbchsdbcjhasbjchbasjhdbcajshdbcjasbdcjhbbjhbjs bjhbdjbshjbcjhschjs cjsdjhbcshjdbcjhsbdcjhbsjcbsjbc"
            obj.msgView.layer.cornerRadius = 10
            return obj
        }
    }
    
    //------------------------------
    // MARK: User Defined Functions
    //------------------------------
    
    @objc func txtMessageValueChanged()
    {
        if txtMessage.text! == "" || (txtMessage.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            btnSend.isHidden = true
            btnRecord.isHidden = false
        }
        else
        {
            btnSend.isHidden = false
            btnRecord.isHidden = true
        }
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer)
    {
        if sender.state == .began
        {
            recordingView.isHidden = false
        }
        else if sender.state == .ended
        {
            recordingView.isHidden = true
        }
    }
    
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
