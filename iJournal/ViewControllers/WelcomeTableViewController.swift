//
//  WelcomeTableViewController.swift
//  JustLayout
//
//  Created by Colin Smith on 4/28/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class WelcomeTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var promptCTALabel: UIButton!
    @IBOutlet weak var archiveView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.archiveView.dataSource = self
        self.archiveView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
    }
    
    //MARK: - Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "archiveCell", for: indexPath) as! ArchiveCollectionViewCell
        let each = EntryController.shared.entries[indexPath.item]
        cell.dateLabel.text = each.date
        cell.descriptionLabel.text = each.title
        return cell
    }
    
    
    // MARK: - Table view data source
    
    @IBAction func newEntryPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func searchIconPressed(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "passDetail"{
            let destinationVC = segue.destination as? EditEntryViewController
            guard let cellChoice = archiveView.indexPathsForSelectedItems?.first else {return}
            let entry = EntryController.shared.entries[cellChoice.item]
            destinationVC?.entry = entry
        }
    }
}
