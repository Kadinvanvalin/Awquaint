//
//  ProfileViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/21/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var namePassed = ""
    var idPassed = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = namePassed
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(idPassed, forKey: "id")
//        UserDefaults.standard.synchronize()
    
    }
    

    @IBAction func getAwquaintedButton(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        if let location = locations.first {
            let parameters: Parameters = [
                "latitude": (location.coordinate.latitude),
                "longitude": (location.coordinate.longitude),
                "id":idPassed
            ]
            nearbyRequest(parameters: parameters)
        }
        
    }
    
    func nearbyRequest (parameters: Parameters)  {
        Alamofire.request("https://awquaint-server.herokuapp.com/users/search", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
        
            if response.response?.statusCode == 200 {
                if let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController {
                    
                    let usersJson = JSON(response.result.value)
                        print(usersJson)
                    var idList = [String]()
                    var interestList = [String]()
                    
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
                    
                    print(type(of:idList))
                    print(type(of:interestList))
                    
                
                    searchViewController.idListPassed = idList
                    searchViewController.interestListPassed = interestList
                    self.present(searchViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
