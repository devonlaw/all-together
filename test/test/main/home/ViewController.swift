//
//  ViewController.swift
//  jargon-rewrite
//
//  Created by Devon Law on 2019-07-08.
//  Copyright © 2019 Slackers. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        option1.setTitle("Stress", for: .normal)
        option2.setTitle("Study", for: .normal)
        option3.setTitle("Stack", for: .normal)
    }


}

