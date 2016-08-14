//
//  ChannelTableViewController.swift
//  ToKnight
//
//  Created by Adam Behrman on 8/6/16.
//  Copyright © 2016 Adam Behrman. All rights reserved.
//

import UIKit

class ChannelTableViewController: UITableViewController {

    
   // @IBOutlet var TableView: UITableView!

    
    var channels = [Channel]()
    var newChannel: String = ""
    var channelNameForVoting: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAndOpenDB()
        loadChannels()
        
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        
        loadChannels()
        tableView.reloadData()
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return channels.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = channels[indexPath.row].channelName
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let channelToDelete = channels[indexPath.row].ID
            print(channelToDelete)
            
            deleteChannel(channelToDelete)
            loadChannels()
            
            //channels.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    private func createAndOpenDB(){
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as NSString
        
        let databasePath = docsDir.stringByAppendingPathComponent(
            "ToKnightDB.sqlite")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let ToKnightDB = FMDatabase(path: databasePath as String)
            
            if ToKnightDB == nil {
                print("Error: \(ToKnightDB.lastErrorMessage())")
            }
            
            if ToKnightDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS channels (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT, eventDateTime DATETIME)"
                if !ToKnightDB.executeStatements(sql_stmt) {
                    print("Error: \(ToKnightDB.lastErrorMessage())")
                }
                
                let insertSQL = "INSERT INTO channels (name, description) VALUES ('General', 'Your personal preferences channel.')"
                
                let result = ToKnightDB.executeUpdate(insertSQL,
                                                     withArgumentsInArray: nil)
                
                if !result {
                    print("Error: \(ToKnightDB.lastErrorMessage())")
                }
                ToKnightDB.close()
            } else {
                print("Error: \(ToKnightDB.lastErrorMessage())")
            }
        }
    }
    
    private func loadChannels() {
        
        channels = []
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        let databasePath = dirPaths[0].URLByAppendingPathComponent("ToKnightDB.sqlite").path!
        print(databasePath)
        
        let ToKnightDB = FMDatabase(path: databasePath as String)
        
        ToKnightDB.open()
        
        let selectSQL = "SELECT * FROM channels ORDER BY ID"
        
        var channel = Channel()
        
        if let resultSet = ToKnightDB.executeQuery(selectSQL,
                                                  withArgumentsInArray: nil) {
            while resultSet.next(){
                
                channel.ID = Int(resultSet.intForColumn("ID"))
                channel.channelName = resultSet.stringForColumn("name")
                channel.channelDescription = resultSet.stringForColumn("description")
                
                channels.append(channel)
            }
        }
        ToKnightDB.close()
    }
    
    private func deleteChannel(channelID: Int){
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        let databasePath = dirPaths[0].URLByAppendingPathComponent("ToKnightDB.sqlite").path!
        
        
        let ToKnightDB = FMDatabase(path: databasePath as String)
        
        ToKnightDB.open()
        
        let deleteSQL = "DELETE FROM channels WHERE name = \(channelID)"
        print(deleteSQL)
        
        let result = ToKnightDB.executeUpdate(deleteSQL,
                                                   withArgumentsInArray: nil)
        if !result {
            print("Error: \(ToKnightDB.lastErrorMessage())")
        }
        
        ToKnightDB.close()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChannelVotingSegue",
            let destination = segue.destinationViewController as? VotingViewController,
            channelIndex = tableView.indexPathForSelectedRow?.row
            {
                destination.channelName = channels[channelIndex].channelName
            }
        
        if segue.identifier == "AddChannelSegue",
            let destination = segue.destinationViewController as? ChannelDetailViewController
            {
                destination.newTitle = "Add New Channel"
            }
    }
    
}
