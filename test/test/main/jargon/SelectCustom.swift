//
//  SelectCustom.swift
//  jargon-rewrite
//
//  Created by Devon Law on 2019-07-08.
//  Copyright © 2019 Slackers. All rights reserved.
//

import Foundation
import UIKit

class SelectCustom: UIViewController {
    var array: [String] = []
    var numFiles = 0
    var listPicked = false
    var jargon = String()
    @IBOutlet weak var enterList: UITextField!
    @IBOutlet weak var createdLists: UITextView!
    @IBAction func go(_ sender: Any) {
        listPicked = true
        jargon = enterList.text!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCreatedLists()
        createdLists.isEditable = false
    }
    
    func getCreatedLists() {
        var textInFile = String()
        array = findLines()
        for line in array {
            textInFile.append(line + "\n")
        }
        if textInFile != "" {
            createdLists.text = textInFile
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func findLines() -> Array<String> {
        var arrayOfStrings: [String] = []
        do {
            let path = Bundle.main.path(forResource: "customLists", ofType: "txt")
            if path != nil {
                let data = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                arrayOfStrings = data.components(separatedBy: "\n")
            } else {
                let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = DocumentDirURL.appendingPathComponent("customLists").appendingPathExtension("txt")
                let data = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
                arrayOfStrings = data.components(separatedBy: "\n")
            }
        } catch let error as NSError {
            print(error)
        }
        return arrayOfStrings
    }
    
    func fileExists(name: String) -> Bool {
        let fileName = "allTextFiles"
        var arrayOfStrings: Array<String> = []
        do {
            let path = Bundle.main.path(forResource: fileName, ofType: "txt")
            let data = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            arrayOfStrings = data.components(separatedBy: "\n")
        } catch { print(error) }
        
        for line in arrayOfStrings {
            if line == name {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if listPicked == true {
            let destViewController: WordView = segue.destination as! WordView
            destViewController.jargon = jargon
            
            if fileExists(name: jargon) {
                destViewController.isCustom = false
            } else {
                destViewController.isCustom = true
            }
        }
    }
}
