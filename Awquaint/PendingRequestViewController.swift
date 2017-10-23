//
//  PendingRequestViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/22/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class PendingRequestViewController: UIViewController {

    var idPassed = ""
    var inviterIdPassed = ""
    var interestPassed = ""
    
    
    @IBOutlet weak var interestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interestLabel.text = interestPassed
        // Do any additional setup after loading the view.
    }
    

    @IBAction func acceptButton(_ sender: Any) {
        print("here")
        accept()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func accept(){
        let parameters: Parameters = [
            "sender_id": "1",
            "current_user_id": "3",
            "response": "accepted"
        ]
        
        Alamofire.request("https://awquaint-server.herokuapp.com/invitations/response", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if response.response?.statusCode == 200 {
                if let pendingRequestViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "matchViewController") as? MatchViewController {
                    let json = JSON(response.result.value)
                    pendingRequestViewController.matchName = json["name"].stringValue
                    pendingRequestViewController.matchInterest = json["interest"].stringValue
                    self.present(pendingRequestViewController, animated: true, completion: nil)
                print(json)
                }
            }
        }
    }
}
