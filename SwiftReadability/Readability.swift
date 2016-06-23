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
        let script = ReadabilityUserScript()
        webView.configuration.userContentController.addUserScript(script)
    }
    
    private func renderHTML(readabilityContent: String) -> String {
        do {
            let template = try loadFile(name: "Reader.html", type: "template")
            
            let mozillaCSS = try loadFile(name: "Reader", type: "css")
            let swiftReadabilityCSS = try loadFile(name: "SwiftReadability", type: "css")
            let css = mozillaCSS + swiftReadabilityCSS
            
            let html = template
                .replacingOccurrences(of: "##CSS##", with: css)
                .replacingOccurrences(of: "##CONTENT##", with: readabilityContent)
            
            return html
            
        } catch {
            // TODO: Need better error handling
            fatalError("Failed to render Readability HTML")
        }
    }
    
    // ***************************
    //  MARK: WKNavigationDelegate
    // ***************************
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let readabillityInitializationJS: String
        do {
            readabillityInitializationJS = try loadFile(name: "readability_initialization", type: "js")
        } catch {
            fatalError("Couldn't load readability_initialization.js")
        }
        
        webView.evaluateJavaScript(readabillityInitializationJS) { [weak self] (result, error) in
            guard let result = result as? String else { return }
            guard let html = self?.renderHTML(result) else { return }
            self?.completionHandler(content: html, error: error)
        }
    }
}


