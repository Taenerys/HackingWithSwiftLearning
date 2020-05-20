//
//  ViewController.swift
//  Project4
//
//  Created by Pham Ha Thu Anh on 2020/05/18.
//  Copyright © 2020 AnhWorld. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate { //class is our parent, but we'll promise we'll listen to the protocol
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websiteToLoad: String?
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self //delgation - a programming pattern used a lot in iOS: easy to understand etc. => "when any web page navigation happens, please tell me"
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://" + websiteToLoad!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        
        toolbarItems = [progressButton, backButton, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet) //ask users for more info
//        ac.addAction(UIAlertAction(title: websiteToLoad!, style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
//    func openPage(action: UIAlertAction) {
//        let url = URL(string: "https://" + action.title!)!
//        webView.load(URLRequest(url: url))
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title //update the title to the title of the page that is most likely accessed
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" { //estimatedProgress is a Double
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        var urlAllowed = true
        
        if let host = url?.host {
            if host.contains(websiteToLoad!) {
                urlAllowed = true
                decisionHandler(.allow)
                return
            } else {
                urlAllowed = false
            }
        }
        decisionHandler(.cancel)
        if (urlAllowed == false) {
            let ac = UIAlertController(title: "Alert", message: "This website has been blocked", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK Stop", style: .cancel))
            present(ac, animated: true)
        }
    }


}

