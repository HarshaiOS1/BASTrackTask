//
//  Utils.swift
//  TaskTracker
//
//  Created by Harsha on 11/01/21.
//

import Foundation
import UIKit

public struct Utils{
    
    func showAlert(title: String?, description: String?, buttonTitle:String, sender: UIViewController) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
}

//Store key name
struct UserDefaultsKey {
    static let TOKEN = "usertoken"
}
