//
//  ChannelDetailViewController.swift
//  ToKnight
//
//  Created by Adam Behrman on 8/6/16.
//  Copyright © 2016 Adam Behrman. All rights reserved.
//

import UIKit

class ChannelDetailViewController: UIViewController {
    
    
    @IBOutlet weak var channelName: UITextField!
    @IBOutlet weak var channelDescription: UITextField!
    
    @IBOutlet weak var ChannelDetailNavBar: UINavigationBar!
    
    var newTitle = ""
    var newChannelName = ""
    var newDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        print(newTitle)
        self.navigationItem.title = newTitle
        channelName.text = newChannelName
        channelDescription.text = newDescription
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "doneSegue" {
        //    strName = channelName.text!
         //   strDescription = channelDescription.text
            
            saveChannel(channelName.text!, strDescription: channelDescription.text!)

        }
    }
    
    private func saveChannel(strName: String, strDescription: String){
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        let databasePath = dirPaths[0].URLByAppendingPathComponent("ToKnightDB.sqlite").path!
        
        let ToKnightDB = FMDatabase(path: databasePath as String)
        
        ToKnightDB.open()
        
        let insertSQL = "INSERT INTO channels (name, description) VALUES ('\(strName)', '\(strDescription)')"
        print(insertSQL)
        
        let result = ToKnightDB.executeUpdate(insertSQL,
                                              withArgumentsInArray: nil)
        
        if !result {
            print("Error: \(ToKnightDB.lastErrorMessage())")
        }
        ToKnightDB.close()
    }
    

}
