//
//  HybridViewController.swift
//  js-talk
//
//  Created by JERRY LIU on 28/11/2016.
//  Copyright © 2016 LionIQ. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class HybridViewController: UIViewController {
    
    @IBOutlet weak var webviewPlaceholder: UIView!
    
    var webview: WKWebView?
    
    override func viewDidLoad() {
        let itemKey = "1074578361b531a8dfe6fb6f1e9bf5d7"
        
        setupWebview()
        
        loadWebview()
    }
    
    private func setupWebview() {
        webview = WKWebView(frame: webviewPlaceholder.frame)
        self.view.addSubview(webview!)
    }
    
    private func loadWebview() {
        
        // local assets
        let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "webviews")!
        
        let webviewsURL = Bundle.main.bundleURL.appendingPathComponent("webviews", isDirectory: true)
        
        webview!.loadFileURL(htmlURL, allowingReadAccessTo: webviewsURL)
    }
}
