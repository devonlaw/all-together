//
//  SelectJargon.swift
//  jargon-rewrite
//
//  Created by Devon Law on 2019-07-08.
//  Copyright © 2019 Slackers. All rights reserved.
//

import Foundation
import UIKit

class SelectJargon: UIViewController {
    var topic = String()
    var goBack = true
    var jargonSelected = String()
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch topic {
        case "devon":
            Button1.setTitle("Hockey", for: .normal)
            Button2.setTitle("Engineering", for: .normal)
        case "christopher":
            Button1.setTitle("Basketball", for: .normal)
            Button2.setTitle("Volleyball", for: .normal)
        default:
            Button1.setTitle("error", for: .normal)
            Button2.setTitle("errrrror", for: .normal)
        }
    }
    @IBAction func Button1(_ sender: Any) {
        jargonSelected = Button1.title(for: .normal)!
        goBack = false
    }
    @IBAction func Button2(_ sender: Any) {
        jargonSelected = Button2.title(for: .normal)!
        goBack = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if goBack == false {
            let destViewController: WordView = segue.destination as! WordView
            destViewController.jargon = jargonSelected
            destViewController.isCustom = false
        }
    }
}
