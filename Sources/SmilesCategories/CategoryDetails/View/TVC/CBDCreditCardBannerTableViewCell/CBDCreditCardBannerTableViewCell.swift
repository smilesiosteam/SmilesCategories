//
//  CBDCreditCardBannerTableViewCell.swift
//  House
//
//  Created by Ahmed samir ali on 8/19/19.
//  Copyright © 2019 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

@objc class CBDCreditCardBannerTableViewCell: SuperTableViewCell {
    
    @IBOutlet weak var img_icon: UIImageView!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_subtitle: UILabel!
    
    @IBOutlet weak var lbl_knowMore: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_knowMore.text = LanguageManager.sharedInstance()?.getLocalizedString(forKey: "KnowMore")
        lbl_knowMore.textColor = UIColor.appRedColor
        CommonMethods.applyLocalizedStrings(toAllViews: self)
    }
    
    func configure(details:CBDDetailsResponseModel){
        self.lbl_title.text = details.cbdCard?.promotionalTitle.asStringOrEmpty()
        self.lbl_subtitle.text = details.cbdCard?.promotionalDesc.asStringOrEmpty()
        self.img_icon.setImageWithUrlString(details.cbdCard?.promotionalIcon.asStringOrEmpty() ?? "", defaultImage: "")
    }
    
    @objc func setUpCell(data : CBDDetailsResponse){
        
        if let cbdCard = data.cbdCard{
            self.lbl_title.text = cbdCard.promotionalTitle.asStringOrEmpty()
            self.lbl_subtitle.text = cbdCard.promotionalDesc.asStringOrEmpty()
            self.img_icon.setImageWithUrlString(cbdCard.promotionalIcon.asStringOrEmpty(), defaultImage: "")
        }
    }
    
    func layoutSubview() {
        super.layoutSubviews()
        
        layoutIfNeeded()
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        super.updateCell(rowModel: rowModel)
        //populate Cell here...
        if let data = rowModel.rowValue as? CBDDetailsResponse {
            self.lbl_title.text = data.cbdCard.promotionalTitle.asStringOrEmpty()
            self.lbl_subtitle.text = data.cbdCard.promotionalDesc.asStringOrEmpty()
            self.img_icon.setImageWithUrlString(data.cbdCard.promotionalIcon.asStringOrEmpty(), defaultImage: "")
        }
    }
    
    class func rowModel(model:CBDDetailsResponse) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "CBDCreditCardBannerTableViewCell"
        rowModel.rowHeight = 175.0
        rowModel.rowValue = model
        return rowModel
    }
    
    
    
}
