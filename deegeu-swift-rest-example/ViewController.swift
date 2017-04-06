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
        let session = URLSession.shared
        let url = URL(string: postEndpoint)!
        
         // Make the POST call and handle it in a completion handler
        session.dataTask(with: url, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? HTTPURLResponse,
                      realResponse.statusCode == 200 else {
                print("Not a 200 response")
                        return
            }
            
            // Read the JSON
            do {
                if let ipString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) {
                    // Print what we got from the call
                    print(ipString)
                
                    // Parse the JSON to get the IP
                    let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    let origin = jsonDictionary["origin"] as! String
                   
                    // Update the label
                    self.performSelector(onMainThread: #selector(ViewController.updateIPLabel(_:)), with: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        } ).resume()
    }
    
    
    func postDataToURL() {
        
        // Setup the session to make REST POST call. 
        // NOTE: The postEndpoint variable MUST be changed to match the URL created on
        // Requestb.in!
        let postEndpoint: String = "http://requestb.in/pbfw9gpb"
        let url = URL(string: postEndpoint)!
        let session = URLSession.shared
        let postParams : [String: AnyObject] = ["hello": "Hello POST world" as AnyObject]
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTask(with: request, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? HTTPURLResponse,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) as String? {
                    // Print what we got from the call
                    print("POST: " + postString)
                    self.performSelector(onMainThread: #selector(ViewController.updatePostLabel(_:)), with: postString, waitUntilDone: false)
            }

        }).resume()
    }
    
//MARK: - Methods to update the UI immediately
    func updateIPLabel(_ text: String) {
        self.ipLabel.text = "Your IP is " + text
    }
    
    func updatePostLabel(_ text: String) {
        self.postResultLabel.text = "POST : " + text
    }
}

