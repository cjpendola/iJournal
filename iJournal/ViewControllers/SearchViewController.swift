//
//  SearchViewController.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/30/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CalendarDelgate {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    var calendarPicker: CalendarPicker?
    var cellIdentifier = "CalendarViewCell"
    var currentDate = Date()
    var calendarArray: NSArray?
    var selectedDate: Int = 0
    
    func getCalendar() -> CalendarPicker {
        
        if calendarPicker == nil {
            calendarPicker = CalendarPicker()
            calendarPicker?.delegate = self
        }
        return calendarPicker!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.calendarArray = getCalendar().arrayOfDates()
        
        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        self.calendarCollectionView.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: [])
        self.collectionView(self.calendarCollectionView, didSelectItemAt: indexPathForFirstRow)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if calendarCollectionView == scrollView {
            setSelectedItemFromScrollView(scrollView)
        }
    }
    
    func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
        if calendarCollectionView == scrollView {
            let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x, y: scrollView.center.y + scrollView.contentOffset.y)
            let index = calendarCollectionView.indexPathForItem(at: center)
            if index != nil {
                calendarCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: true)
                self.calendarCollectionView.selectItem(at: index, animated: false, scrollPosition: [])
                self.collectionView(self.calendarCollectionView, didSelectItemAt: index!)
                
                self.selectedDate = (index?.row)!
                self.selectedDateLabel.text = self.calendarArray?[(index?.row)!] as? String
            }
            else {
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if calendarCollectionView == scrollView && !decelerate  {
            setSelectedItemFromScrollView(scrollView)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (calendarArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CalendarViewCell
        
        cell.dateLabel.text = self.calendarArray?[indexPath.row] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDate = indexPath.row
        let centeredIndexPath = IndexPath.init(item: selectedDate, section: 0)
        collectionView.scrollToItem(at: centeredIndexPath, at: .centeredHorizontally, animated: true)
        if indexPath == centeredIndexPath {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        self.selectedDateLabel.text = self.calendarArray?[indexPath.row] as! String?
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CalendarViewCell
        cell.dateLabel!.textColor = UIColor.black
    }
    
}
