//
//  MatchViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/22/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MatchViewController: UIViewController {
    
    var idPassed = ""
    var matchName = ""
    var matchInterest = ""
    var matchImageUrl = ""
    
    
    @IBOutlet weak var connectionNameLabel: UILabel!
    @IBOutlet weak var connectionInterestLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBAction func homeButton(_ sender: Any) {
        goHome()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.connectionNameLabel.text = matchName
        self.connectionInterestLabel.text = matchInterest
        // Do any additional setup after loading the view.
        
        Alamofire.request(matchImageUrl).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            print("hello")
            
            if let image = response.result.value {
                self.profileImage.image = image
                print("image pulled from database")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goHome(){
        if let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as? ProfileViewController {
            profileViewController.idPassed = UserDefaults.standard.string(forKey: "id")!
            self.present(profileViewController, animated: true, completion: nil)
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
