//
//  SearchViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/21/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = interestListPassed[indexPath.row]
        
        return(cell)
    }
    
   
    var idListPassed: [String]!
    var interestListPassed: [String]!

    var customButton: UIButton!

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(interestListPassed!.count)
        return(interestListPassed!.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var receiverId = idListPassed[indexPath.row]
        
        let parameters: Parameters = [
           "current_user_id": UserDefaults.standard.integer(forKey: "id"),
           "receiver_id": receiverId
            ]
        
  
        Alamofire.request("https://awquaint-server.herokuapp.com/invitations", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            // if response.result == SUCCESS
            if response.response?.statusCode == 201 {
                let alert = UIAlertController(title: "Invitation sent!", message: "Please wait for a reply.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("it created!")
            }
            else if response.response?.statusCode == 200 {
                if let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pendingRequestViewController") as? PendingRequestViewController {
                    
                    let json = JSON(response.result.value)
                    searchViewController.inviterIdPassed = json["pending_sender_id"].stringValue
                    searchViewController.interestPassed  = json["pending_sender_interest"].stringValue
                    
                    self.present(searchViewController, animated: true, completion: nil)
            } else {
                // alert user
                let alert = UIAlertController(title: "Something went wrong", message: "Sorry, someething went wrong! Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
        func invitationStatus(){
            let parameters: Parameters = [
                "current_user_id": UserDefaults.standard.integer(forKey: "id"),
            ]
            
        }
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
    

        
        
        
        
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
