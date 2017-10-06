//
//  LoginVC.swift
//  TAXI
//
//  Created by Rkhorenko on 9/22/17.
//  Copyright © 2017 Rkhorenko. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController, UITextFieldDelegate, Alertable {
    
    
    @IBOutlet weak var emailFiled: RoundedCornerTextFiled!

    @IBOutlet weak var passwordFiled: RoundedCornerTextFiled!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var authBtn: RoundedShadowButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        
        emailFiled.delegate = self
        passwordFiled.delegate = self
        
        view.bindtoKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func authBtnWasPressed(_ sender: Any) {
        
        
        if emailFiled.text != nil && passwordFiled.text  != nil {
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            
            
            if let email = emailFiled.text, let password = passwordFiled.text {
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {                                    switch errorCode {
                        case .invalidEmail:
                           self.showAlert("CreateEmail invalid. Please try again!")
                        case .userNotFound:
                            print("Password to small")
                        case .emailAlreadyInUse:
                          self.showAlert("That email is already in use. Please try again!")
                        default:
                            print(" An unexpected error!")

                            }
                        }
                    }else {
                        if let user = user{
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                let userData = ["provider": user.providerID] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            } else {
                                let userData = ["provider": user.providerID,"userIsDriver": true, "isPicupModdeEnabled": false, "driverIsOnTrip": false] as [String: Any]
                                
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        print("Successfully created a new user with Firebase")
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                })
                

                
                
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        if let user = user {
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                let userData = ["provider": user.providerID] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            }else {
                                let userData = ["provider": user.providerID, "userIsDriver": true, "isPicupModdeEnabled": false, "driverIsOnTrip": false] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        print("Email user authenticated successfully with Firebase")
                        self.dismiss(animated: true, completion: nil)
                    } else{
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {                                    switch errorCode {
                        case .invalidEmail:
                            self.showAlert("SignInEmail invalid. Please try again!")
                            
                        case .emailAlreadyInUse:
                            self.showAlert("That email is already in use. Please try again!")
                            
                        case .wrongPassword:
                            self.showAlert( " Whoops! That was the wrong password!" )
                            
                        case .accountExistsWithDifferentCredential:
                            print("accountExistsWithDifferentCredential")
                            
                        case .appNotAuthorized:
                            print("appNotAuthorized")
                            
                        case .appNotVerified:
                            print("appNotVerified")
                            
                        case .credentialAlreadyInUse:
                            print("credentialAlreadyInUse")
                            
                        case .customTokenMismatch:
                            print("customTokenMismatch")
                            
                        case .expiredActionCode:
                            print("expiredActionCode")
                            
                        case .internalError:
                            print("internalError")
                            
                        case .invalidActionCode:
                            print("invalidActionCode")
                            
                        case .invalidAPIKey:
                            print("invalidAPIKey")

                        case .invalidAppCredential:
                            print("invalidAppCredential")
                            
                        case .userNotFound:
                            print("Password to small")
                            
                        default:
                            print(" An unexpected error!")
                            }
                        }

                        
                        
                    }
                })
            }
       }
    }
}
