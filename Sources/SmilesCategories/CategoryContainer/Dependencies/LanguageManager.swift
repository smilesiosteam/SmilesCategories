//
//  File.swift
//  
//
//  Created by Habib Rehman on 12/03/2024.
//

import Foundation

enum CurrentLanguage {
    case English
    case Arabic
}

class LanguageManager {
    static let shared = LanguageManager()
    
    private var englishResources: [String: String] = [:]
    private var arabicResources: [String: String] = [:]
    private var currentLanguage: CurrentLanguage = .English
    
    private init() {
        if let settingLang = UserDefaults.standard.object(forKey: "settingLang") as? Bool, !settingLang {
            var language = Bundle.main.preferredLocalizations.first ?? ""
            if let currentLang = UserDefaults.standard.string(forKey: "currentLanguage"), !currentLang.isEmpty {
                language = currentLang
            }
            
            if language.contains("en") {
                setLanguage(language: .English)
            } else if language.contains("ar") {
                setLanguage(language: .Arabic)
            }
        } else if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
            if lang.contains("en") {
                setLanguage(language: .English)
            } else if lang.contains("ar") {
                setLanguage(language: .Arabic)
            }
        } else {
            setLanguage(language: .English)
        }
        
        if let englishResourcesPath = Bundle.main.path(forResource: "English_Resources", ofType: "plist"),
           let englishDict = NSDictionary(contentsOfFile: englishResourcesPath) as? [String: String] {
            englishResources = englishDict
        }
        
        if let arabicResourcesPath = Bundle.main.path(forResource: "Arabic_Resources", ofType: "plist"),
           let arabicDict = NSDictionary(contentsOfFile: arabicResourcesPath) as? [String: String] {
            arabicResources = arabicDict
        }
    }
    
    func setLanguage(language: CurrentLanguage) {
        let languageKey: String
        if language == .English {
            languageKey = "en"
        } else {
            languageKey = "ar"
        }
        
        if let path = Bundle.main.path(forResource: languageKey, ofType: "lproj") {
            Bundle(path: path)?.localizedString(forKey: "", value: nil, table: nil)
        }
        
        currentLanguage = language
        
        NotificationCenter.default.post(name: Notification.Name("LanguageChangeNotification"), object: nil, userInfo: ["lang": languageKey])
    }
    
    func getLocalizedString(forKey key: String) -> String {
        if currentLanguage == .English, let value = englishResources[key] {
            return value
        } else if currentLanguage == .Arabic, let value = arabicResources[key] {
            return value
        }
        
        return key
    }
    
    func getLocalizedArray(forKey key: String) -> [String] {
        if currentLanguage == .English, let array = englishResources[key] {
            return array.components(separatedBy: ",")
        } else if currentLanguage == .Arabic, let array = arabicResources[key] {
            return array.components(separatedBy: ",")
        }
        
        return []
    }
    
    func nsLocalizedImage(named imageName: String) -> String {
        if currentLanguage == .Arabic {
            return "\(imageName)_ar"
        }
        return imageName
    }
}
