//
//  EventDownload.swift
//  ToKnight
//
//  Created by Adam Behrman on 6/29/16.
//  Copyright © 2016 Adam Behrman. All rights reserved.
//

// Downloads events from Eventful

import Foundation

class EventFulDownload {
    
    var events: [EventDetails] = []
    
    struct EventDetails {
        var title: String?
        var description: String?
        var start_time: String?
        var longitude: Double?
        var latitude: Double?
        var imageURL: String?
        
    }
    
    func downloadEvents(page: Int) -> [EventDetails] {
        
        print("Delete existing events")
        events.removeAll()
        
        let URL = CreateURL(page)
        queryEventFul(URL)
        return self.events
    }
    
    private func CreateURL(page: Int) -> String {
        print("Creating URL")
        let rootURL = "http://api.eventful.com/json/events/search?"
        
        let location = "07310"
        let within = "50"
        let date = "Today"
        //let include = "categories,subcategories,tickets,price,links"
        let page_size = "100" //maxes at 100
        var sort_order = "popularity"   //popularity, date, [relevance]
        let categories = assignCategories()
        
        
        
        var searchParams = "location=" + location
        searchParams += "&within=" + within
        searchParams += "&date=" + date
        //searchParams += "&include=" + include
        searchParams += "&page_size=" + page_size
        searchParams += "&page_number=" + String(page)
        searchParams += "&sort_order=" + sort_order
        searchParams += "&category=" + categories
        
        
        
        
        let appkey = "&app_key=3gq43xCC9mqJHd3W"
        
        let urlPath: String = rootURL + searchParams + appkey
    
        return urlPath
    }
    
    private func queryEventFul(urlPath: String) {
        print("Querying URL")
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            do {
                
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: .AllowFragments)
                
                if let events = jsonResult as? [String:AnyObject] {
                    
                    readJSONObject(events)
                }
                
                
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    
    private func readJSONObject(object: [String: AnyObject]) {
        
        print("Reading JSON")
        
        var currentEvent = EventDetails(
            title: nil,
            description: nil,
            start_time: nil,
            longitude: nil,
            latitude: nil,
            imageURL: nil
        )
        
        let eventsDict = object["events"] as! [String: AnyObject]
        
        let eventList = eventsDict["event"] as! [[String: AnyObject]]
        
        var x = 0
        print("Parsing events")
        for event in eventList {
            
            
            x = x + 1
            //let title = event["title"] as! String
            
            //print(x)
            //print(title)
            
            currentEvent.title = event["title"] as? String
            currentEvent.description = event["description"] as? String
            currentEvent.latitude = Double(event["latitude"] as! String)!
            currentEvent.longitude = Double(event["longitude"] as! String)!
            currentEvent.start_time = event["start_time"] as? String
            
            if event["image"] is NSNull {
            
                currentEvent.imageURL = nil
            } else {
                
                let image = event["image"]! as? [String: AnyObject]
                //let mediumImg = image!["medium"]
                
                //let mediumImg = imageList[0] //as! [[String: AnyObject]]
                //print(mediumImg)
                
                let img: Dictionary = image!
                
                let medium = img["medium"]! as? [String: String]
                
                currentEvent.imageURL = medium!["url"]!
                
                currentEvent.imageURL = (currentEvent.imageURL! as NSString).stringByReplacingOccurrencesOfString("medium", withString: "edpborder500")
                
            }
            
            
            
            events.append(currentEvent)
            
        }
        
        
        
    }
    
    
    private func assignCategories() -> String {
        print ("Assigning categories")
        var cats: [String] = []
        
        cats.append("music_country")
        cats.append("music_dance")
        cats.append("music_easy_listening")
        cats.append("music_electronic")
        cats.append("music_jazz")
        cats.append("music_latin")
        cats.append("music_newage")
        cats.append("music_rb")
        cats.append("music_reggae")
        cats.append("music_vocal")
        cats.append("music_hiphop")
        cats.append("music_metal")
        cats.append("music_rock")
        cats.append("music_pop")
        cats.append("music_alternative")
        cats.append("comedy")
        cats.append("family_fun_kids")
        cats.append("festivals_parades")
        cats.append("movies_film")
        cats.append("food")
        cats.append("art")
        cats.append("performing_arts")
        cats.append("sports")
        
        var tmpStr: String
        
        tmpStr = cats[0]
        
        for i in 1..<cats.count {
            tmpStr += "," + cats[i]
        }
        
        return tmpStr
        
        
    }
    
    
}