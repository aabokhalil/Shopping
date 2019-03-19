
//  Shopping
//
//  Created by ahmed abokhalil on 7/12/1440 AH.
//  Copyright © 1440 AH Razeware LLC. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  override init() {
    FirebaseApp.configure()
  }
  
  private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]? = [:]) -> Bool {
    UIApplication.shared.statusBarStyle = .lightContent
    
    
    return true
  }

}

