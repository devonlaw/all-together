//
//  CreateCustom.swift
//  jargon-rewrite
//
//  Created by Devon Law on 2019-07-09.
//  Copyright © 2019 Slackers. All rights reserved.
//

import Foundation
import UIKit

class CreateCustom: UIViewController, UITextViewDelegate {
    var fileName = String()
    var addWord = false
    var fileURL: URL?
    var outputText = String()
    @IBOutlet weak var topic: UITextField!
    @IBOutlet weak var word: UITextField!
    @IBOutlet weak var definition: UITextView!
    @IBOutlet weak var exists: UILabel!
    
    //this function will put the data from a file into an array
    func findLines() -> Array<String> {
        var arrayOfStrings: [String] = []
        
        do {
            let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let file = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
            let data = try String(contentsOf: file, encoding: String.Encoding.utf8)
            arrayOfStrings = data.components(separatedBy: "\n")
            
        } catch let error as NSError {
            print(error)
        }
        return arrayOfStrings
    }
    
    //this function will check and see if the list being created is already one of the premade ones
    func fileExists(name: String) -> Bool {
        fileName = "allTextFiles"
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
    
    //this function will check if the list being created has already been created
    func customfileExists(name: String) -> Bool {
        fileName = "customLists"
        
        let file = "customLists"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            fileURL = DocumentDirURL.appendingPathComponent(file).appendingPathExtension("txt")
        do {
            try copyText(array: findLines()).write(to: fileURL!, atomically: true, encoding: String.Encoding.utf8)
        } catch { print(error) }
        
        for line in findLines() {
            if line == name {
                return true
            }
        }
        return false
    }
    
    //this function will copy all the data in an array of strings, and put it into one string for appending
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
    
    //what happens when the user taps "add"
    @IBAction func add(_ sender: Any) {
        
        //1. make sure all the fields have data in them
        if (topic.text != nil && word.text != nil && definition.text != nil) {
        
        
            //2. check if the file is one of the premades (fileExists)
            if (fileExists(name: topic.text!) == false) {
                //hide the "Already Exists" label
                exists.isHidden = true
        
                //3. check if the file has already been created (customFileExists)
                if (customfileExists(name: topic.text!) == true) {
                    //if yes -> just add the word and definition to the end of that file
                    fileName = topic.text!
                    outputText = "\n" + copyText(array: findLines())
                    outputText.append(word.text! + ": " + definition.text! + "\n")
                    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
                    do {
                        try outputText.write(to: fileURL!, atomically: true, encoding: String.Encoding.utf8)
                    } catch { print(error) }
                    
                    
                } else {
                   //else (no) -> add the topic to the custom list file and create the text file with the first word and definition
                    fileName = "customLists"
                    outputText = copyText(array: findLines())
                    outputText.append(topic.text!)
                    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
                    do {
                        try outputText.write(to: fileURL!, atomically: true, encoding: String.Encoding.utf8)
                    } catch { print(error) }
                    
                    outputText = "\n" + word.text! + ": " + definition.text! + "\n"
                    let file = topic.text!
                    fileURL = DocumentDirURL.appendingPathComponent(file).appendingPathExtension("txt")
                    do {
                        try outputText.write(to: fileURL!, atomically: true, encoding: String.Encoding.utf8)
                    } catch { print(error) }
                }
                
            } else {
                //2.1. if it is then inform the user that it already exists and clear all fields
                topic.text = ""
                //show the "Already Exists label"
                exists.isHidden = false
            }
        }
        //4. clear the word and reset the definition field
        word.text = ""
        definition.text = "Definition..."
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definition.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
