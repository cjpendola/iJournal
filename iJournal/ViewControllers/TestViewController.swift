//
//  TestViewController.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/26/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class TestViewController: UIViewController{
    
    weak var collectionView: UICollectionView!
    var data: [String] = Array(arrayLiteral: "Ham al lamma Bing Bong","Ham al lamma Bing Bong","Ham al lamma Bing Bong")
    var keyboardHeight:CGFloat?

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil )
        //createScrollView()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            print(self.keyboardHeight)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let lastTextField = textField.text!.last!
        print(lastTextField)
        
        
        
        if(lastTextField == "#"){
            createScrollView()
        }else{
            dismissScrollView()
        }
    }
    
    func createScrollView(){
        
    /*}
    
    override func loadView() {
        super.loadView()*/
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        viewLayout.estimatedItemSize = CGSize(width: 50, height: 50)
        
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        self.view.addSubview(collectionView)
        
        
        //let intheight =  Int64( self.keyboardHeight! )
        collectionView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 40))
        
        
        
        self.collectionView = collectionView
        self.collectionView.tag = 1
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.backgroundColor = .white
        
    }
    
    
    func dismissScrollView(){
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
}

extension TestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        let data = self.data[indexPath.item]
        cell.textLabel.text = String(data)
        return cell
    }
}

extension TestViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension TestViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return UICollection
//    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth)
    }*/
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        //return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
          return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
