//
//  NewsViewController.swift
//  FirebaseExercise
//
//  Created by Tengli Li on 11/14/19.
//  Copyright © 2019 Tengli Li. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var WebView: WKWebView!
    
    
    
    @IBAction func refresh(_ sender: Any) {
        WebView.reload()
    }
    
    @IBAction func next(_ sender: Any) {
        if WebView.canGoForward{
            WebView.goForward()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        if WebView.canGoBack{
            WebView.goBack()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebView.navigationDelegate = self
        let url = URL(string: "https://source.wustl.edu/news/")!
        let myURLRequest = URLRequest(url: url)
        WebView.load(myURLRequest)
        WebView.allowsBackForwardNavigationGestures = true
        
        
        
        
        
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
