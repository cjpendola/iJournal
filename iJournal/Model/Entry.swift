//
//  Entry.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/25/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//


import Foundation
import FirebaseFirestore

class Entry {
    
    var documentID         : String?
    var documentRef        : DocumentReference?
    var userUID                 : String
    var profile_id              : DocumentReference
    var data                    : [[String:Any]]   ///text, audios, images, etc
    var date                    : Date
    
    
    init(userUID: String, profile_id: DocumentReference, documentRef: DocumentReference? , documentID:String, data:[[String:Any]], date:Date = Date() ) {
        
        self.userUID     = userUID
        self.profile_id  = profile_id
        self.documentRef = documentRef
        self.data        = data
        self.date        = date
    
    }
    
    convenience init?(documentSnapshot: DocumentSnapshot) {
        guard let documentData  = documentSnapshot.data(),
            let profile_id      = documentData["profile_id"]  as? DocumentReference,
            let userUID         = documentData["userUID"]   as? String,
            let data            = documentData["data"]      as? [[String:Any]]
            else {
                print("Entry missing essential data.")
                return nil
        }
        
        let id  = documentSnapshot.documentID
        let documentReference = FirebaseManager.shared.db.collection("entries").document(documentSnapshot.documentID)
        self.init(userUID: userUID, profile_id: profile_id, documentRef: documentReference,documentID:id, data:data, date:Date() )
    }
    
    func dictionaryRepresentation() -> [String : Any] {
        return [
            "userUID"       : self.userUID,
            "profile_id"    : self.profile_id,
            "data"          : self.data,
            "date"          : self.date
        ]
    }
}

