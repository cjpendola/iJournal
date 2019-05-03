//
//  EditEntryViewController.swift
//  JustLayout
//
//  Created by Colin Smith on 4/28/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {

    var entry: Entry?
    var elements: [Element] = []
    let endScrollFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    lazy var bottomScrollView = UIView(frame: endScrollFrame)
    var count = 1
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        guard let entry = entry else {return}
        loadElements(entry: entry)
        
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[ UIResponder.keyboardFrameBeginUserInfoKey ] as! NSValue).cgRectValue
        let keyboardViewEndFrame =  view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            self.scrollView?.contentInset = UIEdgeInsets.zero
            scrollView.contentOffset.y = 0
        }else{
            self.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            scrollView.contentOffset.y = keyboardViewEndFrame.height - 50
        }
        scrollView?.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func loadElements(entry: Entry){
        titleLabel.text = entry.title
        guard entry.content.count > 0 else {
            return
        }
        
        for element in entry.content {
            switch element.file {
                case .text:
                    guard let text = element.info as? String else { continue }
                    let textView = newTextView(with: text)
                    contentStackView.addArrangedSubview(textView)
                    textView.tag = count
                    self.count += 1
                case .image:
                    guard let info =  element.info as? String else { return }
                    let photoImageView = UIImageView(  )
                    photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1.0/2.0).isActive = true
                    photoImageView.contentMode = .scaleAspectFit
                    photoImageView.clipsToBounds = true
                    photoImageView.tag = self.count
                    self.contentStackView.addArrangedSubview(photoImageView)
                    
                    EntryController.shared.fetchImage(url: info, count:self.count ) { (image, number) in
                        if (image != nil){
                            DispatchQueue.main.async {
                                if let photoImageViewReturn = self.contentStackView.viewWithTag(number) as? UIImageView {
                                    photoImageViewReturn.image = image?.fixOrientation()
                                }
                            }
                        }
                    }
                    self.count += 1
                default:
                    print("add audio later")
                    self.count += 1
            }
           
            if element == entry.content.last! && element.file == .image {
                let textView = newTextView(with: "")
                contentStackView.addArrangedSubview(textView)
            }
        }
    }
    
    func selectPhotoButton() {
        print("selectPhotoButton")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Rite", message: "Select a photo", preferredStyle: .actionSheet)
        
        /*if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated:  true, completion: nil)
            }))
        }*/
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true , completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func newTextView(with string: String) -> UITextView {
        let textView: UITextView = UITextView()
        textView.text = string
        textView.textAlignment = NSTextAlignment.left
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.font = UIFont (name: "Baskerville", size: 17)
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.tag = count
        textView.setContentHuggingPriority(UILayoutPriority(rawValue: 240), for: .vertical)
        count += 1
        
        contentStackView.addArrangedSubview(textView)
        return textView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let image = UIImageView(image: photo)
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.0/2.0).isActive = true
            image.contentMode = UIView.ContentMode.scaleAspectFit
            image.clipsToBounds = true
            image.tag = count
            count += 1
            
            contentStackView!.addArrangedSubview(image)
            
            let textView = newTextView(with: "")
            contentStackView.addArrangedSubview(textView)
            scrollToEnd(bottomScrollView)
        }
    }
    
    func scrollToEnd(_ addedView: UIView) {
        let contentViewHeight = scrollView.contentSize.height + addedView.bounds.height + contentStackView.spacing
        let offsetY = contentViewHeight - scrollView.bounds.height
        if (offsetY > 0) {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: offsetY), animated: true)
        }
    }
    
    func saveAllContent(){
        for element in 0...count{
            if let newView = contentStackView.viewWithTag(element) as? UITextView{
                let newText = newView.text
                let newElement = Element(info: newText as Any, file: .text)
                elements.append(newElement)
            }
            if let newView = contentStackView.viewWithTag(element) as? UIImageView {
                let newImage = newView.image
                let newElement = Element(info: newImage as Any, file: .image)
                elements.append(newElement)
            }
        }
        if let entry = entry{
            guard let titleText = titleLabel.text else {return}
            FirebaseManager.shared.updateEntry(entry:entry, title:titleText, content:elements) { (success) in
                if(success){
                    print("updated on firebase")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }else {
            guard let titleText = titleLabel.text else {return}
            FirebaseManager.shared.addEntry(title:titleText, content:elements) { (success) in
                if(success){
                    print("created on firebase")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
    }
    
    @IBAction func newTextButtonPressed(_ sender: UIBarButtonItem) {
        newTextView(with: "")
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        selectPhotoButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        saveAllContent()
    }
    
}

