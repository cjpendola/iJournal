//
//  EditEntryViewController.swift
//  JustLayout
//
//  Created by Colin Smith on 4/28/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pdfOutlet: UIBarButtonItem!
    
    
    var indexOfSelectedTextView: Int?
    var fromExistingFile: Bool = true
    var entry: Entry?
    var textChanged: ((String) -> Void)?
    var count = 1
    var elements:[Element] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        guard let entry = entry else {
            pdfOutlet.isHidden = true
            return
        }
        self.entry = entry
        self.elements = entry.content
        titleLabel.text = entry.title
        pdfOutlet.isHidden = true
    }
    
    
    //MARK: - New Content
    func newTextCell(){
        let newElement = Element(info: " ", file: .text)
        elements.append(newElement)
        tableView.reloadData()
    }
    
    func selectPhotoButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Upload Image", message: "Select a photo", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true , completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let newElement = Element(info: photo, file: .image)
            elements.append(newElement)
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if elements[indexPath.row].file == .image {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //guard let content = elements[indexPath.row] else {  return UITableViewCell()    }
        
        let content = elements[indexPath.row]
        
        if content.file == .text {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? TextTableViewCell else {return UITableViewCell()}
            cell.content = content
            
            cell.textChanged {[weak tableView] (_) in
                UIView.performWithoutAnimation(){
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
            }
            return cell
            
        }else if content.file == .image {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageTableViewCell else {return UITableViewCell()}
            
            if let info = content.info as? String{
                EntryController.shared.fetchImage(url: info, count:0 ) { (image, number) in
                    if (image != nil){
                        DispatchQueue.main.async {
                            cell.batman.image = image
                        }
                    }
                }
            }else{
                cell.content = content
            }
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        selectPhotoButton()
    }
    
    //MARK: - Table View Editing
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            elements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
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
    
    @IBAction func newTextFieldButtonPressed(_ sender: UIBarButtonItem) {
        newTextCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passDetailToPDF"{
            let destinationVC = segue.destination as? ExportViewController
            destinationVC?.entry = entry
        }
    }
}

