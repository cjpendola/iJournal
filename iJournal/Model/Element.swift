//
//  Element.swift
//  JustLayout
//
//  Created by Colin Smith on 4/29/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit


enum TypeInfo {
    case text
    case image
    case audio
}


class Element: Equatable {
    static func == (lhs: Element, rhs: Element) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    let info: Any
    let file: TypeInfo
    // let sound: AudioFile?
    let uuid = UUID().uuidString
    
    func createUIElement() -> NoteUIElement{
        if self.file == .text {
            return UITextView()
            
        }else if self.file == .image {
            return UIImageView()
            
        }else {return UITextView()}
        
    }
    
    
    init(info: Any, file: TypeInfo){
        self.info = info
        self.file = file
    }
}

protocol NoteUIElement {
    
}

extension UITextView: NoteUIElement {}
extension UIImageView: NoteUIElement {}

