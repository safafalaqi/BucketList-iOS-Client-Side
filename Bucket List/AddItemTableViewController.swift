//
//  AddItemTableViewController.swift
//  Bucket List (iOS Client-Side)
//  Bucket List (Adding Tasks)
//  Bucket List IV
//  Created by Safa Falaqi on 22/12/2021.
// https://github.com/rodleyva/BucketServer/tree/master


import UIKit

class AddItemTableViewController: UITableViewController {

    var item:String?
    var indexPath:NSIndexPath?
    
    @IBOutlet weak var itemText: UITextField!
    weak var delegate:AddItemTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemText.text = item
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    @IBAction func savedButtonPressed(_ sender: UIBarButtonItem) {
        let text = itemText.text!
        delegate?.itemSaved(by: self,with: text, at: indexPath)
    }
}
