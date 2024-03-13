//
//  SpinWheelTurnsViewCell.swift
//  House
//
//  Created by Mutahir Pirzada on 23/09/2021.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class SpinWheelTurnsViewCellModel {
    var baseRowModels: [BaseRowModel] = []
    init(baseRowModels: [BaseRowModel]) {
        self.baseRowModels = baseRowModels
    }
}

class SpinWheelTurnsViewRevampCellModel {
    var rowValue: PlayTreasureChestResponse?
    var delegate: SpinWheelTurnsViewCellDelegate?
}

protocol SpinWheelTurnsViewCellDelegate:BaseDataSourceDelegate {
    func timerExpired()
}
class SpinWheelTurnsViewCell: SuperTableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var shadowParentView: UIView!
    @IBOutlet weak var roundCornerView: UIView!

    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var giftTitleLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftTurnsLabel: UILabel!
    @IBOutlet weak var turnsContainerView: UIView!
//    @IBOutlet weak var giftEndsInLabel: UILabel!
//    @IBOutlet weak var dealTimerLbl: CountdownLabel!
    @IBOutlet weak var turnsBgView: RoundUIView!
    @IBOutlet weak var multiGiftImageView: UIView!
    @IBOutlet weak var spinWheelCollectionView: UICollectionView!
//    @IBOutlet weak var expiryView: UIView!
    @IBOutlet weak var countDownView: UIView!
    @IBOutlet weak var hrMinSecStackView: UIStackView!
    
    // Countdown labels
    
    @IBOutlet weak var hourTensLabel: FlippingLabel!
    @IBOutlet weak var hourUnitsLabel: FlippingLabel!
    @IBOutlet weak var minuteTensLabel: FlippingLabel!
    @IBOutlet weak var minuteUnitsLabel: FlippingLabel!
    @IBOutlet weak var secondTensLabel: FlippingLabel!
    @IBOutlet weak var secondUnitsLabel: FlippingLabel!
    
    @IBOutlet weak var secondUnitUpperGradientView: SZGradientView!
    @IBOutlet weak var secondUnitLowerGradientView: SZGradientView!
    @IBOutlet weak var secondUnitAnchorLeft: SZGradientView!
    @IBOutlet weak var secondUnitAnchorRight: SZGradientView!
    
    @IBOutlet weak var secondTensUpperGradientView: SZGradientView!
    @IBOutlet weak var secondTensLowerGradientView: SZGradientView!
    @IBOutlet weak var secondTensAnchorLeft: SZGradientView!
    @IBOutlet weak var secondTensAnchorRight: SZGradientView!
    
    @IBOutlet weak var minuteUnitsUpperGradientView: SZGradientView!
    @IBOutlet weak var minuteUnitsLowerGradientView: SZGradientView!
    @IBOutlet weak var minuteUnitsAnchorLeft: SZGradientView!
    @IBOutlet weak var minuteUnitsAnchorRight: SZGradientView!
    
    @IBOutlet weak var minuteTensUpperGradientView: SZGradientView!
    @IBOutlet weak var minuteTensLowerGradientView: SZGradientView!
    @IBOutlet weak var minuteTensAnchorLeft: SZGradientView!
    @IBOutlet weak var minuteTensAnchorRight: SZGradientView!
    
    @IBOutlet weak var hourUnitsUpperGradientView: SZGradientView!
    @IBOutlet weak var hourUnitsLowerGradientView: SZGradientView!
    @IBOutlet weak var hourUnitsAnchorLeft: SZGradientView!
    @IBOutlet weak var hourUnitsAnchorRight: SZGradientView!
    
    @IBOutlet weak var hourTensUpperGradientView: SZGradientView!
    @IBOutlet weak var hourTensLowerGradientView: SZGradientView!
    @IBOutlet weak var hourTensAnchorLeft: SZGradientView!
    @IBOutlet weak var hourTensAnchorRight: SZGradientView!
    //CountDown View
    @IBOutlet weak var hrTensView: CountDownCardView!
    @IBOutlet weak var hrUnitView: CountDownCardView!
    @IBOutlet weak var minTensView: CountDownCardView!
    @IBOutlet weak var minUnitView: CountDownCardView!
    @IBOutlet weak var secTensView: CountDownCardView!
    @IBOutlet weak var secUnitView: CountDownCardView!
    
    @IBOutlet weak var hourTitleLabel: UILabel!
    @IBOutlet weak var minutesTitleLabel: UILabel!
    @IBOutlet weak var secondsTitleLabel: UILabel!
    
    // Sprint 101 - UC 11 - New Outlets
    @IBOutlet weak var bannerArrowRoundedView: RoundUIView!
    @IBOutlet weak var bannerArrowImageView: UIImageView!

    var startedAt: Date?
    var targetDate: Date?
    var countDownTimer: Timer!
    // MARK: - vars

    var baseDataSource: BaseCollectionViewDataSource!
    weak var imagesTimer: Timer?
    var rowIndex = 0
    var imagesArray : [BaseRowModel]?
    var delegate: SpinWheelTurnsViewCellDelegate?
    // MARK: - LifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        addShadowToSelf(offset: CGSize.zero, color: UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.5), radius: 4.0, opacity: 1)
//        shadowParentView.RoundedViewConrner(cornerRadius: 12)
        let notificationCenter = NotificationCenter.default
           notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        CommonMethods.applyLocalizedStrings(toAllViews: self)
        
        giftImageView.layer.cornerRadius = 12
        giftImageView.layer.masksToBounds = true
//        self.roundCornerView.isHidden = true MARK: Need to fix this with actual DATA
        
        hrTensView.layer.cornerRadius = 6
        hrUnitView.layer.cornerRadius = 6
        
        minTensView.layer.cornerRadius = 6
        minUnitView.layer.cornerRadius = 6
        
        secTensView.layer.cornerRadius = 6
        secUnitView.layer.cornerRadius = 6
        
        
        countDownView.semanticContentAttribute = .forceLeftToRight
        hrMinSecStackView.semanticContentAttribute = .forceLeftToRight
    }
    
    @objc func appMovedToBackground() {
        stopTimerCountdown()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    
    func setupCollectionView() {
        let flowLayout = PagingCollectionViewLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = -52
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.spinWheelCollectionView.collectionViewLayout = flowLayout
        spinWheelCollectionView.decelerationRate = .fast
        
        
        spinWheelCollectionView.register(UINib(nibName: String(describing: ImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
    }
    
    func setUpImagesDataSource(images: [BaseRowModel], dataSourceDelegate: BaseDataSourceDelegate?) {
        baseDataSource = BaseCollectionViewDataSource(dataSource: images, delegate: dataSourceDelegate)
        spinWheelCollectionView.dataSource = baseDataSource
        spinWheelCollectionView.delegate = baseDataSource
        spinWheelCollectionView.reloadData()
        
//        startTimer()
        
    }
    
    func stopTimer() {
        imagesTimer?.invalidate()
        imagesTimer = nil
    }
    
    func stopTimerCountdown() {
        self.secondUnitsLabel.stopAnimations()
        countDownTimer?.invalidate()
        countDownTimer = nil
        startedAt = nil
    }
    
    // -------------------------------------------------------------------------------
    //    Timer Controls
    // -------------------------------------------------------------------------------
    func startTimer() {
        rowIndex = 0
        imagesTimer?.invalidate()
        imagesTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] timer in
            guard let `self` = self else {
                timer.invalidate()
                return
            }
            if let imgsArr = self.imagesArray, imgsArr.count > 0 {
                if self.rowIndex == imgsArr.count {
                    self.rowIndex = 0
                }
                var sortedArray : [BaseRowModel] = []
                for i in self.rowIndex...imgsArr.count - 1 {
                    sortedArray.append(imgsArr[i])
                }
                if let remainingElements = self.imagesArray?.prefix(imgsArr.count - sortedArray.count), remainingElements.count > 0 {
                    sortedArray.append(contentsOf: remainingElements)
                }
                
                self.rowIndex += 1
                self.setUpImagesDataSource(images: sortedArray, dataSourceDelegate: self.delegate)
            } else {
                return
            }
        }
        imagesTimer?.fire()
    }
    /// Gives an Date object corresponding to the next exact second (000 ms)
    /// - Returns: a Date Object
    fileprivate func nextSecondDate() -> Date {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let currentComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
        return calendar.date(bySettingHour: currentComponents.hour!, minute: currentComponents.minute!, second: (currentComponents.second!+1) % 60, of: date)!
    }
    //MARK: - countdown timer
    func willAppear(){
        if countDownTimer != nil {
            countDownTimer.invalidate()
        }
        let fireDate = nextSecondDate()
        var fireDateTimeInterval = fireDate.timeIntervalSince1970
        fireDateTimeInterval += 0.5
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.00, target: self, selector: #selector(self.handleTimerTick), userInfo: nil, repeats: true)
        
        let loop = RunLoop.current
        loop.add(countDownTimer, forMode: .common)
    }
    
    func updateClock(animated:Bool) {
        let date = Date()
        if startedAt == nil {
            startedAt = date
        }

        guard let tDate = targetDate, tDate > date else {
            if let tDate = targetDate {
                if (countDownTimer?.isValid ?? false) && tDate <= date{
                    delegate?.timerExpired()
                }
                self.stopTimerCountdown()
                return
            }
            return
        }
        
        let remainingTime = Calendar.current.dateComponents([.hour,.minute,.second], from: date, to: tDate)
       
        var hourStr = "00"
        var minStr = "00"
        var secStr = "00"
        
        if let hour = remainingTime.hour {
            hourStr = String(format: "%02d", hour)
        }
         
        if let minute = remainingTime.minute {
            minStr = String(format: "%02d", minute)
        }
        
        if let seconds = remainingTime.second {
            secStr = String(format: "%02d", seconds)
        }
        
        self.roundCornerView.isHidden = false
        if animated {
            //HOURS
            self.layoutSubviews()
            
            hourTensLabel.updateWithText(String(hourStr.prefix(1)), view: self.hrTensView)
            hourUnitsLabel.updateWithText(String(hourStr.suffix(1)), view: self.hrUnitView)
            
            //MINUTES
            minuteTensLabel.updateWithText(String(minStr.prefix(1)), view: self.minTensView)
            minuteUnitsLabel.updateWithText(String(minStr.suffix(1)), view: self.minUnitView)
            
            //SECONDS
            secondTensLabel.updateWithText(String(secStr.prefix(1)), view: self.secTensView)
            secondUnitsLabel.updateWithText(String(secStr.suffix(1)), view: self.secUnitView)
            
        } else {
            //HOURS
            hourTensLabel.text = String(hourStr.prefix(1))
            hourUnitsLabel.text = String(hourStr.suffix(1))
            
            //MINUTES
            minuteTensLabel.text = String(minStr.prefix(1))
            minuteUnitsLabel.text = String(minStr.suffix(1))
            
            //SECONDS
            secondTensLabel.text = String(secStr.prefix(1))
            secondUnitsLabel.text = String(secStr.suffix(1))
        }
        
        
        
    }
    @objc fileprivate func handleTimerTick() {
        self.updateClock(animated: false)
    }
    
    // MARK: - UpdateCell

    override func updateCell(rowModel: BaseRowModel) {
        if let delegate = rowModel.delegate as? SpinWheelTurnsViewCellDelegate {
            self.delegate = delegate
        }
//        turnsContainerView.isHidden = true
//        self.countDownView.isHidden = true
//        self.hrMinSecStackView.isHidden = true
        
        if let model = rowModel.rowValue as? PlayTreasureChestResponse {
            guard let exp = model.bannerDetails?.expiryDate else {return}
            let expDate = CommonMethods.returnDate(from: exp, format: "yyyy-MM-dd HH:mm:ss")
            let secondsFromGMT = NSTimeZone.local.secondsFromGMT()
            targetDate = expDate?.addingTimeInterval(-TimeInterval(secondsFromGMT))
            self.secondUnitsLabel.stopAnimations()
            self.secondTensLabel.stopAnimations()
            self.minuteUnitsLabel.stopAnimations()
            self.minuteTensLabel.stopAnimations()
            self.hourTensLabel.stopAnimations()
            self.hourUnitsLabel.stopAnimations()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.willAppear()
            }
            if let bannerDetails = model.bannerDetails  {
                self.updateUIWithBannerDetails(banner: bannerDetails)
            }
            
           
            
            if let totaltRetries = model.totalRetries, let userRetries = model.userDetails?.userRetries{
                if totaltRetries > 1 && userRetries < totaltRetries{
                    turnsContainerView.isHidden = false
                }else{
                    turnsContainerView.isHidden = true
                }
            }
            
            //if rewardItemDetail count == 1 then ??
            if let rewardItemDetail =  model.spinTheWheelReward, rewardItemDetail.count > 0 {
                if rewardItemDetail.count > 1 {
                    //Show multiple
                    // show collectionview
                    multiGiftImageView.isHidden = false
                    multiGiftImageView.layer.cornerRadius = 12
                    giftImageView.isHidden = true
                    var collectionItems: [BaseRowModel] = []
                    
                    for rewards in rewardItemDetail {
                        let imageModel = ImagesCollectionViewCellModel()
                        imageModel.imageName = rewards.rewardIcon.asStringOrEmpty()
                        let model = ImageCollectionViewCell.rowModel(model: imageModel)
                        collectionItems.append(model)
                    }
                    self.imagesArray = collectionItems
                    setupCollectionView()
                    startTimer()
                } else {
                    multiGiftImageView.isHidden = true
                    giftImageView.isHidden = false
                    
                    //show image view
                    if let userDetail = model.userDetails, let userRetries = userDetail.userRetries, userRetries == 0 {
                        //pick from banner
                        if let bannerDetails = model.bannerDetails, let img = bannerDetails.bannerImage, img.count > 0  {
                            self.giftImageView.setImageWithUrlString(img, defaultImage: "")
                        }
                    } else {
                        //pick from Reward Items
                        if let rewardItems = model.spinTheWheelReward, let offerImg = rewardItems[safe: 0]?.rewardIcon, offerImg.count > 0 {
                            self.giftImageView.setImageWithUrlString(offerImg, defaultImage: "")
                        }
                    }
                }
            } else {
                multiGiftImageView.isHidden = true
                giftImageView.isHidden = false
                
                //show image view
                //pick from banner
                if let bannerDetails = model.wheelTheme, let img = bannerDetails.bannerWheelUrl, img.count > 0  {
                    self.giftImageView.setImageWithUrlString(img, defaultImage: "")
                }
            }
            
            if let resource = model.wheelTheme {
                setTitleAndBackgroundColors(from: resource)
            }
            if let userRetries = model.userDetails?.userRetries, let totalRetries = model.totalRetries {
                if userRetries < totalRetries {
//                    self.giftEndsInLabel.text = "EndsInText".localizedString
                } else if userRetries == totalRetries {
//                    self.giftEndsInLabel.text = "DealEndInTitle".localizedString
                }
            }
        }
    }
    
    func configureCell(with model: SpinWheelTurnsViewRevampCellModel) {
        if let delegate = model.delegate {
            self.delegate = delegate
        }
        
//        turnsContainerView.isHidden = true
//        self.countDownView.isHidden = true
//        self.hrMinSecStackView.isHidden = true
        
        if let model = model.rowValue {
            guard let exp = model.bannerDetails?.expiryDate else {return}
            let expDate = CommonMethods.returnDate(from: exp, format: "yyyy-MM-dd HH:mm:ss")
            let secondsFromGMT = NSTimeZone.local.secondsFromGMT()
            targetDate = expDate?.addingTimeInterval(-TimeInterval(secondsFromGMT))
            self.secondUnitsLabel.stopAnimations()
            self.secondTensLabel.stopAnimations()
            self.minuteUnitsLabel.stopAnimations()
            self.minuteTensLabel.stopAnimations()
            self.hourTensLabel.stopAnimations()
            self.hourUnitsLabel.stopAnimations()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.willAppear()
            }
            if let bannerDetails = model.bannerDetails  {
                self.updateUIWithBannerDetails(banner: bannerDetails)
            }
            
           
            
            if let totaltRetries = model.totalRetries, let userRetries = model.userDetails?.userRetries{
                if totaltRetries > 1 && userRetries < totaltRetries{
                    turnsContainerView.isHidden = false
                }else{
                    turnsContainerView.isHidden = true
                }
            }
            
            //if rewardItemDetail count == 1 then ??
            if let rewardItemDetail =  model.spinTheWheelReward, rewardItemDetail.count > 0 {
                if rewardItemDetail.count > 1 {
                    //Show multiple
                    // show collectionview
                    multiGiftImageView.isHidden = false
                    multiGiftImageView.layer.cornerRadius = 12
                    giftImageView.isHidden = true
                    var collectionItems: [BaseRowModel] = []
                    
                    for rewards in rewardItemDetail {
                        let imageModel = ImagesCollectionViewCellModel()
                        imageModel.imageName = rewards.rewardIcon.asStringOrEmpty()
                        let model = ImageCollectionViewCell.rowModel(model: imageModel)
                        collectionItems.append(model)
                    }
                    self.imagesArray = collectionItems
                    setupCollectionView()
                    startTimer()
                } else {
                    multiGiftImageView.isHidden = true
                    giftImageView.isHidden = false
                    
                    //show image view
                    if let userDetail = model.userDetails, let userRetries = userDetail.userRetries, userRetries == 0 {
                        //pick from banner
                        if let bannerDetails = model.bannerDetails, let img = bannerDetails.bannerImage, img.count > 0  {
                            self.giftImageView.setImageWithUrlString(img, defaultImage: "")
                        }
                    } else {
                        //pick from Reward Items
                        if let rewardItems = model.spinTheWheelReward, let offerImg = rewardItems[safe: 0]?.rewardIcon, offerImg.count > 0 {
                            self.giftImageView.setImageWithUrlString(offerImg, defaultImage: "")
                        }
                    }
                }
            } else {
                multiGiftImageView.isHidden = true
                giftImageView.isHidden = false
                
                //show image view
                //pick from banner
                if let bannerDetails = model.wheelTheme, let img = bannerDetails.bannerWheelUrl, img.count > 0  {
                    self.giftImageView.setImageWithUrlString(img, defaultImage: "")
                }
            }
            
            if let resource = model.wheelTheme {
                setTitleAndBackgroundColors(from: resource)
            }
            if let userRetries = model.userDetails?.userRetries, let totalRetries = model.totalRetries {
                if userRetries < totalRetries {
//                    self.giftEndsInLabel.text = "EndsInText".localizedString
                } else if userRetries == totalRetries {
//                    self.giftEndsInLabel.text = "DealEndInTitle".localizedString
                }
            }
        }
    }
    
    func setTitleAndBackgroundColors(from resource: WheelTheme) {

        if let titleColor = resource.bannerTitleTextColorV1, titleColor.count > 0 {
            giftTitleLabel.textColor = UIColor.init(hex: titleColor.replacingOccurrences(of: "#", with: ""))
        }
        
        if let subTitleColor = resource.bannerSubTitleTextColorV1, subTitleColor.count > 0 {
            giftDescLabel.textColor  = UIColor.init(hex: subTitleColor.replacingOccurrences(of: "#", with: ""))
        }
        
        if let turnsColor = resource.bannerTurnsTextColor, turnsColor.count > 0 {
            giftTurnsLabel.textColor = UIColor.init(hex: turnsColor.replacingOccurrences(of: "#", with: ""))
        }
        
        if let turnsBgColor = resource.bannerTurnsBackgroundColor, turnsBgColor.count > 0 {
            turnsBgView.backgroundColor = UIColor.init(hex: turnsBgColor.replacingOccurrences(of: "#", with: ""))
        }
        
//        if let endColor = resource.bannerEndsInTextColor, endColor.count > 0 {
//            giftEndsInLabel.textColor = UIColor.init(hex: endColor.replacingOccurrences(of: "#", with: ""))
//        }
        
        if let expireColor = resource.bannerExpiryTextColor, expireColor.count > 0 {
//            dealTimerLbl.textColor = UIColor.init(hex: expireColor.replacingOccurrences(of: "#", with: ""))
        }
        
        // Sprint 101 - UC 11 - Spin Banner Background Color Key Change
        if let bgColor = resource.spinBannerBackgroundColorV1, bgColor.count > 0 {
            let color = UIColor(hex: bgColor.replacingOccurrences(of: "#", with: ""))
//            var opacity = 100.0
//            if let op = resource.spinBannerBackgroundOpacity, op > 0 {
//                opacity = Double(op)
//            }
//            roundCornerView.backgroundColor = color.withAlphaComponent(opacity/100)
            roundCornerView.backgroundColor = color
        }
        
        //New color theme for countdown view
//        var bannerUpperArr = [CGColor]()
//        var bannerBottomArr = [CGColor]()
//        var hookColorArr = [CGColor]()
        var clockTextColorArr = [CGColor]()
        
        var bannerTimerBoxColor: CGColor?
        
//        if let bannerExpTimerUpperBoxColor = resource.bannerExpiryTimerUpperBoxColor, !bannerExpTimerUpperBoxColor.isEmpty {
//            for color in bannerExpTimerUpperBoxColor {
//                let colorr = UIColor.init(hex: color.replacingOccurrences(of: "#", with: "")).cgColor
//                bannerUpperArr.append(colorr)
//            }
//        }
        
//        if let bannerExpTimerBottomBoxColor = resource.bannerExpiryTimerBottomBoxColor, !bannerExpTimerBottomBoxColor.isEmpty {
//            for color in bannerExpTimerBottomBoxColor {
//                bannerBottomArr.append(UIColor.init(hex: color.replacingOccurrences(of: "#", with: "")).cgColor)
//            }
//        }
        
        if let bannerArrowBorderColor = resource.bannerArrowIconBorderColor, bannerArrowBorderColor.count > 0 {
            let color = UIColor(hex: bannerArrowBorderColor.replacingOccurrences(of: "#", with: ""))
            bannerArrowRoundedView.borderColor = color
        }
        
        if let bannerArrowIconUrl = resource.bannerArrowIconUrl, bannerArrowIconUrl.count > 0 {
            bannerArrowImageView.setImageWithUrlString(bannerArrowIconUrl)
        } else {
            bannerArrowImageView.image = UIImage(named: "black_arrow_right")
        }
        
        if let bannerExpTimerTextColor = resource.bannerExpiryTimerTextColorV1, !bannerExpTimerTextColor.isEmpty {
            self.hourTitleLabel.textColor = UIColor.init(hex: bannerExpTimerTextColor.replacingOccurrences(of: "#", with: ""))
            self.minutesTitleLabel.textColor = UIColor.init(hex: bannerExpTimerTextColor.replacingOccurrences(of: "#", with: ""))
            self.secondsTitleLabel.textColor = UIColor.init(hex: bannerExpTimerTextColor.replacingOccurrences(of: "#", with: ""))
        }
        
        if AppCommonMethods.languageIsArabic() {
            hourTitleLabel.text = LanguageManager.sharedInstance().getLocalizedString(forKey: "HourTitle")
            minutesTitleLabel.text = LanguageManager.sharedInstance().getLocalizedString(forKey: "MinTitle")
            secondsTitleLabel.text = LanguageManager.sharedInstance().getLocalizedString(forKey: "SecTitle")
            
            bannerArrowImageView.image = bannerArrowImageView.image?.imageFlippedForRightToLeftLayoutDirection()
        }
        
//        if let bannerExpTimerHookColor = resource.bannerExpiryTimerHookColor, !bannerExpTimerHookColor.isEmpty {
//            for color in bannerExpTimerHookColor {
//                hookColorArr.append(UIColor.init(hex: color.replacingOccurrences(of: "#", with: "")).cgColor)
//            }
//        }
        
        if let bannerExpTimerClockTextColor = resource.bannerExpiryClockTextColor, !bannerExpTimerClockTextColor.isEmpty {
            for color in bannerExpTimerClockTextColor {
                clockTextColorArr.append(UIColor.init(hex: color.replacingOccurrences(of: "#", with: "")).cgColor)
            }
        }
        
        // Sprint 101 - UC 11 - Timer Box Single Solid Color
        if let color = resource.bannerExpiryTimerBoxColor, !color.isEmpty {
            bannerTimerBoxColor = UIColor(hex: color.replacingOccurrences(of: "#", with: "")).cgColor
        }
        
//        self.applyGradiantToFlippingViews(upperGradientColors: bannerUpperArr, bottomGradientColors: bannerBottomArr, clockTextColors: clockTextColorArr, hookGradientColors: hookColorArr, bannerExpiryTimerBoxColor: bannerTimerBoxColor)

        // Sprint 101 - UC 11 - Set Timer Box Single Solid Color
        setupCountDownTimerViews(
            backgroundColor: bannerTimerBoxColor,
            countDownTextColors: clockTextColorArr
        )
    }
    
    func updateUIWithBannerDetails(banner: TreasureChestBannerDetail) {
       
        //When we decide what to do then we will unhide it
        if let chances = banner.chancesContent, chances.count > 0 {
            turnsContainerView.isHidden = false
            giftTurnsLabel.text = chances
        } else {
            turnsContainerView.isHidden = true
        }
        
        giftDescLabel.text = banner.bannerDesc.asStringOrEmpty()
        giftDescLabel.isHidden = true
        if let giftDesc = banner.bannerDesc, giftDesc.count > 0{
            giftDescLabel.isHidden = false
        }
        
      
        giftTitleLabel.text = banner.bannerTitle.asStringOrEmpty()
        
        if let _ = banner.expiryDate {
            self.countDownView.isHidden = false
            self.hrMinSecStackView.isHidden = false
        } else {
            self.countDownView.isHidden = true
            self.hrMinSecStackView.isHidden = true
        }
    }

    
    // MARK: - Cell Provider
    
    // __________________________________________________________________________________
    //
    class func rowModel(model: PlayTreasureChestResponse?, delegate: SpinWheelTurnsViewCellDelegate?,tag: Int) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "SpinWheelTurnsViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = model
        rowModel.delegate = delegate
        rowModel.tag = tag
        return rowModel
    }
    
}

extension SpinWheelTurnsViewCell {
    func setGradientColorForView(view: SZGradientView, locations: [NSNumber], colors: [CGColor]) {
        view.updateColors(locations: locations, colors: colors)
    }
    
    func setSolidColorForView(view: SZGradientView, colors: [CGColor]) {
        view.updateColors(locations: [0.0, 0.0, 0.0, 0.0], colors: colors)
    }
    
    private func setupCountDownTimerViews(backgroundColor: CGColor?, countDownTextColors: [CGColor]?) {
        
        // Sprint 101 - UC 11 - Set Single Clock Text Color
        if let colors = countDownTextColors, !colors.isEmpty {
            let flippingLabels = contentView.findViews(subclassOf: FlippingLabel.self)
            flippingLabels.forEach {
                $0.layer.cornerRadius = 6
                $0.gradientColors = colors
                $0.locations = [0.0, 0.0, 0.0, 0.0]
            }
        }
        
        // Sprint 101 - UC 11 - Set Timer Box Single Solid Color
        if let color = backgroundColor {
            let countDownViews = contentView.findViews(subclassOf: CountDownCardView.self)
            countDownViews.forEach {
                $0.backgroundCGColor = color
            }
        }
    }
    
//    func applyGradiantToFlippingViews(upperGradientColors: [CGColor]?, bottomGradientColors: [CGColor]?, clockTextColors: [CGColor]?, hookGradientColors: [CGColor]?, bannerExpiryTimerBoxColor: CGColor?) {
        //seconds unit View gradient
//        self.secondUnitsLabel.layer.cornerRadius = 6
//        self.secondTensLabel.layer.cornerRadius = 6
//        self.minuteUnitsLabel.layer.cornerRadius = 6
//        self.minuteTensLabel.layer.cornerRadius = 6
//        self.hourUnitsLabel.layer.cornerRadius = 6
//        self.hourTensLabel.layer.cornerRadius = 6

        //Upper part of counter
//        if let upperGradients = upperGradientColors, !upperGradients.isEmpty {
//            self.setGradientColorForView(view: secondUnitUpperGradientView, locations: [0.25,0.49,0.8,1], colors: upperGradients)
//            self.setGradientColorForView(view: secondTensUpperGradientView, locations: [0.25,0.49,0.8,1], colors: upperGradients)
//            self.setGradientColorForView(view: minuteUnitsUpperGradientView, locations: [0.25,0.49,0.8,1], colors: upperGradients)
//            self.setGradientColorForView(view: minuteTensUpperGradientView, locations: [0.25,0.49,0.8,1], colors: upperGradients)
//            self.setGradientColorForView(view: hourUnitsUpperGradientView, locations: [0.25,0.49,0.8,1], colors: upperGradients)
//            self.setGradientColorForView(view: hourTensUpperGradientView, locations: [0.25,0.49,0.8,1], colors: upperGradients)
//        }
//
//        //Bottom part of counter
//        if let bottomGradients = upperGradientColors, !bottomGradients.isEmpty {
//            self.setGradientColorForView(view: secondUnitLowerGradientView, locations: [0.13,0.33,0.8,1], colors: bottomGradients)
//            self.setGradientColorForView(view: secondTensLowerGradientView, locations: [0.13,0.33,0.8,1], colors: bottomGradients)
//            self.setGradientColorForView(view: minuteUnitsLowerGradientView, locations: [0.13,0.33,0.8,1], colors: bottomGradients)
//            self.setGradientColorForView(view: minuteTensLowerGradientView, locations: [0.13,0.33,0.8,1], colors: bottomGradients)
//            self.setGradientColorForView(view: hourUnitsLowerGradientView, locations: [0.13,0.33,0.8,1], colors: bottomGradients)
//            self.setGradientColorForView(view: hourTensLowerGradientView, locations: [0.13,0.33,0.8,1], colors: bottomGradients)
//        }
        
//        if let countDownTextColors = clockTextColors, !countDownTextColors.isEmpty {
//            self.secondUnitsLabel.gradientColors = countDownTextColors
//            self.secondUnitsLabel.locations = [0.36,0.51,0.68,1]
//
//            self.secondTensLabel.gradientColors = countDownTextColors
//            self.secondTensLabel.locations = [0.36,0.51,0.68,1]
//
//            self.minuteUnitsLabel.gradientColors = countDownTextColors
//            self.minuteUnitsLabel.locations = [0.36,0.51,0.68,1]
//
//            self.minuteTensLabel.gradientColors = countDownTextColors
//            self.minuteTensLabel.locations = [0.36,0.51,0.68,1]
//
//            self.hourUnitsLabel.gradientColors = countDownTextColors
//            self.hourUnitsLabel.locations = [0.36,0.51,0.68,1]
//
//            self.hourTensLabel.gradientColors = countDownTextColors
//            self.hourTensLabel.locations = [0.36,0.51,0.68,1]
            
//        }
        //Hooks of counter
//        if let anchorGradient = hookGradientColors, !anchorGradient.isEmpty {
//            self.setGradientColorForView(view: secondUnitAnchorLeft, locations: [0.1,0.6,1], colors: anchorGradient)
//            self.setGradientColorForView(view: secondUnitAnchorRight, locations: [0.1,0.6,1], colors: anchorGradient)
//
//            self.setGradientColorForView(view: minuteUnitsAnchorLeft, locations: [0.1,0.6,1], colors: anchorGradient)
//            self.setGradientColorForView(view: minuteUnitsAnchorRight, locations: [0.1,0.6,1], colors: anchorGradient)
//
//            self.setGradientColorForView(view: hourUnitsAnchorLeft, locations: [0.1,0.6,1], colors: anchorGradient)
//            self.setGradientColorForView(view: hourUnitsAnchorRight, locations: [0.1,0.6,1], colors: anchorGradient)
//
//            self.setGradientColorForView(view: secondTensAnchorLeft, locations: [0.1,0.6,1], colors: anchorGradient)
//            self.setGradientColorForView(view: secondTensAnchorRight, locations: [0.1,0.6,1], colors: anchorGradient)
//
//            self.setGradientColorForView(view: minuteTensAnchorLeft, locations: [0.1,0.6,1], colors: anchorGradient)
//            self.setGradientColorForView(view: minuteTensAnchorRight, locations: [0.1,0.6,1], colors: anchorGradient)
//
//            self.setGradientColorForView(view: hourTensAnchorLeft, locations: [0.1,0.6,1], colors: anchorGradient)
//            self.setGradientColorForView(view: hourTensAnchorRight, locations: [0.1,0.6,1], colors: anchorGradient)
//        }

//    }
}
