//
//  ItemCategoriesCollectionViewCell.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import LottieAnimationManager
import SmilesUtilities

class ItemCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageViewContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemCategoryName: UILabel!
    @IBOutlet weak var lotieAnimationView: UIView!
    @IBOutlet weak var newRibbonImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        lotieAnimationView.isHidden = true
        
        imageViewContainerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 12.0)
        itemCategoryName.font = .circularXXTTRegularFont(size: 12.0)
        itemCategoryName.textColor = .appRevampItemTitleColor
    }
    
    func configureCellWithData(category : HomeItemCategoryDetails?) {
        if category?.categoryId == 27{
            imageView.image = UIImage(named:AppCommonMethods.languageIsArabic() ? "logo-smiles-market-ar" : "logo-smiles-market-en")
        }else{
            imageView.setImageWithUrlString(category?.categoryIconUrl ?? "")
        }
        itemCategoryName.text = category?.categoryName.asStringOrEmpty()
        itemCategoryName.setTextSpacingBy(value: -0.1)
        imageViewContainerView.backgroundColor = UIColor(hexString: category?.backgroundColor ?? "")
        
        if let ribbonUrl = category?.ribbonIconUrl, !ribbonUrl.isEmpty {
            newRibbonImageView.isHidden = false
            newRibbonImageView.setImageWithUrlString(ribbonUrl)
        } else {
            newRibbonImageView.isHidden = true
        }
        
        if let categoryJsonAnimationUrl = category?.animationUrl, !categoryJsonAnimationUrl.isEmpty {
            lotieAnimationView.isHidden = false
            imageView.isHidden = true
            lotieAnimationView.subviews.forEach({ $0.removeFromSuperview() })
            if let url = URL(string: categoryJsonAnimationUrl) {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: self.lotieAnimationView, removeFromSuper: false, loopMode: .loop) { (bool) in
                    
                }
            }
        } else {
            imageView.isHidden = false
            lotieAnimationView.isHidden = true
        }
    }
}
