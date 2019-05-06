//
//  WelcomeTableViewController.swift
//  JustLayout
//
//  Created by Colin Smith on 4/28/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var promptCTALabel: UIButton!
    
    @IBOutlet weak var dateCenterLabel: UILabel!
    @IBOutlet weak var titleCenterLabel: UILabel!
    @IBOutlet weak var otherCenterLabel: UILabel!
    @IBOutlet weak var archiveView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func showMenuButtonTapped(_ sender: Any) {}
    
    override func viewWillAppear(_ animated: Bool) {
        archiveView.reloadData()
        guard let username = FirebaseManager.shared.loggedInUserProfile?.username else { return }
        greetingLabel.text = "Good morning,\n\(username)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showHomeMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        
        /*searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Entries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self*/
        
        super.viewDidLoad()
        self.archiveView.dataSource = self
        self.archiveView.delegate = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        FirebaseManager.shared.getUserEntries { (success) in
            if(success)
            {
                DispatchQueue.main.async {
                    if(FirebaseManager.shared.userEntries.count > 0){
                        self.dateCenterLabel.text  = FirebaseManager.shared.userEntries[0].date?.string(with: "MM dd yyyy")
                        self.titleCenterLabel.text = "Wrote about '\(FirebaseManager.shared.userEntries[0].title)'"
                        if let tags = FirebaseManager.shared.userEntries[0].tags{
                            self.otherCenterLabel.text  = "Other tags '\( tags.joined(separator:",") )"
                        }
                        else{
                            self.otherCenterLabel.text = ""
                        }
                    }
                    self.archiveView.reloadData()
                }
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showHomeMenu"), object: nil)
    }
    
    
    
    
    //MARK: - Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseManager.shared.userEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "archiveCell", for: indexPath) as! ArchiveCollectionViewCell
        let each = FirebaseManager.shared.userEntries[indexPath.item]
        cell.dateLabel.text = each.date?.string(with: "yyyy-MM-dd")
        cell.descriptionLabel.text = each.title
        return cell
    }
    
    
    // MARK: - Table view data source
    @IBAction func newEntryPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func searchIconPressed(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passDetail"{
            let destinationVC = segue.destination as? EditEntryViewController
            guard let cellChoice = archiveView.indexPathsForSelectedItems?.first else {return}
            let entry = FirebaseManager.shared.userEntries[cellChoice.item]
            destinationVC?.entry = entry
        }
    }
    
}



extension HomeTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterContentForSearchText(searchBar.text!)
    }
}

extension HomeTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
