//
//  SearchViewController.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/30/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, YearDelgate, MonthDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var yearCollectionView: UICollectionView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var yearPicker: YearPicker?
    var monthPicker: MonthPicker?
    var cellIdentifier = "YearViewCell"
    var cellMonthIdentifier = "MonthViewCell"
    var yearArray     : NSArray?
    var monthArray    : NSArray?
    var selectedYear  : Int = 0
    var selectedMonth : Int = 0
    var year:String   = ""
    var month:String  = ""
    var entry:[Entry] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.yearArray = getYear().arrayOfYears()
        self.monthArray = getMonth().arrayOfMonths()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showArchiveMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearCollectionView.delegate = self
        yearCollectionView.dataSource = self
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
    
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
        FirebaseManager.shared.getUserEntries { (success) in
            if(success)
            {
                DispatchQueue.main.async {
                    self.entry = FirebaseManager.shared.userEntries
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /*if yearCollectionView == scrollView {
            setSelectedItemFromScrollView(scrollView)
        }*/
    }
    
    func searchUserEntries(){
        print("searchUserEntries")
        print(year)
        print(month)
        print("searchUserEntries")
        /*let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        print(start)
        print(end)*/
        
        //dump(FirebaseManager.shared.userEntries)
        var search = ""
        
        if(year != ""){
            search = year
        }
        if(month != ""){
            if (month == "January"){
                search = "\(search)-01"
            }
            if (month == "February"){
                search = "\(search)-02"
            }
            if (month == "March"){
                search = "\(search)-03"
            }
            if (month == "April"){
                search = "\(search)-04"
            }
            if (month == "May"){
                search = "\(search)-05"
            }
            if (month == "June"){
                search = "\(search)-06"
            }
            if (month == "July"){
                search = "\(search)-07"
            }
            if (month == "August"){
                search = "\(search)-08"
            }
            if (month == "September"){
                search = "\(search)-09"
            }
            if (month == "October"){
                search = "\(search)-10"
            }
            if (month == "November"){
                search = "\(search)-11"
            }
            if (month == "December"){
                search = "\(search)-12"
            }
        }
        print(search)
        self.entry = FirebaseManager.shared.userEntries.filter {
            //$0.date! > start //&&  $0.date! < end
            if let date = $0.date{
                if date.string(with: "yyyy-MM-dd").contains(search) {
                    return true
                }
            }
            return false
        }
        
        self.tableView.reloadData()
        
        /*FirebaseManager.shared.updateUserEntries(year: self.year, month: self.month) { (success) in
            if(success){
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }*/
    }
    
    func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
        if yearCollectionView == scrollView {
            let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: scrollView.center.y + scrollView.contentOffset.y)
            let index = yearCollectionView.indexPathForItem(at: center)
            if index != nil {
                yearCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                self.yearCollectionView.selectItem(at: index, animated: false, scrollPosition: [])
                self.collectionView(self.yearCollectionView, didSelectItemAt: index!)
                
                self.selectedYear = (index?.row)!
                //self.year = self.yearArray?[ (index?.row)! ] as! String
                //self.searchUserEntries()
            }
        }
        
        if monthCollectionView == scrollView {
            let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: scrollView.center.y + scrollView.contentOffset.y)
            let index = monthCollectionView.indexPathForItem(at: center)
            if index != nil {
                monthCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                self.monthCollectionView.selectItem(at: index, animated: false, scrollPosition: [])
                self.collectionView(self.monthCollectionView, didSelectItemAt: index!)
                
                self.selectedMonth = (index?.row)!
                //self.month = self.monthArray?[ (index?.row)! ] as! String
                //self.searchUserEntries()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if yearCollectionView == scrollView && !decelerate  {
            setSelectedItemFromScrollView(scrollView)
        }
        if monthCollectionView == scrollView && !decelerate  {
            setSelectedItemFromScrollView(scrollView)
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == yearCollectionView){
            return (yearArray?.count)!
        }
        if (collectionView == monthCollectionView){
            return (yearArray?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == yearCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! YearViewCell
            cell.dateLabel.text = self.yearArray?[indexPath.row] as? String
            return cell
        }
        if (collectionView == monthCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMonthIdentifier, for: indexPath) as! MonthViewCell
            cell.monthLabel.text = self.monthArray?[indexPath.row] as? String
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == yearCollectionView){
            self.selectedYear = indexPath.row
            self.year = self.yearArray?[ indexPath.row ] as! String
            self.searchUserEntries()
            let centeredIndexPath = IndexPath.init(item: selectedYear, section: 0)
            yearCollectionView.scrollToItem(at: centeredIndexPath, at: .centeredHorizontally, animated: true)
            if indexPath == centeredIndexPath {
                yearCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
        
        if (collectionView == monthCollectionView){
            self.selectedMonth = indexPath.row
            self.month = self.monthArray?[ indexPath.row ] as! String
            self.searchUserEntries()
            let centeredIndexPath = IndexPath.init(item: selectedMonth, section: 0)
            monthCollectionView.scrollToItem(at: centeredIndexPath, at: .centeredHorizontally, animated: true)
            if indexPath == centeredIndexPath {
                monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if (collectionView == yearCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! YearViewCell
            cell.dateLabel!.textColor = UIColor.black
        }
        if (collectionView == monthCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellMonthIdentifier, for: indexPath) as! MonthViewCell
            cell.monthLabel!.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell
            else {
                print("Unable to cast cell correctly.") ;
                return UITableViewCell()
        }
        let entryItem = entry[indexPath.row]
        cell.entry = entryItem
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "passDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let detailVC = segue.destination as? EditEntryViewController else { return }
            let business = entry[indexPath.row]
            detailVC.entry = business
        }
    }
    
    func getYear() -> YearPicker {
        
        if yearPicker == nil {
            yearPicker = YearPicker()
            yearPicker?.delegate = self
        }
        return yearPicker!
    }
    
    func getMonth() -> MonthPicker {
        
        if monthPicker == nil {
            monthPicker = MonthPicker()
            monthPicker?.delegate = self
        }
        return monthPicker!
    }
}
