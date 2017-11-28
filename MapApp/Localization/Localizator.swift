//
//  Localized.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 22/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation


class Localizator {
    
    static private let loc:Localizator = Localizator()
    static var instance:Localizator{
        get {
            return loc
        }
    }
    
    private var availableLanguages:[String : String] = [String : String]()
    private var _currLang:String = "en"
    
    var currentLanguage:String {
        get {
            return _currLang
        }
        set {
            _currLang = availableLanguages[newValue]!
        }
    }
    
    func getAvailableLanguages () -> [String]{
        var langs:[String] = [String]()
        for l in availableLanguages{
            langs.append(l.key)
        }
        return langs
    }
    
    private init (){
        
        availableLanguages["English"] = "en"
        availableLanguages["Russian"] = "ru"
        availableLanguages["en"] = "ru"
        availableLanguages["ru"] = "ru"
    }
   
    
}

func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

extension String {
    var localize:String  {
        get
        {
            let localizator = Localizator.instance
            let path = Bundle.main.path(forResource: localizator.currentLanguage, ofType: "lproj")
            let bundle = Bundle(path: path!)
            
            return NSLocalizedString(self, tableName: "LocalizedStrings", bundle: bundle!, value: "", comment: "")
        }
        
    }
    
}
