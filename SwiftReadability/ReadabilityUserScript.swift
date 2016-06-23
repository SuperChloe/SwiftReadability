//
//  ReadabilityUserScript.swift
//  SwiftReadability
//
//  Created by Chloe on 2016-06-22.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

import Foundation
import WebKit

class ReadabilityUserScript: WKUserScript {
    convenience override init() {
        let js: String
        do {
            js = try loadFile(name: "Readability", type: "js")
        } catch {
            fatalError("Couldn't load Readability.js")
        }
        
        self.init(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}
