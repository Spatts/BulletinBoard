//
//  MessagesController.swift
//  BulletinBoard
//
//  Created by Spencer Curtis on 8/2/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation

let MessagesControllerDidRefreshNotification = "MessagesControllerDidRefreshNotification"

class MessagesController {
    
    static let sharedController = MessagesController()
    
    private let cloudKitManager = CloudKitManager()
    
    private (set) var messages = [Message]() {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              NSNotificationCenter.defaultCenter().postNotificationName(MessagesControllerDidRefreshNotification, object: self)
            })
        }
    
    }
    
    init() {
        fetchMessages { (error) in
            if let error = error {
                print("Error fetching messages on startup: \(error.localizedDescription)")
            }
        }
    
    }
    
    
    func fetchMessages(completion: (NSError?) -> Void) {
        
        let sortDescriptors = [NSSortDescriptor(key: Message.DateKey, ascending: false)]
        
        cloudKitManager.fetchRecordsWithType(Message.RecordType, sortDescriptors: sortDescriptors) { (records, error) in
            
            defer { completion(error) }
            
            if let error = error {
                print("Error fetching messages: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else { return }
            
            self.messages = records.flatMap({Message(cloudKitRecord: $0)})
            
        }
        
    }
    
    func postNewMessage(message: Message, completion: ((NSError?)-> Void) = {_ in}) {
        cloudKitManager.saveRecord(message.cloudKitRecord) { (error) in
            if error == nil {
                self.messages.append(message)
            }
            completion(error)
        }
    }
    
    func subscribeForPushNotifications(completion: ((NSError?)-> Void)? = nil) {
        cloudKitManager.subscribeToCreationOfRecordsWithType(Message.RecordType) { (error) in
            if let error = error {
                print("Error saving subscription: \(error.localizedDescription)")
            } else {
                print("Subscribed to push notifications for new messages")
            }
            completion?(error)
        }
    
    }
    
    
}











