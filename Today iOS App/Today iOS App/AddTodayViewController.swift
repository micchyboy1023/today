//
//  AddTodayViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/28.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit

final class AddTodayViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scoreCircleView: ScoreCircleView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var moc: NSManagedObjectContext!
    
    var score: Int =  Today.maxMasterScore {
        didSet {
            scoreCircleView.score = score
            let animation = CATransition()
            animation.type = kCATransitionFade
            animation.duration = scoreCircleView.animationDuration
            UIView.transition(with: iconImageView,
                duration: scoreCircleView.animationDuration,
                options: UIViewAnimationOptions.transitionCrossDissolve,
                animations: { [unowned self] in
                    self.iconImageView.image = Today.type(self.score).icon(.hundred)
                    self.view.layoutIfNeeded()
                },
                completion: { finished in
                    
            })
        }
    }
    
    fileprivate let thinProgressBorderGroup: [Device] = [.iPhone4, .iPhone4s, .simulator(.iPhone4), .simulator(.iPhone4s)]
    fileprivate let device = Device()
    fileprivate let thinProgressBorderWidth: CGFloat = 5.0
    fileprivate let defaultProgressBorderWidth: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moc = CoreDataManager.shared.persistentContainer.viewContext
        setupProgressBorderWidth()
        iconImageView.image = Today.type(score).icon(.hundred)
        iconImageView.tintColor = scoreCircleView.progressCircleColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTintColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let compactHeightCollection = UITraitCollection(verticalSizeClass: .compact)
        
        if traitCollection.containsTraits(in: compactHeightCollection) || device.isOneOf(thinProgressBorderGroup) {
            scoreCircleView.progressBorderWidth = thinProgressBorderWidth
        } else {
            scoreCircleView.progressBorderWidth = defaultProgressBorderWidth
        }
    }
    
    func updateTintColor() {
        let color = Today.lastColor(moc)
        self.tabBarController?.tabBar.tintColor = color
        self.navigationController?.navigationBar.tintColor = color
    }
    
    fileprivate func setupProgressBorderWidth() {
        let compactHeightCollection = UITraitCollection(verticalSizeClass: .compact)
        if traitCollection.containsTraits(in: compactHeightCollection) || device.isOneOf(thinProgressBorderGroup) {
            scoreCircleView.progressBorderWidth = thinProgressBorderWidth
        }
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension AddTodayViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Today.masterScores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        score = Today.masterScores[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "\(Today.masterScores[row])", attributes: [NSForegroundColorAttributeName: UIColor.white])
        return attributedString
    }
}
