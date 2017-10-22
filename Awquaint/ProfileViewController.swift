//
//  ProfileViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/21/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var namePassed = ""
    var idPassed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = namePassed

    
    }
    

    @IBAction func getAwquaintedButton(_ sender: Any) {
        getAwquainted()
    }
    
    func getAwquainted() {
        if let profileViewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController {
            
            self.present(profileViewController, animated: true, completion: nil)
        }
    }
    
}
