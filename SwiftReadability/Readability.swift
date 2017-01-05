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
    private let completionHandler: ((_ content: String?, _ error: Error?) -> Void)
    private var hasRenderedReadabilityHTML = false
    
    init(url: URL, completionHandler: @escaping (_ content: String?, _ error: Error?) -> Void) {

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
            let template = try loadFile(name: "Reader.template", type: "html")
            
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
    
    private func initializeReadability(completionHandler: @escaping (_ html: String?, _ error: Error?) -> Void) {
        let readabilityInitializationJS: String
        do {
            readabilityInitializationJS = try loadFile(name: "readability_initialization", type: "js")
        } catch {
            fatalError("Couldn't load readability_initialization.js")
        }
        
        webView.evaluateJavaScript(readabilityInitializationJS) { [weak self] (result, error) in
            guard let result = result as? String else {
                self?.completionHandler(nil, error)
                return
            }
            guard let html = self?.renderHTML(readabilityContent: result) else { return }
            completionHandler(html, nil)
        }
    }
    
    private func updateImageMargins(completionHandler: @escaping (_ html: String?, _ error: Error?) -> Void) {
        let readabilityImagesJS: String
        do {
            readabilityImagesJS = try loadFile(name: "readability_images", type: "js")
        } catch {
            fatalError("Couldn't load readability_images.js")
        }
        
        webView.evaluateJavaScript(readabilityImagesJS) { [weak self] (result, error) in
            guard let result = result as? String else {
                self?.completionHandler(nil, error)
                return
            }
            completionHandler(result, nil)
        }
    }
    
    // ***************************
    //  MARK: WKNavigationDelegate
    // ***************************
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !hasRenderedReadabilityHTML {
            initializeReadability() { [weak self] (html: String?, error: Error?) in
                self?.hasRenderedReadabilityHTML = true
                guard let html = html else {
                    self?.completionHandler(nil, error)
                    return
                }
                _ = self?.webView.loadHTMLString(html, baseURL: self?.webView.url?.baseURL)
            }
        } else {
            updateImageMargins() { [weak self] (html: String?, error: Error?) in
                if let f = html {
                    print(f)
                }
                self?.completionHandler(html, error)
            }
        }
    }
}


