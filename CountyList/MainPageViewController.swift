//
//  MainPageViewController.swift
//  CountyList
//
//  Created by Raghvendra on 22/01/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

class MainPageViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
}
