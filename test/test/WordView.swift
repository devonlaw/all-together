//
//  WordView.swift
//  jargon-rewrite
//
//  Created by Devon Law on 2019-07-08.
//  Copyright © 2019 Slackers. All rights reserved.
//

import Foundation
import UIKit

class WordView: UIViewController, UITextViewDelegate {
    var jargon = String()
    var fileName = String()
    var lineNumber = 1
    var canTap = true
    var canTapBack = true
    var isCustom = false
    var array: [String] = []
    var confirmDisplayed = false
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var wordDesc: UITextView!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBAction func previous(_ sender: Any) {
        if (canTapBack) {
            lineNumber -= 1
            setContent(array: array)
        }
        edit.setTitle("Edit", for: .normal)
        cancel.isHidden = true
        wordDesc.isEditable = false
        confirmDisplayed = false
    }
    @IBOutlet weak var wordLabel: UILabel!
    @IBAction func next(_ sender: Any) {
        if (canTap){
            lineNumber += 1
            setContent(array: array)
        }
        edit.setTitle("Edit", for: .normal)
        cancel.isHidden = true
        wordDesc.isEditable = false
        confirmDisplayed = false
    }
    
    @IBAction func editTapped(_ sender: Any) {
        //change edit label to "confirm"
        if confirmDisplayed == false {
            //editing is enabled
            edit.setTitle("Confirm", for: .normal)
            cancel.isHidden = false
            wordDesc.textColor = UIColor.black
            wordDesc.isEditable = true
            confirmDisplayed = true
            wordDesc.becomeFirstResponder()
        } else {
            //further editing is disabled
            edit.setTitle("Edit", for: .normal)
            cancel.isHidden = true
            wordDesc.isEditable = false
            confirmDisplayed = false
            //change the text at that line in the file
            if wordDesc.text != "" {
                changeText(list: jargon)
            }
        }
    }
    @IBAction func reveal(_ sender: Any) {
        wordDesc.textColor = UIColor.black
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        edit.setTitle("Edit", for: .normal)
        cancel.isHidden = true
        wordDesc.isEditable = false
        setContent(array: array)
        wordDesc.textColor = UIColor.black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordDesc.delegate = self
        jargon = jargon.lowercased()
        if jargon != "" {
            word.text = jargon
        } else {
            jargon = "noinput"
            word.text = "no input"
        }
        if fileExists(name: jargon) == true {
            fileName = jargon
        } else {
            fileName = "error"
        }
        array = findLines()
        setContent(array: array)
        if isCustom == false {
            edit.isHidden = true
        } else {
            edit.isHidden = false
        }
        wordDesc.isEditable = false
        wordDesc.textColor = UIColor.clear
    }
    
    func findLines() -> Array<String> {
        var arrayOfStrings: [String] = []
        do {
            let path = Bundle.main.path(forResource: fileName, ofType: "txt")
            if path != nil {
                let data = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                arrayOfStrings = data.components(separatedBy: "\n")
            } else {
                let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
                let data = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
                arrayOfStrings = data.components(separatedBy: "\n")
            }
        } catch let error as NSError {
            print(error)
        }
        return arrayOfStrings
    }
    
    func setContent(array: Array<String>) {
        var word = String()
        var definition = String()
        if(array[lineNumber] != "" && array[lineNumber] != " "){
            word = String(array[lineNumber].prefix(upTo: array[lineNumber].firstIndex(of: ":")!))
            definition = String(array[lineNumber].suffix(from: array[lineNumber].firstIndex(of: " ")!))
            wordDesc.text = definition
            wordLabel.text = word
            canTapBack = true
            canTap = true
            wordDesc.textColor = UIColor.clear
            if isCustom == true {
                edit.isHidden = false
            }
        } else {
            wordLabel.text = ""
            if lineNumber == 0 {
                wordDesc.text = "Can't go back any further."
                canTapBack = false
                edit.isHidden = true
                wordDesc.textColor = UIColor.black
            } else {
                wordDesc.text = "No more words in this category, please select another."
                canTap = false
                edit.isHidden = true
                wordDesc.textColor = UIColor.black
            }
        }
    }
    
    func fileExists(name: String) -> Bool {
        fileName = "allTextFiles"
        for line in findLines() {
            if line == name {
                return true
            }
        }
        
        fileName = "customLists"
        for line in findLines() {
            if line == name {
                return true
            }
        }
        return false
    }
    
    func changeText(list: String) {
        var outputText = String()
        array[lineNumber] = wordLabel.text! + ":" + wordDesc.text!
        let file = jargon
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(file).appendingPathExtension("txt")
        outputText = "\n" + copyText(array: array)
        do {
            try outputText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch { print(error) }
    }
    
    func copyText(array: Array<String>) -> String {
        var outputText = String()
        var cur = 0
        let size = array.count
        for line in array {
            if cur == size || line == "" {
                outputText.append(line)
            } else {
                outputText.append(line + "\n")
            }
            cur += 1
        }
        cur = 0
        return outputText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
