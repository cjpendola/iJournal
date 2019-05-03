//
//  ElementController.swift
//  JustLayout
//
//  Created by Colin Smith on 4/29/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit


class ElementController {
    
    var entry: Entry
    var content: [Element]
    
    init(entry: Entry, content: [Element] = []){
        self.content = content
        self.entry = entry
    }
    
    func addContent(newContent: Element){
        content.append(newContent)
    }
    
}

