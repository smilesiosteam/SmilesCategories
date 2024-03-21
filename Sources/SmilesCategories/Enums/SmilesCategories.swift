// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation
import SmilesUtilities

enum SectionIdentifier: String, SectionIdentifierProtocol {
    
    var identifier: String { return self.rawValue}
    
    case TOPPLACEHOLDER = "TOP_PLACEHOLDER"
    case TOPBANNERS = "TOP_BANNERS"
    case TOPCUISINE = "TOP_CUISINE"
    case RECOMMENDEDLISTING = "RECOMMENDED_LISTING"
    case CBDBANNER = "CBD_BANNER"
    case TOPCOLLECTIONS = "TOP_COLLECTIONS"
    case STORIES = "STORIES"
    case TOPBRANDS = "TOP_BRANDS"
    case SUBSCRIPTIONBANNERS = "SUBSCRIPTION_BANNERS"
    case OFFERLISTING = "OFFER_LISTING"
    case ORDERHISTORY = "ORDER_HISTORY"
    case ITEMCATEGORIES = "ITEM_CATEGORIES"
    case GAMIFICATIONBANNER = "GAMIFICATION_BANNER"
    case DODLISTING = "DOD_LISTING"
    case RESTAURANTLISTING = "RESTAURANT_LISTING"
    case SUBSCRIPTIONBANNERSV2 = "SUBSCRIPTION_BANNERS_V2"
    case THEME_SECTION = "THEME_SECTION"
}

public enum SortingCategoriesTypes : Int {
    case discount = 111, cashVoucher = 222, dealVoucher = 333
}

class SmilesCategoriesUtli {
    static let shared = SmilesCategoriesUtli()
    
    func saveOnUserDefaultWithValue(_ value : Any, key : String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func getValueFromUserDefaults(key : String) -> Any? {
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.value(forKey: key){
            return value
        }
        else{
            return nil
        }
    }
    
    func removeFromUserDefaults(key : String)  {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
