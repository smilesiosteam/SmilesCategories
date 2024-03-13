//
//  ItemCategoriesTableViewCell.swift
//  House
//
//  Created by Shmeel Ahmad on 28/12/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

struct ActionNeededData {
    var iconURL: String?
    var content: String?
    var primaryActionTitle: String?
    var borderColor: UIColor?
    var iconName: String?
}

class ActionNeededTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var primaryActionBtn: UIButton!
    @IBOutlet weak var mainView: UIView!

    var primaryActionCallback: ((ActionNeededData) -> ())?
    var dismissCallback: (() -> ())?
    var data: ActionNeededData! {
        didSet {
            self.contentLabel.text = data.content
            if let urlStr = data.iconURL, let url = URL(string: urlStr) {
                self.icon.setImageWith(url)
            } else if let iconName = data.iconName {
                self.icon.image = UIImage(named: iconName)
                self.mainView.layer.borderWidth = 1
                self.mainView.layer.borderColor = data.borderColor?.cgColor ?? UIColor.gray.cgColor
            }
            self.primaryActionBtn.setTitle(data.primaryActionTitle, for: .normal)
            self.setupViewUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.cornerRadius = 12
        selectionStyle = .none
    }
    
    private func setupViewUI() {
        self.contentLabel.font = SmilesFonts.circular.getFont(style: .regular, size: 14)
        self.contentLabel.textColor = .appRevampFilterTextColor
        
        self.primaryActionBtn.titleLabel?.font = SmilesFonts.circular.getFont(style: .medium, size: 14)
        self.primaryActionBtn.setTitleColor(.appRevampFilterTextColor, for: .normal)
        self.primaryActionBtn.titleLabel?.underline(color: .appRevampFilterTextColor)
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
    
    @IBAction func primaryAction(_ sender: Any) {
        primaryActionCallback?(data)
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismissCallback?()
    }
    
}
