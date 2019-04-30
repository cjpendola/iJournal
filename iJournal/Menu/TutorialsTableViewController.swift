//
//  TutorialsTableViewController.swift
//  MenuLateral_Final
//
//  Created by Luis Rollon Gordo on 6/10/16.
//  Copyright © 2016 EfectoApple. All rights reserved.
//

import UIKit

class TutorialsTableViewController: UITableViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TutorialsTableViewCell
        
        // Configure the cell...
        if indexPath.row == 0 {
            cell.postImageView.image = UIImage(named: "post1")
            cell.postTitleLabel.text = "Como convertirte en Desarrollador iOS"
            cell.authorLabel.text = "Luis Rollón Gordo"
            cell.authorImageView.image = UIImage(named: "author")
            
        } else if indexPath.row == 1 {
            cell.postImageView.image = UIImage(named: "post2")
            cell.postTitleLabel.text = "Aprende a manejar Sketch"
            cell.authorLabel.text = "Luis Rollón Gordo"
            cell.authorImageView.image = UIImage(named: "author")
            
        } else {
            cell.postImageView.image = UIImage(named: "post6")
            cell.postTitleLabel.text = "Crea tu Aplicación iOS Cliente-Servidor"
            cell.authorLabel.text = "Luis Rollón Gordo"
            cell.authorImageView.image = UIImage(named: "author")
            
        }
        
        return cell
    }

}
