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

//   let locationManager = CLLocationManager()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var namePassed = ""
    var idPassed = ""
    var interestPassed = ""
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var interestLabel: UILabel!

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
        print(UserDefaults.standard.string(forKey: "interest"))
        // set the labels
        self.nameLabel.text = updatedName
        self.interestLabel.text = UserDefaults.standard.string(forKey: "interest")
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
        if let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController {
            
            self.present(searchViewController, animated: true, completion: nil)
        }
    }

    @IBAction func editInterestButton(_ sender: Any) {
        showInputDialog()
    }
    
    func showInputDialog() {
        let alertController = UIAlertController(title: "Update Interests", message: "Please enter your interests", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            let interest = alertController.textFields?[0].text
            self.interestLabel.text = interest!
            UserDefaults.standard.set(interest, forKey: "interest")
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
}
