//
//  SubscriptionPromotionActionTableViewCell.swift
//  House
//
//  Created by Ghullam  Abbas on 05/10/2023.
//  Copyright © 2023 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesBanners
import LottieAnimationManager
import SmilesSharedServices

class SubscriptionPromotionActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lottieAnimationView: UIView!
    
    @IBOutlet weak var mediaView: UIImageView!
    public var sliderTimeInterval: Double?
    public var collectionsData: [Any]? {
        didSet {
            
            if let data = collectionsData?.first as? GetTopOffersResponseModel.TopOfferAdsDO {
                self.configureCell(with: data.adImageUrl ?? "", animationURL: data.adsJsonAnimationUrl)
            } else if let data = collectionsData?.first as? GetTopAdsResponseModel.TopAdsDto.TopAd {
                self.configureCell(with: data.adImageUrl ?? "", animationURL: data.adsJsonAnimationUrl)
            }
//            collectionView?.reloadData()
//            autoScroller.resetAutoScroller()
//            pageController.currentIndex = 0
//            autoScroller.itemsCount = collectionsData?.count ?? 0
//            autoScroller.startTimer(interval: getTimeInterval())
        }
    }
   // public static let module = Bundle.module
    public var callBack: ((GetTopOffersResponseModel.TopOfferAdsDO) -> ())?
    public var topAdsCallBack: ((GetTopAdsResponseModel.TopAdsDto.TopAd) -> ())?
    weak var timer: Timer?
    public static let module = Bundle.module
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lottieAnimationView.layer.cornerRadius = 16.0
        self.lottieAnimationView.clipsToBounds = true
        self.mediaView.layer.cornerRadius = 16.0
        self.mediaView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 16.0
        self.contentView.clipsToBounds = true
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func setupUI() {
        lottieAnimationView.isHidden = true
    }
    
    func configureCell(with bannerImage: String, animationURL: String?) {
        lottieAnimationView.subviews.forEach({ $0.removeFromSuperview() })

        if let animationJsonURL = animationURL, !animationJsonURL.isEmpty {
            lottieAnimationView.isHidden = false
            mediaView.isHidden = true
            if let url = URL(string: animationJsonURL) {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: self.lottieAnimationView, removeFromSuper: false, loopMode: .loop,contentMode: .scaleAspectFill) { (bool) in
                    
                }
            }
        } else {
            mediaView.isHidden = false
            lottieAnimationView.isHidden = true
            if !bannerImage.isEmpty {
                self.mediaView.setImageWithUrlString(bannerImage) { [weak self] image in
                    if let image = image {
                        self?.mediaView.image = image
                    }
                }
            }
        }
        
        
        self.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 16.0)
    }
    @IBAction func didSelectCell(sender: UIButton) {
        if let data = collectionsData?.first as? GetTopOffersResponseModel.TopOfferAdsDO {
            (self.callBack?(data))
        }
    }
}
