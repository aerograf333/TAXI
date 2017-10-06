//
//  LeftSidePanelVC.swift
//  TAXI
//
//  Created by Rkhorenko on 9/21/17.
//  Copyright © 2017 Rkhorenko. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()
    let currentUserId = Auth.auth().currentUser?.uid
    

    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userAccountTypeLbl: UILabel!
    @IBOutlet weak var userImageView: RoundImageView!
    @IBOutlet weak var loginOutBtn: UIButton!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var pickupModeLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickupModeSwitch.isOn = false
        pickupModeSwitch.isHidden = true
        pickupModeLbl.isHidden = true
        
        observePassengersAndDrivers()
        
        if Auth.auth().currentUser == nil {
            userEmailLbl.text = ""
            userAccountTypeLbl.text = ""
            userImageView.isHidden = true
            loginOutBtn.setTitle("Sing Up / Login", for: .normal)
        } else {
            userEmailLbl.text = Auth.auth().currentUser?.email
            userAccountTypeLbl.text = ""
            userImageView.isHidden = false
            loginOutBtn.setTitle("Logout", for: .normal)
        }
    }
    
    
    func observePassengersAndDrivers() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = "PASSENGER"
                    }
                }
            }
        })
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = "DRIVER"
                        self.pickupModeSwitch.isHidden = false
                        
                        let switchStatus = snap.childSnapshot(forPath: "isPicupModdeEnabled").value as! Bool
                        self.pickupModeSwitch.isOn = switchStatus
                        self.pickupModeLbl.isHidden = false
                    }
                }
            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func switchWasToggied(_ sender: Any) {
        if pickupModeSwitch.isOn {
            pickupModeLbl.text = "PICKUP MODE ENABLED"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPicupModdeEnabled": true])
        } else {
            pickupModeLbl.text = "PICKUP MODE DISABLED"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPicupModdeEnabled": false])
        }

        
    }
    
    
    @IBAction func singUpLoginBtnWasPressed(_ sender: Any) {
        if Auth.auth().currentUser == nil {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        present(loginVC!, animated: true, completion: nil)
        } else {
            do {
                try Auth.auth().signOut()
                userEmailLbl.text = ""
                userAccountTypeLbl.text = ""
                userImageView.isHidden = true
                pickupModeLbl.text = ""
                pickupModeSwitch.isHidden = true
                loginOutBtn.setTitle("Sing Up / Login", for: .normal)
            } catch (let error) {
                print(error)
            }
        }
    }

   
    
}
