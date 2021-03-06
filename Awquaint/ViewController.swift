//
//  ViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/20/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {

    //outlets

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.email.delegate = self
        self.password.delegate = self
    }


    // hide keyboard when users touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func menuButton(_ sender: UIBarButtonItem) {
    //show menu?
    }

    // when user presses return key, keyboard hides
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        email.resignFirstResponder()
        password.resignFirstResponder()

        return true
    }

    //actions
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    @IBAction func signUpButton(_ sender: Any) {
        signUp()
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
        //func
    func login(){
        let parameters: Parameters = [
                "email": email.text,
                "password": password.text
        ]

        Alamofire.request("https://awquaint.herokuapp.com/sessions", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            if response.response?.statusCode == 200 {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as? ProfileViewController {

                         let json = JSON(response.result.value)

                        viewController.namePassed = json["name"].stringValue
                        viewController.idPassed = json["id"].stringValue

                       print(json["name"])
                       print(json["id"])


                    self.present(viewController, animated: true, completion: nil)
                }
            } else {
                // alert user
                let alert = UIAlertController(title: "Incorrect password", message: "Incorrect password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func signUp(){
        if let signUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpViewController") as? SignUpViewController {
            self.present(signUpViewController, animated: true, completion: nil)
        }
    }
}

