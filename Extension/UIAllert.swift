//
//  UIAllert.swift
//  Shopping
//
//  Created by ahmed abokhalil on 7/12/1440 AH.
//  Copyright © 1440 AH Razeware LLC. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showAlert(title: String, message: String, okTitle: String = "OK", okHandler: ((UIAlertAction)->Void)? = nil) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: okHandler))
    
    self.present(alert, animated: true, completion: nil)
  }
  
}
