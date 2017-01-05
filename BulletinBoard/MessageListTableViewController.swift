//
//  MessageListTableViewController.swift
//  BulletinBoard
//
//  Created by Spencer Curtis on 8/2/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class MessageListTableViewController: UITableViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(messagesWereUpdated), name: MessagesControllerDidRefreshNotification, object: nil)
        
    }
    
    func messagesWereUpdated() {
    self.tableView.reloadData()
    
    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        guard let text = messageTextField.text else {return}
        let message = Message(messageText: text, date: NSDate())
        MessagesController.sharedController.postNewMessage(message)
        messageTextField.resignFirstResponder()
        messageTextField.text = " "
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesController.sharedController.messages.count
    }

    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        
        let messages = MessagesController.sharedController.messages[indexPath.row]

        cell.textLabel?.text = messages.messageText
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(messages.date)
        
        return cell
    }
}
