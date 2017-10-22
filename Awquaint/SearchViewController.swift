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
    var idListPassed: [String]!
    var interestListPassed: [String]!
    
//    let list = ["javascript", "pb & j", "la croix"]
//    let name = ["kadin", "sqiuggles", "hermione"]
    var customButton: UIButton!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(interestListPassed!.count)
        return(interestListPassed!.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(idListPassed[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = interestListPassed[indexPath.row]
        
        //button
        //        let btn = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
        //        btn.titleLabel?.text = name[indexPath.row]
        //        cell.contentView.addSubview(btn)
        //        cell.btn.tag = indexPath.row
        //        cell.btn.addTarget(self, action: #selector(SearchViewController.printSomething), for: UIControlEvents.touchUpInside)
        //        btn.backgroundColor = .green()
        //        btn.setTitle("Click Me", forState: .Normal)
        //        btn.addTarget(self, action: #selector(MyClass.buttonAction), forControlEvents: .TouchUpInside)
        //        customButton = btn
        
        
        
        return(cell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
