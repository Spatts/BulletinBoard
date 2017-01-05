//
//  Message + CloudKit.swift
//  BulletinBoard
//
//  Created by Spencer Curtis on 8/2/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CloudKit

extension Message {
    
    static var RecordType: String { return "Message" }
    static var MessageTextKey: String { return "MessageText" }
    static var DateKey: String { return "Date" }
    
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: Message.RecordType)
        record.setValue(messageText, forKey: Message.MessageTextKey)
        record[Message.DateKey] = date
        
        return record
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let messageText = cloudKitRecord[Message.MessageTextKey] as? String, date = cloudKitRecord[Message.DateKey] as? NSDate where cloudKitRecord.recordType == Message.RecordType else { return nil }
        
        self.init(messageText: messageText, date: date)
    }
    
    
}