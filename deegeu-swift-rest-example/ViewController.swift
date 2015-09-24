//
//  ViewController.swift
//  deegeu-swift-rest-example
//
//  Created by Daniel Spiess on 9/23/15.
//  Copyright © 2015 Daniel Spiess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ipLabel: UILabel!
    
    @IBOutlet weak var postResultLabel: UILabel!

//MARK: - viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call our two REST services
        updateIP()
        postDataToURL()
    }

    
//MARK: - REST calls
    // This makes the GET call to httpbin.org. It simply gets the IP address and displays it on the screen.
    func updateIP() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "https://httpbin.org/ip"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
         // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                      realResponse.statusCode == 200 else {
                print("Not a 200 response")
                        return
            }
            
            // Read the JSON
            do {
                if let ipString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(ipString)
                
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let origin = jsonDictionary["origin"] as! String
                   
                    // Update the label
                    self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    
    func postDataToURL() {
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://requestb.in/r4jz64r4"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["hello": "Hello POST world"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                    // Print what we got from the call
                    print("POST: " + postString)
                    self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
            }

        }).resume()
    }
    
//MARK: - Methods to update the UI immediately
    func updateIPLabel(text: String) {
        self.ipLabel.text = "Your IP is " + text
    }
    
    func updatePostLabel(text: String) {
        self.postResultLabel.text = "POST : " + text
    }
}

