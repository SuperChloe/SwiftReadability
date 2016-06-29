//
//  ViewController.swift
//  SwiftReadabilityExample
//
//  Created by Chloe on 2016-06-29.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

import SwiftReadability
import UIKit

class ViewController: ReadabilityViewController {
    
//    let articleURL = URL(string: "http://www.cnn.com/2016/06/27/foodanddrink/german-beer-purity-us-beer-gardens/index.html")
//    let articleURL = URL(string: "https://ca.yahoo.com/?p=us")
    let articleURL = URL(string: "https://github.com/blog/2195-the-shape-of-open-source")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let articleURL = articleURL else { return }
        
        loadURL(url: articleURL)
    }
}

