//
//  Section.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/4/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import Foundation

struct Section {
    var name: String!
    var tags: [String]!
    var expanded: Bool!
    
    init(name: String, tags: [String], expanded: Bool) {
        self.name = name
        self.tags = tags
        self.expanded = expanded
    }
}

