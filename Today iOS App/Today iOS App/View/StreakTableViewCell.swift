//
//  StreakTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/31.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class StreakTableViewCell: UITableViewCell {
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var longestStreakDateLabel: UILabel!
    
    @IBOutlet weak var currentStreakLabel: UILabel!
    @IBOutlet weak var currentStreakDateLabel: UILabel!
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: - ConfigurableCell 
extension StreakTableViewCell: ConfigurableCell {
    func configureForObject(longestAndCurrentStreaks: (Streak?, Streak?)) {
        let (longestStreak, currentStreak) = longestAndCurrentStreaks
        
        if let longestStreak = longestStreak {
            longestStreakLabel.text = "\(Int(longestStreak.streakNumber))"
            longestStreakDateLabel.text = "\(dateFormatter.stringFromDate(longestStreak.from)) - \(dateFormatter.stringFromDate(longestStreak.to))"
        } else {
            longestStreakLabel.text = "0"
            longestStreakDateLabel.text = ""
        }
        
        if let currentStreak = currentStreak {
            currentStreakLabel.text = "\(Int(currentStreak.streakNumber))"
            currentStreakDateLabel.text = "\(dateFormatter.stringFromDate(currentStreak.from)) - \(dateFormatter.stringFromDate(currentStreak.to))"
        } else {
            currentStreakLabel.text = "0"
            currentStreakDateLabel.text = ""
        }
    }
}
