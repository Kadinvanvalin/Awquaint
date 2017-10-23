//
//  MatchViewController.swift
//  Awquaint
//
//  Created by Apprentice on 10/22/17.
//  Copyright © 2017 Apprentice. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    
    var idPassed = ""
    var matchName = ""
    var matchInterest = ""

    @IBOutlet weak var connectionNameLabel: UILabel!
    @IBOutlet weak var connectionInterestLabel: UILabel!
    
    @IBAction func homeButton(_ sender: Any) {
        goHome()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.connectionNameLabel.text = matchName
        self.connectionInterestLabel.text = matchInterest
        // Do any additional setup after loading the view.
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
