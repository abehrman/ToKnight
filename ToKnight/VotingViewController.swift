//
//  MainViewController.swift
//  ToKnight
//
//  Created by Adam Behrman on 6/14/16.
//  Copyright © 2016 Adam Behrman. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class VotingViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var StartLabel: UILabel!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    let ED = EventFulDownload()
    
    var events = [EventFulDownload.EventDetails()]
    
    var eventCounter = 0
    var page = 1
    
    var channelName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        print("Downloading page " + String(page))
//        events = ED.downloadEvents(page)
//        DisplayEvent(0)
//        print("Width: " + String(eventImage.bounds.width))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print(channelName)
        self.navigationItem.title = channelName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func Dislike(sender: UIButton) {
        eventCounter += 1
        if eventCounter == 100 {
            page += 1
            print("Downloading page " + String(page))
            events = ED.downloadEvents(page)
            eventCounter = 0
        }
        DisplayEvent(eventCounter)
        
    }
    
    @IBAction func Nah(sender: UIButton) {
        eventCounter -= 1
        if eventCounter == -1 {
            eventCounter = 0
        }
        DisplayEvent(eventCounter)

    }
    private func DisplayEvent(eventCounter: Int) {
        let event = events[eventCounter]
        
//        do
//        {
//            if event.description != nil {
//                let attrStr = try! NSAttributedString(data: (event.description?.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
//                
//                DescriptionLabel.attributedText = attrStr
//            }
//            else {
//                DescriptionLabel.text = ""
//            }
//            
//        }
        
        
        titleLabel.text = event.title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = dateFormatter.dateFromString(event.start_time!)!
        
        dateFormatter.dateFormat = "M/d/yy @ h:mm a"
        StartLabel.text = dateFormatter.stringFromDate(currentDate)
        //DescriptionLabel.attributedText = attrStr
        
        if event.imageURL != nil {
            let url = NSURL(string: event.imageURL!)
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            print(url!)
            eventImage.image = UIImage(data: data!)
            eventImage.contentMode = UIViewContentMode.ScaleToFill
            print(eventImage.bounds.height)
            
        }
        else {
            eventImage.image = nil
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditChannelSegue",
            let destination = segue.destinationViewController as? ChannelDetailViewController
        {
            destination.newTitle = "Edit Channel"
            print(channelName)
            destination.newChannelName = channelName
        }
        
    }


}

