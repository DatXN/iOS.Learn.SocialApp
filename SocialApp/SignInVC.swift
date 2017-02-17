//
//

//  SocialApp
//
//  Created by Nguyễn Xuân Đạt on 2/17/17.
//  Copyright © 2017 Nguyễn Xuân Đạt. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    override func viewDidAppear(_ animated: Bool) {
        // Perform a segue has to be in the view did appear
        loggedIn()

    }
    func loggedIn() {
        // Store credential in keychain, event user delete the app, it will their
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeedSegue", sender: nil)
        }
    }

    @IBAction func fbSignIn_OnPressed(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
            if error != nil {
                print("FUCK: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("OHHHH: User cancelled authenticate with Facebook")

            } else {
                print("JESS: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        })

    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in

            if error != nil {
                print("FUCK: Unable to authenticate with Firebase - \(String(describing: error))")

            } else {
                print("JESS: Successfully authenticated with Firebase")
                self.completeSignIn(id: (user?.uid)!)
            }

        })
    }

    @IBAction func btnSignIn_OnPressed(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if (error == nil) {
                    print("JESS: Email user authenticated with Firebase")
                    self.completeSignIn(id: (user?.uid)!)

                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("OH NO: Unnable to authenticate with Firebase using email")

                        } else {
                            print("JESS: Successfully created user & authenticate with Firebase")
                            self.completeSignIn(id: (user?.uid)!)

                        }

                    })
                }

            })
        }

    }

    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("OK: Data saved to keychain \(keychainResult)")
        loggedIn()
    }
}

