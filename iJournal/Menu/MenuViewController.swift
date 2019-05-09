//
//  MenuViewController.swift
//  MenuLateral_Final
//
//  Created by Luis Rollon Gordo on 6/10/16.
//  Copyright © 2016 EfectoApple. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController,ExpandableHeaderViewDelegate {
    
    /*@IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var exportLabel: UILabel!
    @IBOutlet weak var archiveLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!*/
    
    var sections = [
        Section(name: "Home", tags: [], expanded: false),
        Section(name: "Archives", tags: [], expanded: false),
        Section(name: "Tags", tags: [], expanded: false),
        //Section(name: "Export", tags: [], expanded: false),
        Section(name: "Reminders", tags: [], expanded: false),
        Section(name: "Log Out", tags: [], expanded: false) 
    ]
    
    var tags : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        
        FirebaseManager.shared.getUserEntries { (success) in
            if(success){
                for users in FirebaseManager.shared.userEntries{
                    if let tags = users.tags{
                        self.tags = self.tags + tags
                    }
                }
                self.sections[2].tags = self.tags
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
        //homeLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(self.showHomeMenu), name: Notification.Name("showHomeMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showArchiveMenu), name: Notification.Name("showArchiveMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSettingsMenu), name: Notification.Name("showSettingsMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showExportMenu), name: Notification.Name("showExportMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showTagsMenu), name: Notification.Name("showTagsMenu"), object: nil)*/
    }
    
    /*@objc func showHomeMenu(){
        returnLabelsColor()
        homeLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showArchiveMenu(){
        returnLabelsColor()
        archiveLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showSettingsMenu(){
        returnLabelsColor()
        settingsLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showExportMenu(){
        returnLabelsColor()
        exportLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showTagsMenu(){
        returnLabelsColor()
        tagsLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    func returnLabelsColor(){
        homeLabel.textColor     = UIColor.white
        tagsLabel.textColor     = UIColor.white
        exportLabel.textColor   = UIColor.white
        archiveLabel.textColor  = UIColor.white
        settingsLabel.textColor = UIColor.white
    }*/
    
    /*@IBAction func signOutButtonTapped(_ sender: Any) {
        FirebaseManager.shared.signOut { (success) in
            if (success == nil) {
                self.performSegue(withIdentifier: "unwindToHomeWithSegue", sender: self)
            }
        }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        self.tags = []
        for users in FirebaseManager.shared.userEntries{
            if let tags = users.tags{
                self.tags = self.tags + tags
            }
        }
        self.sections[2].tags = self.tags
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tags.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 40
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].name, section: section, delegate: self)
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = "     #\(sections[indexPath.section].tags[indexPath.row])"
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
    
        if(sections[section].tags.count == 0){
            if(sections[section].name == "Home"){
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }
            if(sections[section].name == "Archives"){
                self.performSegue(withIdentifier: "showArchives", sender: nil)
            }
            if(sections[section].name == "Export"){
                self.performSegue(withIdentifier: "showExport", sender: nil)
            }
            if(sections[section].name == "Reminders"){
                self.performSegue(withIdentifier: "showSettings", sender: nil)
            }
            if(sections[section].name == "Log Out"){
                FirebaseManager.shared.signOut { (success) in
                    if (success == nil) {
                        self.performSegue(withIdentifier: "unwindToHomeWithSegue", sender: self)
                    }
                }
            }
        }
        else{
            tableView.beginUpdates()
            for i in 0 ..< sections[section].tags.count {
                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            tableView.endUpdates()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passSearchDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let section = self.sections[indexPath.section]
                let searchTag = section.tags[indexPath.row]
                UserDefaults.standard.set(searchTag, forKey: "tagSelected")
            }
        }
    }
}
