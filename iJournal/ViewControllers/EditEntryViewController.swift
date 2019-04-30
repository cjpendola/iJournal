//
//  EditEntryViewController.swift
//  JustLayout
//
//  Created by Colin Smith on 4/28/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var entry: Entry?
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let entry = entry else {return}
        loadElements(entry: entry)
        
    }
    let endScrollFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    lazy var bottomScrollView = UIView(frame: endScrollFrame)
    
    func loadElements(entry: Entry){
        titleLabel.text = entry.title
        guard entry.content.count > 0 else { return }
        
        for element in entry.content {
            switch element.file {
            case .text:
                guard let text = element.info as? String else { continue }
                let textView = newTextView(with: text)
                contentStackView.addArrangedSubview(textView)
            case .image:
                guard let photo = element.info as? UIImage else { continue }
                let photoImageView = UIImageView(image: photo)
                photoImageView.contentMode = .scaleAspectFit
                contentStackView.addArrangedSubview(photoImageView)
            default:
                print("add audio later")
            }
            
            // FIXME: - edit to cover audio as well
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
        
        let actionSheet = UIAlertController(title: "Tiki", message: "Select a photo", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated:  true, completion: nil)
            }))
        }
        
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
        textView.setContentHuggingPriority(UILayoutPriority(rawValue: 240), for: .vertical)
        return textView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let image = UIImageView(image: photo)
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.0/2.0).isActive = true
            image.contentMode = UIView.ContentMode.scaleAspectFit
            
            image.clipsToBounds = true
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
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        selectPhotoButton()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
