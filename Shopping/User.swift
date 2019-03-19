//
//  User.swift
//  Shopping
//
//  Created by ahmed abokhalil on 7/12/1440 AH.
//  Copyright © 1440 AH Razeware LLC. All rights reserved.
//

import Foundation

struct User {
  
  let uid: String
  let email: String
  
  init(authData: User) {
    uid = authData.uid
    email = authData.email
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
  
}
