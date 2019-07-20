//
//  TopicSelect.swift
//  jargon-rewrite
//
//  Created by Devon Law on 2019-07-08.
//  Copyright © 2019 Slackers. All rights reserved.
//

import Foundation
import UIKit

class TopicSelect: UIViewController {
    var topicTapped = false
    var buttonTapped = String()
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicTapped = false
        Button1.setTitle("devon", for: .normal)
        Button2.setTitle("christopher", for: .normal)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if topicTapped {
            let destViewController: SelectJargon = segue.destination as! SelectJargon
            destViewController.topic = buttonTapped
        }
    }
    @IBAction func Button1(_ sender: Any) {
        topicTapped = true
        buttonTapped = Button1.title(for: .normal)!
    }
    @IBAction func Button2(_ sender: Any) {
        topicTapped = true
        buttonTapped = Button2.title(for: .normal)!
    }
}
