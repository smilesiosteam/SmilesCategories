//
//  SuperTableViewCell.swift
//  House
//
//  Created by ahmed samir on 9/23/19.
//  Copyright © 2019 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class SuperTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
//        CommonMethods.applyLocalizedStrings(toAllViews: self)

        // Initialization code
        setupStyles()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /* Function added for Rowmodel */
    func updateCell(rowModel: BaseRowModel) {}

    /* Function added for Rowmodel */
    func setupStyles() {}
}
