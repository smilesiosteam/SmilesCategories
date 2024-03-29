//
//  SubscriptionTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/7/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

public class SubscriptionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subscriptionImage: UIImageView!
    
    @IBOutlet weak var subscriptionView: UIView! {
        didSet {
            subscriptionView.RoundedViewConrner(cornerRadius: 12)
        }
    }
    public static let module = Bundle.module
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: SubscriptionsBanner) {
        subscriptionImage.setImageWithUrlString(data.subscriptionImage ?? "")
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
}
