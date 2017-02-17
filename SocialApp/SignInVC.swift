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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

            }

        })
    }

}

