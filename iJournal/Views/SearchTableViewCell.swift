//
//  SearchTableViewCell.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/1/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var entry:Entry?{
        didSet{
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateViews(){
        guard let entry = entry else {return}
        dateLabel.text  = entry.date?.string(with: "MM dd yyyy")
        titleLabel.text = "Wrote about '\(entry.title)'"
        if let tags = entry.tags{
            tagsLabel.text  = "Other tags ' \( tags.joined(separator:",") ) '"
        }
        else{
            tagsLabel.text = ""
        }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }

}
