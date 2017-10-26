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
import CoreLocation

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
        self.tableView.backgroundColor = UIColor(red: 62/255, green: 162/255, blue: 165/255, alpha: 1.0)
        self.tableView.separatorColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("yeah something bad happened")
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = interestListPassed[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name:"MarkerFelt-Thin", size:25)
        
      
        
        return(cell)
    }
    
    var idPassed = ""
    var idListPassed: [String] = [];
    var interestListPassed: [String] = []
    
    var customButton: UIButton!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(interestListPassed.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var receiverId = idListPassed[indexPath.row]
        print(idListPassed)
        let parameters: Parameters = [
           "current_user_id": UserDefaults.standard.string(forKey: "id")!,
           "receiver_id": receiverId
            ]
        
        Alamofire.request("https://awquaint-server.herokuapp.com/invitations", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in

            // if response.result == SUCCESS
            if response.response?.statusCode == 201 {
                let alert = UIAlertController(title: "Invitation sent!", message: "Please wait for a reply.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("it created!")
            }
            else if response.response?.statusCode == 200 {
                if let pendingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pendingRequestViewController") as? PendingRequestViewController {
                    let json = JSON(response.result.value)
                    
                    pendingViewController.idPassed = UserDefaults.standard.string(forKey: "id")!
                    pendingViewController.inviterIdPassed = json["pending_sender_id"].stringValue
                    pendingViewController.interestPassed  = json["pending_sender_interest"].stringValue
        
                    
                    self.present(pendingViewController, animated: true, completion: nil)
                    }
                } else {
                // alert user
                let alert = UIAlertController(title: "Something went wrong", message: "Sorry, someething went wrong! Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
            
            }
        }
    
    
    @IBAction func homeButton(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        goHome()
    }
    
    func goHome(){
        locationManager.stopUpdatingLocation()
        if let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as? ProfileViewController {
            profileViewController.idPassed = UserDefaults.standard.string(forKey: "id")!
            self.present(profileViewController, animated: true, completion: nil)
        }
    }
    @IBAction func checkInvitesButton(_ sender: Any) {
        invitationStatus()
    }
    
        func invitationStatus(){
            let parameters: Parameters = [
                "current_user_id": UserDefaults.standard.integer(forKey: "id"),
            ]
            Alamofire.request("https://awquaint-server.herokuapp.com/invitations/check", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                if response.response?.statusCode == 202 {
                    //YOU HAVE ACCEPTED INVITE
                    print("accepted invite")
                    if let matchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "matchViewController") as? MatchViewController {
                        let json = JSON(response.result.value)
                        
                        matchViewController.idPassed = UserDefaults.standard.string(forKey: "id")!
                        matchViewController.matchName = json["name"].stringValue
                        matchViewController.matchInterest = json["interest"].stringValue
                        matchViewController.matchImageUrl = json["image"].stringValue
                        self.locationManager.stopUpdatingLocation()
                        self.present(matchViewController, animated: true, completion: nil)
                    }
                }
                else if response.response?.statusCode == 200 {
                    print("pending invite")
                    if let pendingRequestViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pendingRequestViewController") as? PendingRequestViewController {
                        let json = JSON(response.result.value)

                        pendingRequestViewController.idPassed = UserDefaults.standard.string(forKey: "id")!
                        pendingRequestViewController.inviterIdPassed = json["pending_sender_id"].stringValue
                        pendingRequestViewController.interestPassed = json["pending_sender_interest"].stringValue
                        self.present(pendingRequestViewController, animated: true, completion: nil)
                    }
                }
                else if response.response?.statusCode == 418 {
                    print("declined invite")
                    let alert = UIAlertController(title: "Sorry, invitation was declined", message: "Please invite a new awquaintence!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    print("nothing")
                    let alert = UIAlertController(title: "Sorry, there are no updates at this time", message: " ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        print("did update ?")
        if let location = locations.first {
            let parameters: Parameters = [
                "latitude": (location.coordinate.latitude),
                "longitude": (location.coordinate.longitude),
                "id": UserDefaults.standard.object(forKey: "id")
            ]
            nearbyRequest(parameters: parameters)
        }

    }
    
    func nearbyRequest (parameters: Parameters)  {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request("https://awquaint-server.herokuapp.com/users/search", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.response?.statusCode == 200 {
//                if let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController {
                
                    let usersJson = JSON(response.result.value)
                    print(usersJson)
                    var idList = [String]()
                    var interestList = [String]()
                    if usersJson.count > 0 {
                        for i in 0...(usersJson.count - 1) {
                            if let id = usersJson[i]["id"].string {
                                idList.append(id)
                            }
                        }
                        
                        for i in 0...(usersJson.count - 1) {
                            if let interest = (usersJson[i]["interest"]).string {
                                interestList.append(interest)
                            }
                        }
                    }
                    print(type(of:idList))
                    print(type(of:interestList))
                    
                    
                    self.idListPassed = idList
                    self.interestListPassed = interestList
                    self.tableView.reloadData()

                }
            }
    }
}
