//
//  OcassionThemeCell.swift
//  House
//
//  Created by Asad Ullah on 10/01/2024.
//  Copyright © 2024 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesSharedServices

class OcassionThemeCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(section: SectionDetailDO) {
        backgroundImageView.setImageWithUrlString(section.backgroundImage ?? "")
    }
    
}
