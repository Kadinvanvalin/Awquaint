//
//  SignUpViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/24/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var interest: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    
    func login(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewController") as? ViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.interest.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // when user presses return key, keyboard hides
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
        interest.resignFirstResponder()
        return true
    }

    @IBAction func signUpButton(_ sender: Any) {
        signUp()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func signUp(){
        let parameters: Parameters = [
            "user":[
                "name": name.text,
                "email": email.text,
                "password": password.text,
                "interest": interest.text
            ]
        ]
        
        Alamofire.request("https://awquaint-server.herokuapp.com/users", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            // if response.result == SUCCESS
            if response.response?.statusCode == 200 {
                // move to next view
                if let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as? ProfileViewController {
                    
                    profileViewController.namePassed = self.name.text!
                    profileViewController.interestPassed = self.interest.text!
                
                    let setInterest = UserDefaults.standard.string(forKey: "interest")
                    if setInterest == nil {
                        UserDefaults.standard.set(profileViewController.interestPassed, forKey: "interest")
                    }
                    
                    self.present(profileViewController, animated: true, completion: nil)
                }
            } else {
                // alert user
                let alert = UIAlertController(title: "incorrect password", message: "Incorrect password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
