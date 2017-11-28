//
//  Utils.swift
//  MapApp
//
//  Created by Valeev Anatoliy on 17/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let vctrl = self
        vctrl.present(alert, animated: true, completion: nil)
    }
    
}

extension UITextField{
    
    func setPlaceholder (text:String, color:UIColor){
        self.attributedPlaceholder = NSAttributedString(string: text,
        attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
}


extension Dictionary {
    
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sorted() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}
extension UIView{
    
    func setBorder (borderWidth: CGFloat = 1.0, borderColor: UIColor){
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}

extension CGPoint{
    func toString () -> String{
        return String ("x: \(x) y: \(y)")
    }
}
