//
//  LoginViewController.swift
//  Shopping
//
//  Created by ahmed abokhalil on 7/12/1440 AH.
//  Copyright © 1440 AH Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  override func viewDidLoad() {
    
    let rootRef = Database.database().reference()
    let childRef = Database.database().reference(withPath: "shopping-items")
    let itemsRef = rootRef.child("shopping-items")

 //    observe login state , if so , go to ...
    
//    let listene = Auth.auth().addStateDidChangeListener { (auth, user) in
//      if user != nil {
//        print("from viewdidload jkhlkjlkjhlkjhlkhjhlkhljkhlkhlkhljklkjhlkjhlkhjlk")
//        print(user?.email)
//        self.performSegue(withIdentifier: self.loginToList, sender: nil)
//      }
//    }
//    Auth.auth().removeStateDidChangeListener(listene)
  }
  
  
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
   
    guard let email =
      textFieldLoginEmail.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
      showAlert(title: "Error", message: "Email Is Empty")
      return
    }
    
    guard let password = textFieldLoginPassword.text, !password.isEmpty else {
      showAlert(title: "Error", message: "Password Is Empty")
      return
    }
    
    self.view.endEditing(true)
    Auth.auth().signIn(withEmail: email, password: password) { (user, error)  in

      if  ((user) != nil) {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
      } else {
        self.showAlert(title: "Error", message: "No such user ")
      }

        if error != nil {
          if let errorCode = AuthErrorCode(rawValue: error!._code){
            switch errorCode {
            case .nullUser :
              self.showAlert(title: "Error", message: "No Such User !")
            case .weakPassword :
              self.showAlert(title: "Error", message: "Please provide a strong password")
              print("Please provide a strong password")
            default :
              print("there is an error")
            }
          }
        }
      }
    
    }
    
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register",
                                  message: "Register",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
                                    let emailField = alert.textFields![0]
                                    let passwordField = alert.textFields![1]
                                    Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                                      if error != nil {
                                        if let errorCode = AuthErrorCode(rawValue: error!._code){
                                          switch errorCode {
                                          case .weakPassword :
                                            self.showAlert(title: "Error", message: "Please provide a strong password")
                                            print("Please provide a strong password")
                                          default :
                                            print("there is an error")
                                          }
                                        }
                                        
                                      }
//                                      let user = Auth.auth().currentUser
//                                      if user != nil {
////                                        user?.sendEmailVerification() { (error) in
////                                          print(error?.localizedDescription )
////                                        }
                                        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!)
                                        self.performSegue(withIdentifier: self.loginToList, sender: nil)
//                                      }
                                    }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
  
}
