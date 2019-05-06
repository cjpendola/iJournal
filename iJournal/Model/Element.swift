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
    
    var rawValue: String {
        switch self {
        case .text: return "text"
        case .image: return "image"
        case .audio: return "audio"
        }
    }
}


class Element: Equatable {
    static func == (lhs: Element, rhs: Element) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    var info: Any
    let file: TypeInfo
    var caption: String?
    
    var textView: UITextView?
    var imageView: UIImageView?
    // let sound: AudioFile?
    let uuid = UUID().uuidString
    
    func createUIElement() -> NoteUIElement{
        if self.file == .text {
            let newTextView = UITextView()
            self.textView = newTextView
            return newTextView
            
        }else if self.file == .image {
            let newImageView = UIImageView()
            self.imageView = newImageView
            return newImageView
            
        }else {return UITextView()}
        
    }
    
    
    init(info: Any, file: TypeInfo, textView: UITextView? = nil, imageView: UIImageView? = nil, caption: String? = nil){
        self.info = info
        self.file = file
        self.caption = caption
        self.textView = textView
        self.imageView = imageView
    }
}

protocol NoteUIElement {
    
}

extension UITextView: NoteUIElement {}
extension UIImageView: NoteUIElement {}







/*
import UIKit


enum TypeInfo: String {
    case text
    case image
    case audio
    
    var rawValue: String {
        switch self {
        case .text: return "text"
        case .image: return "image"
        case .audio: return "audio"
        }
    }
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
    
    init?(_ dictionary: [String : Any]) {
        let typeRawString = dictionary.keys.first!
        guard let type = TypeInfo(rawValue: typeRawString) else { return nil }
        switch type {
        case .text:
            guard let info = dictionary.values.first! as? String else { return nil }
            self.info = info
            self.file = type
        case .image:
            guard let info = dictionary.values.first! as? String else { return nil }
            self.info = info
            self.file = type
        case .audio:
            print("I'm better at smash")
            guard let info = dictionary.values.first! as? String else { return nil }
            self.info = info
            self.file = type
        }
    }
}

protocol NoteUIElement {
    
}

extension UITextView: NoteUIElement {}
extension UIImageView: NoteUIElement {}
*/
