//
//  ReadabilityViewController.swift
//  SwiftReadability
//
//  Created by Chloe on 2016-06-20.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class ReadabilityViewController: UIViewController {
    let webView = WKWebView()
    
    override public func loadView() {
        view = webView
    }
    
    public func loadURL(url: NSURL) {
        
    }
}
