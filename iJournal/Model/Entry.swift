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
    var title       : String
    var date        : Date?
    var content     : [Element]
    var profile_id  : DocumentReference?
   
    var documentID  : String?
    var documentRef : DocumentReference?
    
    var tags        :[String]?
    
    /*init(title:String, content:[Element]){
        self.title = title
        self.content = content
    }*/
    
    
    init(title:String, content:[Element], date:Date?, tags:[String] = [], profile_id: DocumentReference, documentRef: DocumentReference? , documentID:String   ) {
        
        self.title       = title
        self.profile_id  = profile_id
        self.documentRef = documentRef
        self.content     = content
        self.date        = date
        if (tags.count == 0){
            var hashtags : [String] = []
            for ele in content{
                if let info = ele.info as? String{
                    let innerHashtags = info.hashtags()
                    for inner in innerHashtags{
                        hashtags.append(inner)
                    }
                }
            }
            self.tags = hashtags
        }
        else{
            self.tags = tags
        }
        
    }
    
    convenience init?(documentSnapshot: DocumentSnapshot) {
        guard let documentData  = documentSnapshot.data(),
            let profile_id      = documentData["profile_id"]    as? DocumentReference,
            let title           = documentData["title"]     as? String,
            let content         = documentData["content"]   as? [[String:Any]],
            let date            = documentData["date"]      as? Timestamp,
            let tags            = documentData["tags"]      as? [String]
            else {
                print("Entry missing essential data.")
                return nil
        }
        
        let id  = documentSnapshot.documentID
        var element : [Element] = [Element]()
        /*for elem in content{
            if let newEl = Element(info: Any, file: <#T##TypeInfo#>)
                element.append(newEl)
            }
        }*/
        let documentReference = FirebaseManager.shared.db.collection("entries").document(documentSnapshot.documentID)
        self.init(title:title, content:element, date:date.dateValue(), tags:tags, profile_id: profile_id, documentRef: documentReference, documentID:id)
    }
    
    func dictionaryRepresentation() -> [String : Any] {
        var array = [[String: Any]]()
        for ele in self.content{
            let cont: [String: Any] = [ ele.file.rawValue : ele.info ]
            array.append(cont)
        }
        return [
            "title"         : self.title,
            "content"       : array,
            "date"          : Date(),//self.date?.timeIntervalSince1970,
            "profile_id"    : self.profile_id as Any,
            "tags"          : self.tags as Any
        ]
    }
}
