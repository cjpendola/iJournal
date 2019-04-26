//
//  UserProfile.swift
//  Tiki
//
//  Created by Carlos Pendola on 4/2/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

/*
 Nombre apellido edad mail número celular
 Luego podríamos en otro lado ( o al registrase ) que diga gustos (puede ser opcional)
 */

import Foundation
import FirebaseFirestore

class UserProfile {
    
    var username                : String
    var usernameCaseInsensitive : String
    var userUID                 : String
    var entries                   : [DocumentReference]
    var documentRef             : DocumentReference?
    var pushNotificationID      : String?
    var profile_image           : String?
    var uiImage                 : UIImage?
    
    init(username: String, userUID: String, documentRef: DocumentReference? = nil, pushNotificationID: String?, entries: [DocumentReference] = [],  profile_image:String ) {
        
        self.username                = username
        self.usernameCaseInsensitive = username.lowercased()
        self.userUID                 = userUID
        self.entries                 = entries
        if let ref = documentRef {
            self.documentRef = ref
        }
        self.pushNotificationID      = pushNotificationID
        self.profile_image              = profile_image
    }
    
    convenience init?(documentSnapshot: DocumentSnapshot) {
        guard let documentData  = documentSnapshot.data(),
            let username      = documentData["username"]   as? String,
            let userUID       = documentData["userUID"]    as? String
            else {
                print("Document missing essential data.")
                return nil
        }
        
        let id  = documentSnapshot.documentID
        var entries               : [DocumentReference] = []
        var pushNotificationID  : String? = nil
        var profile_image       : String = ""
        
        if let id = documentData["pushNotificationID"] as? String {
            pushNotificationID = id
        }
        if let entriesData = documentData["entries"] as? [DocumentReference] {
            entries = entriesData
        }
        if let profile_imageData = documentData["profile_image"] as? String{
            profile_image = profile_imageData
        }
        
        
        self.init(username: username, userUID: userUID, documentRef: FirebaseManager.shared.db.collection("profiles").document(id), pushNotificationID: pushNotificationID,  entries:entries,profile_image:profile_image)
    }
    
    func dictionaryRepresentation() -> [String : Any] {
        return [
            "username"                : self.username,
            "usernameCaseInsensitive" : self.usernameCaseInsensitive,
            "entries"                 : self.entries,
            "userUID"                 : self.userUID,
            "pushNotificationID"      : self.pushNotificationID as Any
        ]
    }
}

