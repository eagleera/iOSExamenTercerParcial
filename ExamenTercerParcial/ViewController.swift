//
//  ViewController.swift
//  ExamenTercerParcial
//
//  Created by Noel Aguilera Terrazas on 09/05/20.
//  Copyright © 2020 Daniel Aguilera. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        // Do any additional setup after loading the view.
    }
    func authenticateUser() {
        let touchIDManager : PITouchIDManager = PITouchIDManager()
        touchIDManager.authenticateUser(success: { () -> () in
            OperationQueue.main.addOperation({ () -> Void in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let datosViewController = storyBoard.instantiateViewController(withIdentifier: "datos") as! DatosViewController
                    self.present(datosViewController, animated: true, completion: nil)

            })
        }, failure: { (evaluationError: NSError) -> () in
            switch evaluationError.code {
                case LAError.Code.systemCancel.rawValue:
                    print("Authentication cancelled by the system")
                case LAError.Code.userCancel.rawValue:
                    print("Authentication cancelled by the user")
                case LAError.Code.userFallback.rawValue:
                    print("User wants to use a password")
                    OperationQueue.main.addOperation({ () -> Void in
                    })
                case Int(kLAErrorBiometryNotEnrolled):
                    print("TouchID not enrolled")
                case LAError.Code.passcodeNotSet.rawValue:
                    print("Passcode not set")
                default:
                    print("Authentication failed")
                    OperationQueue.main.addOperation({ () -> Void in
                    })
                }
        })
    }
}
