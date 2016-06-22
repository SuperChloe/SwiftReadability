//
//  Readability.swift
//  SwiftReadability
//
//  Created by Chloe on 2016-06-20.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

import Foundation
import WebKit

public class Readability: NSObject, WKNavigationDelegate {
    private let webView: WKWebView
    private let completionHandler: ((content: String?, error: NSError?) -> Void)
    
    init(url: URL, completionHandler: (content: String?, error: NSError?) -> Void) {

        self.completionHandler = completionHandler
        
        webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        
        super.init()
        
        webView.configuration.suppressesIncrementalRendering = true
        webView.navigationDelegate = self
        
        addReadabilityUserScript()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func addReadabilityUserScript() {
        
    }
    
    // ***************************
    //  MARK: WKNavigationDelegate
    // ***************************
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}


