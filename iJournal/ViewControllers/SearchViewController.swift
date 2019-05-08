//
//  SearchViewController.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/4/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchTag:String = ""
   
    
    var searchActive : Bool = false
    var entry:[Entry] = []
    var filteredEntries:[Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        searchBar.delegate = self
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        FirebaseManager.shared.getUserEntries { (success) in
            if(success)
            {
                DispatchQueue.main.async {
                    self.entry = FirebaseManager.shared.userEntries
                    self.tableView.reloadData()
                    
                    let searchTag = UserDefaults.standard.string(forKey: "tagSelected") ?? ""
                    if(searchTag != ""){
                        self.searchBar.text = searchTag
                        self.searchBar(self.searchBar, textDidChange: searchTag)
                        UserDefaults.standard.set("", forKey: "tagSelected")
                    }
                }
            }
        }

        /*searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Entries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self*/
        
        /*let stringOne = "Swift 3 has come has co has has has Swift 3"
        let stringTwo = "Swift 3"
        
        let range = (stringOne as NSString).range((of: stringTwo,)
        
        dump(range)
        
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue ,range:range)
        labelSearc.attributedText = attributedText*/
        
        
        
        /*let attributedString = NSMutableAttributedString(string: "Hello, [swift].[playground]")
        let textInArray = ["swift", "playground", "others"]
        
        for text in textInArray {
            attributedString.highlightTarget(target: text, color: UIColor.blue)
        }
        
        labelSearc.attributedText = attributedString*/

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive)
        {
            return filteredEntries.count
        }
        else{
            return entry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell
            else {
                return UITableViewCell()
        }
    
        var entry : Entry
        if(searchActive)
        {
            entry  = filteredEntries[indexPath.row]
        }
        else{
            entry = self.entry[indexPath.row]
        }
        
        cell.entry = entry
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let detailVC = segue.destination as? EditEntryViewController else { return }
            
            var entry:Entry
            if(searchActive)
            {
                entry = filteredEntries[indexPath.row]
            }
            else{
                entry = self.entry[indexPath.row]
            }
            detailVC.entry = entry
        }
    }

    // MARK: - Private instance methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredEntries = entry.filter({ (entry) -> Bool in
            return entry.title.lowercased().contains(searchText.lowercased()) ||  entry.tags!.contains(searchText.lowercased())
        })
        
        if(filteredEntries.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    /*private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        guard let firstSubview = searchBar.subviews.first else { return }
        
        firstSubview.subviews.forEach {
            ($0 as? UITextField)?.clearButtonMode = .never
        }
    }*/
}

