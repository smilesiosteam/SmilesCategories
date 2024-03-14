//
//  FoodHeaderNib.swift
//  House
//
//  Created by Shahroze Zaheer on 11/1/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

class FoodHeaderNib: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewAllView: UIView!
    @IBOutlet weak var viewAllTitleLabel: UILabel!
    @IBOutlet weak var viewAllArrowImageView: UIImageView!
    @IBOutlet weak var viewAllButton: UIButton!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!

    var callBack: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupUI()
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        title.fontTextStyle = .smilesHeadline2
        title.textColor = .black
        
        if AppCommonMethods.languageIsArabic() {
            title.semanticContentAttribute = .forceRightToLeft
        }
        
        subTitle.fontTextStyle = .smilesBody3
        subTitle.textColor = .black.withAlphaComponent(0.8)
        
        viewAllTitleLabel.font = .circularXXTTMediumFont(size: 12)
        viewAllTitleLabel.textColor = .appRevampLocationTextColor
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FoodHeaderNib", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = bounds
        
        mainView.bindFrameToSuperviewBounds()
        //CommonMethods.applyLocalizedStrings(self)
        
        viewAllTitleLabel.text = "ViewAllText".localizedString
        if AppCommonMethods.languageIsArabic() {
            viewAllArrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    func setBackgroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }

    @IBAction func viewAllButtonTapped(_ sender: Any) {
        callBack?()
    }
}
