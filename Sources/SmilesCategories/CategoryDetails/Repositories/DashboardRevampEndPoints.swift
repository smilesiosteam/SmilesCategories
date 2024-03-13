//
//  DashboardRevampEndPoints.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public enum DashboardRevampEndPoints: String, CaseIterable {
    case itemCategories
    case nearbyOffers
    case spinWheelOptIn
    case beginTreasureChest
    case treasureChestOptIn
    case playTreasureChest
    case getLotterySeries
    case playSpinTheWheel
    case appResources
    case toolTips
    case consentsForApp
    case verifyEmail
    case birthdayGift
    case rewardPoints
    case sendVerifyEmailLink
    case getEligibilityMatrix
    case getAlternateAppIcons
}

extension DashboardRevampEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .itemCategories:
            return "home/v2/item-categories"
        case .nearbyOffers:
            return "home/v1/deals-for-you"
        case .spinWheelOptIn:
            return "gamification/spin-the-wheel/v1/opt-in"
        case .beginTreasureChest:
            return "gamification/treasure-chest/begin-treasure-chest"
        case .treasureChestOptIn:
            return "gamification/treasure-chest/opt-in"
        case .playTreasureChest:
            return "gamification/treasure-chest/play-treasure-chest"
        case .getLotterySeries:
            return "gamification/spin-the-wheel/v1/lottery-series"
        case .playSpinTheWheel:
            return "gamification/spin-the-wheel/v1/play-spin-the-wheel"
        case .appResources:
            return "resources/get-resource"
        case .toolTips:
            return "home/get-tool-tips-details"
        case .consentsForApp:
            return "home/redirection-consent-config"
        case .birthdayGift:
            return "birthday-gift/fetch-birthday-gift"
        case .rewardPoints:
            return "home/get-reward-points"
        case .verifyEmail:
            return "profile/v1/email-verification-link"
        case .sendVerifyEmailLink:
            return "profile/send-verification-email"
        case .getEligibilityMatrix:
            return "login/get-eligibility-matrix"
        case .getAlternateAppIcons:
            return "home/current-icon"
        }
    }
}
