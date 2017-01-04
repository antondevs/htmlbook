//
//  ViewController.swift
//  HtmlBook
//
//  Created by antondev on 04/01/17.
//  Copyright © 2017 engune. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    func loadPage(name:String) {
        let filePath = name.replacingOccurrences(of: "#/", with: "Data/")
        let path = Bundle.main.path(forResource: filePath, ofType: "html")
        let url = NSURL(fileURLWithPath: path!)
        
        do {
            let htmlString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
            webView.loadHTMLString(htmlString as String, baseURL: url.deletingLastPathComponent)
        } catch {
            print("Error loading page \(name) ...");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPage(name: "#/index")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func onAction(action:String) {
        
        if (action == "#action/test") {
            let alert = UIAlertController(title: "HtmlBook", message: "Native Dialog", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let pageUrl = request.url {
            let path = pageUrl.absoluteString
            
            if let range = path.range(of: "#/") {
                let pageName = path.substring(from: range.lowerBound)
                self.loadPage(name: pageName)
                return false;
            }
            
            if let range = path.range(of: "#action/") {
                let actionName = path.substring(from: range.lowerBound)
                onAction(action: actionName)
                return false;
            }
        }
        
        return true;
    }
}

