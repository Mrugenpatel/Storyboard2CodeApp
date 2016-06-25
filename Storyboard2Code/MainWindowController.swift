//
//  MainWindowController.swift
//  Storyboard2Code
//
//  Created by dasdom on 28.04.16.
//  Copyright © 2016 dasdom. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSTextFieldDelegate {
  
  @IBOutlet weak var dropTextField: DropTextField!
  @IBOutlet var storyboardTextView: NSTextView!
  @IBOutlet var codeTextView: NSTextView!
  var swiftCodeStrings: [String: String] = [:] {
    didSet {
      var outputString = ""
      for (_, value) in swiftCodeStrings {
        outputString += value
      }
      codeTextView.string = outputString
    }
  }
  var xmlData: Data? {
    didSet {
      if let data = xmlData {
        swiftCodeStrings = CodeCreator().codeStringsFrom(XMLdata: data)
      }
    }
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    dropTextField.addObserver(self, forKeyPath: "droppedFilePath", options: .new, context: nil)
    
    dropTextField.delegate = self
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
    if keyPath == "droppedFilePath" {
      guard let path = change?["new" as NSKeyValueChangeKey] as? String else { return }
      dropTextField.stringValue = path
      
      guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
        dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
      
      xmlData = data
      
      storyboardTextView.string = dataString as String
    }
  }
  
  override func controlTextDidChange(_ obj: Notification) {
    if let path = ((obj as NSNotification).userInfo?["NSFieldEditor"] as? NSTextView)?.string {
      print(path)
      
      dropTextField.stringValue = path
      
      guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
        dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
      
      xmlData = data
      
      storyboardTextView.string = dataString as String
    }
  }
  
  @IBAction func export(_ sender: AnyObject) {
    let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
    
    for (key, value) in swiftCodeStrings {
      let outputPath = "\(paths.first!)/\(key).swift"
      do {
        try value.write(toFile: outputPath, atomically: true, encoding: String.Encoding.utf8)
      } catch NSCocoaError.fileWriteNoPermissionError {
        print("FileWriteNoPermissionError")
      } catch {
        print("error")
      }
    }
  }
  
}
