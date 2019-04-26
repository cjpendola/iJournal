//
//  ScrollingStackViewController.swift
//  Stacks
//
//  Created by Keith Harrison http://useyourloaf.com
//  Copyright (c) 2016 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

import UIKit
import AVFoundation

class ScrollingStackViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioRecorderDelegate, UITextViewDelegate {
    
    var stackView : UIStackView?
    var audioFilename:URL?
    
    
    /*Audio**/
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
     /*Audio**/
    
    @IBAction func addImage(_ sender: Any) {
        selectPhotoButton()
    }
    
    func newTextView(){
        let textView: UITextView = UITextView()
        textView.text = "This is testing text"
        textView.textAlignment = NSTextAlignment.left
        textView.textColor = UIColor.darkGray
        textView.backgroundColor = .white
//        textView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textView.isScrollEnabled = false
        stackView?.addArrangedSubview(textView)
    }
    
    func setAudio(){
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            print("failed to record! ")
        }
    }
    
    func loadRecordingUI() {
        /*recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(recordButton)*/
        
        startRecording()
        let timer2 = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            print("Timer fired!")
            self.finishRecording(success: true)
        }
    }
    
    
    func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            guard let audioFilename = audioFilename else { return }
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            //recordButton.setTitle("Tap to Re-record", for: .normal)
            if let audioFilename = audioFilename{
                FirebaseManager.shared.uploadAudioToFirebase(fileUrl: audioFilename) { (success) in
                    if(success){
                        print("go check firebase men")
                    }
                }
            }
            
        } else {
            //recordButton.setTitle("Tap to Record", for: .normal)
        }
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    override func viewDidLoad() {
        
        //setAudio()
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        print(self.view.topAnchor)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 50),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        stackView = UIStackView()
        stackView!.axis = .vertical
        stackView!.alignment = .fill
        stackView!.spacing = 0
        stackView!.distribution = .fill
        scrollView.addSubview(stackView!)
        
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView!.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView!.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView!.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView!.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView!.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        newTextView()
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let image = UIImageView(image: photo)
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.0/2.0).isActive = true
            image.contentMode = UIView.ContentMode.scaleAspectFit
           
            image.clipsToBounds = true
            stackView!.addArrangedSubview(image)
            
            //image.anchor(top: view.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil, padding: .init(top: 32, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 72))
            
            
            
            //stackView.addArrangedSubview(image)
            //scrollToEnd(image)
            newTextView()
        }
    }

    
    
    
}

