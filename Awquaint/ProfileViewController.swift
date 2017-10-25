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

class ProfileViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var namePassed = ""
    var idPassed = ""
   
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = UserDefaults.standard.object(forKey: "id")
        let userName = UserDefaults.standard.string(forKey: "name")
        let data = UserDefaults.standard.object(forKey: "userImage") as? NSData
        if userId == nil {
            UserDefaults.standard.set(idPassed, forKey: "id")
        }
        if userName == nil {
            UserDefaults.standard.set(namePassed, forKey: "name")
        }
        let updatedName = UserDefaults.standard.string(forKey: "name")

        if data != nil {
            self.profileImage.image = UIImage(data: data as! Data)
        }
        self.nameLabel.text = updatedName
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = selectedPhoto
        dismiss(animated: true, completion: nil)
        
        let image = profileImage.image
        
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        let userImage:NSData = UIImagePNGRepresentation(image!)! as NSData
        UserDefaults.standard.set(userImage, forKey: "userImage")
        
        let parameters = ["id": idPassed]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "profile.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"https://awquaint-server.herokuapp.com/users/profile")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func getAwquaintedButton(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
            
        }
    }
    
    @IBOutlet weak var interestLabel: UILabel!
    @IBAction func editInterestButton(_ sender: Any) {
        showInputDialog()
    }
    
    func showInputDialog() {
        let alertController = UIAlertController(title: "Update Interests", message: "Please enter your interests", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            let interest = alertController.textFields?[0].text
            self.interestLabel.text = "Interest:" + interest!
            self.updateInterest(interest: interest!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter interest"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateInterest(interest: String) {
        let parameters: Parameters = [
            "id": UserDefaults.standard.object(forKey: "id"),
            "interest": interest
        ]
        
        Alamofire.request("https://awquaint-server.herokuapp.com/users/interest", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.response?.statusCode == 200 {
                print("success")
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("yeah something bad happened")
    }
    
    
    func nearbyRequest (parameters: Parameters)  {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request("https://awquaint-server.herokuapp.com/users/search", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
        
            if response.response?.statusCode == 200 {
                if let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController {
                    
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
                    
                
                    searchViewController.idListPassed = idList
                    searchViewController.interestListPassed = interestList
                    self.present(searchViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
